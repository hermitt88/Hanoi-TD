extends PathFollow2D

#onready var AlienTimer = get_node("./AlienTimer")
#var AlienBeige = preload("res://AlienBeige.tscn")

var speed = 150

var hp
var alive

onready var hpBar = $TextureProgress

func _ready():
	hpBar.value = 100
	hp = 20
	alive = true
	$AlienBeige/AnimatedSprite.play("walk")

func _process(delta):
	if hp <= 0:
		if alive:
			alive = false
			hpBar.visible = false
			$AlienBeige/AnimatedSprite.play("hurt")
			yield(get_tree().create_timer(0.5), "timeout")
			queue_free()
		else:
			pass

	else:
		var progress = get_unit_offset()
		if progress < 1:
			set_offset(get_offset() + speed * delta)
		else:
			$AlienBeige/AnimatedSprite.play("swim")
			yield($AlienBeige/AnimatedSprite, "animation_finished")
			queue_free()


func _on_AlienBeige_area_entered(area):
	if alive and area.is_in_group("bullets"):
		hp -= area.damage
		hpBar.value = hp / 20 * 100
		area.queue_free()
