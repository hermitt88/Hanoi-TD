extends Node2D

var playerVisiting
var playerHand
var currentDiskArray
var currentTowerLevel

var screen_size

var cellSize = 64
var diskThickness = 28

const colorWhite = Color(255, 255, 255, 1)
const colorRed = Color(255, 0, 0, 1)
const colorGreen = Color(0, 255, 0, 1)
const colorBlue = Color(0, 0, 255, 1)

signal handleDisk()

onready var Towers = $Towers
onready var Player = $Player

onready var GameTimerText = $UI/GameTimerText
onready var moveCounterText = $UI/moveCounterText
var moveCounter
var timeRef
var timeNow

var Tower = preload("res://Tower.tscn")

func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	playerVisiting = -1
	playerHand = null
	currentDiskArray = []
	currentTowerLevel = -1
	three_towers()
	timeNow = 0
	timeRef = 0
	moveCounter = 0
	Player.connect("countMove", self, "_on_countMove")

func _process(delta):
	timeNow += delta
	GameTimerText.text = "%.1f" % (timeNow - timeRef)
	
	# Test Key: R(Reset towers), F(Reset towers and clock)
	if Input.is_action_just_pressed("reset_towers"):
		reset_towers()
	
	if Input.is_action_just_pressed("reset_simulation"):
		reset_towers()
		timeRef = timeNow
		moveCounter = 0
		moveCounterText.text = "MOVE: " + str(moveCounter)
	
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("handleDisk")
	update()

func reset_towers():
	for i in Towers.get_children():
		i.queue_free()
	three_towers()

func three_towers():
	for i in [0, 1, 2]:
		var new_Tower = Tower.instance()
		new_Tower.position = Vector2(120 + 240 * i, 896)
		if i == 0:
			new_Tower.diskArray = [3, 2, 1]
		Towers.add_child(new_Tower, true)

func _on_countMove():
	moveCounter += 1
	moveCounterText.text = "MOVE: " + str(moveCounter)
