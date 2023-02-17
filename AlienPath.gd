extends Path2D

var AlienWave = preload("res://AlienWave.tscn")

func _ready():
	randomize()
	testWave()

func testWave():
	var new_AlienWave = AlienWave.instance()
	new_AlienWave.get_child(0).position.y -= randi() % 10
	add_child(new_AlienWave, true)
	yield(get_tree().create_timer(2), "timeout")
	testWave()
