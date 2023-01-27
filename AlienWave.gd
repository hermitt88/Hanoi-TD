extends PathFollow2D

#onready var AlienTimer = get_node("./AlienTimer")
#var AlienBeige = preload("res://AlienBeige.tscn")

var speed = 150

var hp = 20

onready var box = $HBoxContainer/ColorRect

func _ready():
	box.anchor_left = 0
	box.anchor_right = 1
	box.anchor_top = 0
	box.anchor_bottom = 1

func _process(delta):
	if hp < 0:
		queue_free()

	#var new_offset = get_offset() + speed * delta
	var progress = get_unit_offset()
	if progress < 1:
		set_offset(get_offset() + speed * delta)
	else:
		$AlienBeige/AnimatedSprite.play("swim")
		yield($AlienBeige/AnimatedSprite, "animation_finished")
		queue_free()


func _on_AlienBeige_area_entered(area):
	if area.is_in_group("bullets"):
		hp -= area.damage
		box.anchor_right = hp / 20
		area.queue_free()
