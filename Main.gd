extends Node2D

var playerVisiting
var playerHand
var currentTowerArray
var currentTowerCapacity

signal updateTower(nth, to)
signal updateHand(to)

func _ready():
	playerVisiting = -1
	playerHand = null
	currentTowerArray = []
	currentTowerCapacity = -1

func _process(_delta):
	
	# Test Key: Enter
	if Input.is_action_just_pressed("ui_accept"):
		if playerHand:
			playerHand = null
		else:
			playerHand = randi() % 4
		emit_signal("updateHand", playerHand)
	
	if Input.is_action_just_pressed("ui_select"):
		if playerVisiting != -1:
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



func _on_testBox1_towerSignal(towerIndex, playerHere, towerArray, towerCapacity):
	playerVisiting = towerIndex if playerHere else -1
	currentTowerArray = towerArray 
	currentTowerCapacity = towerCapacity


func _on_Player_playerSignal(onHand):
	playerHand = onHand
