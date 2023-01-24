extends Node2D

var Tower = preload("res://Tower.tscn")

func _ready():
	three_towers()
	
#func _process(delta):
	

func three_towers():
	for i in [0, 1, 2]:
		var new_Tower = Tower.instance()
		new_Tower.position = Vector2(256 + 128 * i, 384)
		add_child(new_Tower, true)
	
