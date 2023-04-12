extends Area2D

onready var Main = get_node("..")
onready var Towers = get_node("../Towers")

var velocity = Vector2()
var speed = 200

var screen_size

var onHand = null
var cellSize = 64
var diskThickness = 28

var visiting
var lastVisited
signal showGhost(tower, color, disk)

const colorWhite = Color(255, 255, 255, 1)
const colorRed = Color(255, 0, 0, 1)
const colorRedGhost = Color(255, 0, 0, 0.9)
const colorGreen = Color(0, 255, 0, 1)
const colorBlue = Color(0, 0, 255, 1)
const colorBlueGhost = Color(0, 0, 255, 0.9)

func _ready():
	screen_size = get_viewport_rect().size
	visiting = null
	Main.connect("newDiskOnHand", self, "_on_newDisk")
	Main.connect("handleDisk", self, "_on_handleDisk")

func _process(delta):
	if get_overlapping_areas():
		visiting = get_overlapping_areas().front()
		if visiting != lastVisited:
			lastVisited = visiting
		if onHand:
			var diskArray = visiting.get("diskArray")
			var towerLevel = visiting.get("towerLevel")
			if !diskArray or diskArray.size() < towerLevel and onHand < diskArray[-1]:
				emit_signal("showGhost", visiting, colorBlueGhost, onHand)
			else:
				emit_signal("showGhost", visiting, colorRedGhost, onHand)
		else:
			emit_signal("showGhost", visiting, null, onHand)
			
	else:
		emit_signal("showGhost", lastVisited, null, onHand)
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
		draw_disk(1, onHand, colorWhite)

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

func _on_handleDisk():
	if visiting:
		var diskArray = visiting.get("diskArray")
		var towerLevel = visiting.get("towerLevel")
		if onHand:
			if !diskArray or diskArray.size() < towerLevel and onHand < diskArray[-1]:
				diskArray.append(onHand)
				onHand = null
		else:
			if diskArray:
				onHand = diskArray.pop_back()
		visiting.set("diskArray", diskArray)
					
		pass

func _on_newDisk(newHand):
	onHand = newHand
