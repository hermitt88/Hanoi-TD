class_name Tower
extends Area2D

var playerHere = false
var towerIndex
var towerCapacity
signal towerSignal(towerIndex, playerHere, towerArray, towerCapacity)

var towerArray = Array()

func _ready():
	towerIndex = self.get_index()
	towerCapacity = 3

func _process(delta):
	if towerArray:
		$Label.text = String(towerArray)
	else:
		$Label.text = "Empty"

func _on_testBox_area_entered(area):
	if area.get_name() == "Player":
		$ColorRect.modulate = Color(0, 0, 255, 0.1)
		playerHere = true
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerCapacity)

func _on_testBox_area_exited(area):
	if area.get_name() == "Player":
		$ColorRect.modulate = Color(255, 255, 255, 1)
		playerHere = false
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerCapacity)


func _on_Main_updateTower(nth, to):
	if towerIndex == nth:
		towerArray = to
