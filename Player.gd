extends Area2D

var velocity = Vector2()
var speed = 200

var screen_size

var onHand = null
var cellSize = 64
var diskThickness = 28

const colorWhite = Color(255, 255, 255, 1)

#signal playerSignal(onHand)

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
	if velocity.length():
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.play("idle")
	
	position += velocity * speed * delta
	#velocity = move_and_slide(velocity * speed)
	position.x = clamp(position.x, 0, screen_size.x)
	
	update()

func _draw():
	if onHand:
		draw_disk(5, onHand)

func draw_disk(height, diskLevel):
	var center = Vector2(0, -cellSize * height)
	var circleCenter1 = center + Vector2.LEFT * diskThickness * diskLevel * 0.5
	var circleCenter2 = center + Vector2.RIGHT * diskThickness * diskLevel * 0.5
	var circleRadius = diskThickness * 0.5
	var rectStart = center + Vector2.LEFT * diskThickness * diskLevel * 0.5 + Vector2.UP * diskThickness * 0.5
	var rectSize = Vector2(diskThickness * diskLevel, diskThickness)
	draw_circle(circleCenter1, circleRadius, colorWhite)
	draw_circle(circleCenter2, circleRadius, colorWhite)
	draw_rect(Rect2(rectStart, rectSize), colorWhite)


#func _on_Player_area_entered(_area):
#	if onHand:
#		emit_signal("playerSignal", onHand)

func _on_Main_updateHand(to):
	onHand = to
