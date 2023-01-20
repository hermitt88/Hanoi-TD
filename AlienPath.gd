extends PathFollow2D

var speed = 50

func _process(delta):
	var new_offset = get_offset() + speed * delta
	set_offset(new_offset)
