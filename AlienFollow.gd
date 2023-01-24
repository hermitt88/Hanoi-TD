extends PathFollow2D

#onready var AlienTimer = get_node("./AlienTimer")
#var AlienBeige = preload("res://AlienBeige.tscn")

var speed = 150

func _process(delta):
	#var new_offset = get_offset() + speed * delta
	var progress = get_unit_offset()
	if progress < 1:
		set_offset(get_offset() + speed * delta)
	else:
		$AnimatedSprite.play("swim")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
