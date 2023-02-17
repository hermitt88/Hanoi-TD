extends Node2D

var hp = 50

func _ready():
	$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("walk")

func _process(_delta):
	if hp < 0:
		queue_free()

