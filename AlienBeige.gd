extends Node2D

func _ready():
	$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("walk")

#func _process(_delta):
	
