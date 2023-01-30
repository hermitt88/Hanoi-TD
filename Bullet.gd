extends Area2D

const colorWhite = Color(255, 255, 255, 1)
const colorRed = Color(255, 0, 0, 1)
var screen_size
var speed = 450

var damage

#signal damage(dmg)

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("bullets")

func _process(delta):
	update()
	if position.x > screen_size.x:
		queue_free()
	else:
		position.x += speed * delta

func _draw():
	draw_circle(Vector2.ZERO, 10, colorRed)
