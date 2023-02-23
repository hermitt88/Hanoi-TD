extends Area2D

onready var PlayerCam = $PlayerCam

var velocity = Vector2()
var speed = 200

var screen_size

var onHand = null
var cellSize = 64
var diskThickness = 28

var visiting
var lastVisited
signal visitingTower()

const colorWhite = Color(255, 255, 255, 1)
const colorRed = Color(255, 0, 0, 1)
const colorGreen = Color(0, 255, 0, 1)
const colorBlue = Color(0, 0, 255, 1)

func _ready():
	screen_size = get_viewport_rect().size
	visiting = null

func _process(delta):
	
	#get_overlapping_areas() 사용해서 코드 깔끔하게 정리할 것
	if get_overlapping_areas():
		visiting = get_overlapping_areas().front()
		if visiting != lastVisited:
			lastVisited = visiting
			print(visiting.get("diskArray"))
	else:
		lastVisited = null
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
	if velocity.length():
		$AnimatedSprite.play("walk")
		$AnimatedSprite.set("flip_h", velocity.x < 0)
	else:
		$AnimatedSprite.play("idle")
	
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	
	update()

func _draw():
	if onHand:
		draw_disk(6, onHand, colorWhite)

func draw_disk(height, diskLevel, diskColor):
	var center = Vector2(0, -cellSize * height)
	var circleCenter1 = center + Vector2.LEFT * diskThickness * diskLevel * 0.5
	var circleCenter2 = center + Vector2.RIGHT * diskThickness * diskLevel * 0.5
	var circleRadius = diskThickness * 0.5
	var rectStart = center + Vector2.LEFT * diskThickness * diskLevel * 0.5 + Vector2.UP * diskThickness * 0.5
	var rectSize = Vector2(diskThickness * diskLevel, diskThickness)
	draw_circle(circleCenter1, circleRadius, diskColor)
	draw_circle(circleCenter2, circleRadius, diskColor)
	draw_rect(Rect2(rectStart, rectSize), diskColor)

func _on_Main_updateHand():
	pass
