extends Path2D

var AlienWave = preload("res://AlienWave.tscn")

#var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	testWave()

func testWave():
	var new_AlienWave = AlienWave.instance()
	new_AlienWave.get_child(0).position.y -= randi() % 10
	add_child(new_AlienWave, true)
	yield(get_tree().create_timer(1.5), "timeout")
	testWave()
	#new_AlienWave.connect("towerSignal", self, "_on_Tower_towerSignal")
