extends Node2D

var playerVisiting
var playerHand
var currentTowerArray
var currentTowerCapacity

var rng = RandomNumberGenerator.new()

signal updateTower(nth, to)
signal updateHand(to)

onready var Towers = $Towers
var Tower = preload("res://Tower.tscn")

func _ready():
	playerVisiting = -1
	playerHand = null
	currentTowerArray = []
	currentTowerCapacity = -1
	three_towers()

func _process(_delta):
	
	# Test Key: Enter(Generate/Eliminate a Disk), R(Clear wave)
	if Input.is_action_just_pressed("ui_accept"):
		if playerHand:
			playerHand = null
		else:
			playerHand = rng.randi_range(1, 3)
		emit_signal("updateHand", playerHand)
	
	if Input.is_action_just_pressed("clear_wave"):
		for i in $AlienPath.get_children():
			i.queue_free()
	
	if Input.is_action_just_pressed("ui_select"):
		if playerVisiting != -1:
			print("Interacting with Tower#", playerVisiting)
			if playerHand:
				if !currentTowerArray or currentTowerArray.size() < currentTowerCapacity and currentTowerArray[-1] > playerHand:
					currentTowerArray.append(playerHand)
					playerHand = null
			else:
				if currentTowerArray:
					playerHand = currentTowerArray.pop_back()
			
			emit_signal("updateTower", playerVisiting, currentTowerArray)
			emit_signal("updateHand", playerHand)
		else:
			print("please visit anywhere")

func three_towers():
	for i in [0, 1, 2]:
		var new_Tower = Tower.instance()
		new_Tower.position = Vector2(256 + 128 * i, 384)
		Towers.add_child(new_Tower, true)
		new_Tower.connect("towerSignal", self, "_on_Tower_towerSignal")

func _on_Tower_towerSignal(towerIndex, playerHere, towerArray, towerCapacity):
	playerVisiting = towerIndex if playerHere else -1
	currentTowerArray = towerArray 
	currentTowerCapacity = towerCapacity


func _on_Player_playerSignal(onHand):
	playerHand = onHand
