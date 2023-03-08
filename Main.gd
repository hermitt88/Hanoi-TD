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

signal handleDisk()
signal newDiskOnHand(newDisk)

onready var Towers = $Towers
onready var Player = $Player

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
		var newDisk
		if Player.onHand:
			newDisk = null
		else:
			newDisk = randi() % 3 + 1
		emit_signal("newDiskOnHand", newDisk)
	
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
		emit_signal("handleDisk")
	update()

func three_towers():
	for i in [0, 1, 2]:
		var new_Tower = Tower.instance()
		new_Tower.position = Vector2(256 + 128 * i, 576)
		if i == 0:
			new_Tower.diskArray = [3, 2, 1]
		Towers.add_child(new_Tower, true)
