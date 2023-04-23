extends TouchScreenButton

onready var Player = get_node("../../Player")
var blueSqr = preload("res://assets/UI/mobileBtns/blueSquare.png")
var redSqr = preload("res://assets/UI/mobileBtns/redSquare.png")

func _ready():
	Player.connect("changeInteractBtnColor", self, "_on_changeInteractBtnColor")

func _on_changeInteractBtnColor(color):
	if color:
		normal = redSqr
	else:
		normal = blueSqr
