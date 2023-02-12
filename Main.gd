extends Node2D

var playerVisiting
var playerHand
var currentDiskArray
var currentTowerLevel

#var rng = RandomNumberGenerator.new()

signal updateTower(nth, to)
signal updateHand(to)

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
	timeRef = OS.get_unix_time()

func _process(_delta):
	
	
	# Test Key: Enter(Generate/Eliminate a Disk), R(Clear wave), F(Reset towers)
	if Input.is_action_just_pressed("ui_accept"):
		if playerHand:
			playerHand = null
		else:
			playerHand = randi() % 3 + 1
		emit_signal("updateHand", playerHand)
	
	if Input.is_action_just_pressed("clear_wave"):
		timeRef = OS.get_unix_time()
		GameTimerText.text = "0"
		for i in $AlienPath.get_children():
			i.queue_free()
			
	if Input.is_action_just_pressed("reset_towers") or Input.is_action_just_pressed("reset_simulation"):
		for i in Towers.get_children():
			i.queue_free()
		three_towers()
	
	if Input.is_action_just_pressed("reset_simulation"):
		timeRef = OS.get_unix_time()
		GameTimerText.text = "0"
		pass
	
	if Input.is_action_just_pressed("ui_select"):
		if playerVisiting != -1:
			print("Interacting with Tower#", playerVisiting)
			if playerHand:
				if !currentDiskArray or currentDiskArray.size() < currentTowerLevel and currentDiskArray[-1] > playerHand:
					currentDiskArray.append(playerHand)
					playerHand = null
			else:
				if currentDiskArray:
					playerHand = currentDiskArray.pop_back()
			
			emit_signal("updateTower", playerVisiting, currentDiskArray)
			emit_signal("updateHand", playerHand)
		else:
			print("please visit anywhere")

func three_towers():
	for i in [0, 1, 2]:
		var new_Tower = Tower.instance()
		new_Tower.position = Vector2(256 + 128 * i, 576)
		if i == 0:
			new_Tower.diskArray = [3, 2, 1]
		Towers.add_child(new_Tower, true)
		new_Tower.connect("towerSignal", self, "_on_Tower_towerSignal")

func _on_Tower_towerSignal(towerIndex, playerHere, diskArray, towerLevel):
	playerVisiting = towerIndex if playerHere else -1
	currentDiskArray = diskArray
	currentTowerLevel = towerLevel


func _on_Player_playerSignal(onHand):
	playerHand = onHand


func _on_GameTimer_timeout():
	timeNow = OS.get_unix_time()
	GameTimerText.text = str(timeNow - timeRef)
