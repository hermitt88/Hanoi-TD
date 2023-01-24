extends Path2D

var AlienBeige = preload("res://AlienBeige.tscn")

func _ready():
	testWave()
	
#func _process(delta):
	

func testWave():
	var new_AlienBeige = AlienBeige.instance()
	add_child(new_AlienBeige, true)
	yield(get_tree().create_timer(3), "timeout")
	testWave()
	
