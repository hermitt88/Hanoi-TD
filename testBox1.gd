class_name Tower
extends Area2D

var playerHere = false
var towerIndex
var towerCapacity
var cellSize = 64
var rodWidth = 16
var diskThickness = 40
signal towerSignal(towerIndex, playerHere, towerArray, towerCapacity)

var colorWhite = Color(255, 255, 255, 1)

var towerArray = Array()

func _ready():
	towerIndex = self.get_index()
	towerCapacity = 3

func _process(_delta):
	if towerArray:
		$Label.text = String(towerArray)
	else:
		$Label.text = "Empty"
	update()

func _draw():
	for i in towerArray.size():
		draw_disk(i, towerArray[i])

func draw_disk(height, diskLevel):
	var center = Vector2(rodWidth * 0.5, cellSize * (towerCapacity - height - 0.5))
	var circleCenter1 = center + Vector2.LEFT * diskThickness * diskLevel * 0.5
	var circleCenter2 = center + Vector2.RIGHT * diskThickness * diskLevel * 0.5
	var circleRadius = diskThickness * 0.5
	var rectStart = center + Vector2.LEFT * diskThickness * diskLevel * 0.5 + Vector2.UP * diskThickness * 0.5
	var rectSize = Vector2(diskThickness * diskLevel, diskThickness)
	draw_circle(circleCenter1, circleRadius, colorWhite)
	draw_circle(circleCenter2, circleRadius, colorWhite)
	draw_rect(Rect2(rectStart, rectSize), colorWhite)
	

func _on_testBox_area_entered(area):
	if area.get_name() == "Player":
		$ColorRect.modulate = Color(0, 0, 255, 0.1)
		playerHere = true
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerCapacity)

func _on_testBox_area_exited(area):
	if area.get_name() == "Player":
		$ColorRect.modulate = colorWhite
		playerHere = false
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerCapacity)


func _on_Main_updateTower(nth, to):
	if towerIndex == nth:
		towerArray = to
