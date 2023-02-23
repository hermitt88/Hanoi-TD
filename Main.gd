extends Node2D

var playerVisiting
var playerHand
var currentDiskArray
var currentTowerLevel

var cellSize = 64
var diskThickness = 28

const colorWhite = Color(255, 255, 255, 1)
const colorRed = Color(255, 0, 0, 1)
const colorGreen = Color(0, 255, 0, 1)
const colorBlue = Color(0, 0, 255, 0.5)

signal updateTower(nth, to)
signal updateHand()

onready var Towers = $Towers

onready var GameTimerText = $Player/PlayerCam/GameTimerText
var timeRef
var timeNow

var Tower = preload("res://Tower.tscn")

func _ready():
	randomize()
	playerVisiting = -1
	playerHand = null
	currentDiskArray = []
	currentTowerLevel = -1
	three_towers()
	timeNow = 0
	timeRef = 0

func _process(delta):
	timeNow += delta
	GameTimerText.text = "%.1f" % (timeNow - timeRef)
	
	# Test Key: Enter(Generate/Eliminate a Disk), R(Clear wave), F(Reset towers)
	if Input.is_action_just_pressed("ui_accept"):
		if playerHand:
			playerHand = null
		else:
			playerHand = randi() % 3 + 1
		emit_signal("updateHand", playerHand)
	
	if Input.is_action_just_pressed("clear_wave"):
		timeRef = timeNow
		for i in $AlienPath.get_children():
			i.queue_free()
			
	if Input.is_action_just_pressed("reset_towers") or Input.is_action_just_pressed("reset_simulation"):
		for i in Towers.get_children():
			i.queue_free()
		three_towers()
	
	if Input.is_action_just_pressed("reset_simulation"):
		timeRef = timeNow
		pass
	
	if Input.is_action_just_pressed("ui_select"):
		if playerVisiting != -1:
			print("Interacting with Tower#", playerVisiting)
			if playerHand:
				if !currentDiskArray or currentDiskArray.size() < currentTowerLevel and playerHand < currentDiskArray[-1]:
					currentDiskArray.append(playerHand)
					playerHand = null
			else:
				if currentDiskArray:
					playerHand = currentDiskArray.pop_back()
			
			emit_signal("updateTower", playerVisiting, currentDiskArray)
			emit_signal("updateHand", playerHand)
		else:
			print("please visit anywhere")
	update()

func _draw():
	if playerVisiting != -1 and playerHand and (!currentDiskArray or currentDiskArray.size() < currentTowerLevel and playerHand < currentDiskArray[-1]):
		draw_disk(4, playerHand, colorBlue)


func three_towers():
	for i in [0, 1, 2]:
		var new_Tower = Tower.instance()
		new_Tower.position = Vector2(256 + 128 * i, 576)
		if i == 0:
			new_Tower.diskArray = [3, 2, 1]
		Towers.add_child(new_Tower, true)
		new_Tower.connect("towerSignal", self, "_on_Tower_towerSignal")

func _on_Tower_towerSignal(towerIndex, playerHere, diskArray, towerLevel):
	if playerHere:
		playerVisiting = towerIndex
	else:
		playerVisiting = -1
	currentDiskArray = diskArray
	currentTowerLevel = towerLevel

func draw_disk(height, diskLevel, diskColor):
	var center = Vector2(0, cellSize * (-height + 0.5))
	var circleCenter1 = center + Vector2.LEFT * diskThickness * diskLevel * 0.5
	var circleCenter2 = center + Vector2.RIGHT * diskThickness * diskLevel * 0.5
	var circleRadius = diskThickness * 0.5
	var rectStart = center + Vector2.LEFT * diskThickness * diskLevel * 0.5 + Vector2.UP * diskThickness * 0.5
	var rectSize = Vector2(diskThickness * diskLevel, diskThickness)
	draw_circle(circleCenter1, circleRadius, diskColor)
	draw_circle(circleCenter2, circleRadius, diskColor)
	draw_rect(Rect2(rectStart, rectSize), diskColor)

#func _on_Player_playerSignal(onHand):
#	playerHand = onHand
