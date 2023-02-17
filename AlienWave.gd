extends PathFollow2D

var speed = 150

var hp
var alive
var freeze
var freezeTime

onready var hpBar = $TextureProgress

func _ready():
	hp = 20
	hpBar.max_value = hp
	hpBar.value = hp
	alive = true
	freeze = false
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
		if progress == 1:
			$AlienBeige/AnimatedSprite.play("swim")
			yield($AlienBeige/AnimatedSprite, "animation_finished")
			queue_free()
		else:
			if !freeze:
				set_offset(get_offset() + speed * delta)


func _on_AlienBeige_area_entered(area):
	if alive and area.is_in_group("bullets"):
		hp -= area.damage
		hpBar.value = hp
		if area.atkPierce == 0:
			area.queue_free()
		area.atkPierce -= 1
		area.damage *= 0.5
		if area.atkFreeze:
			freeze = true
			$AlienBeige.modulate = Color(0, 0, 1)
			$AlienBeige/AnimatedSprite.stop()
			yield(get_tree().create_timer(area.atkFreeze), "timeout")
			if alive:
				$AlienBeige/AnimatedSprite.play()
				$AlienBeige.modulate = Color(1, 1, 1)
				freeze = false
