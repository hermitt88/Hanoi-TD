extends MarginContainer

var num_grids = 1
var current_grid = 1
var grid_width = 710

onready var gridbox = $VBoxContainer/VBoxContainer/ClipControl/LevelGrid
onready var tween = $Tween

func _ready():
	# Number all the level boxes and unlock them
	# Replace with your game's level/unlocks/etc.
	# You can also connect the "level_selected" signals
	num_grids = gridbox.get_child_count()
	for grid in gridbox.get_children():
		for box in grid.get_children():
			var num = box.get_position_in_parent() + 1 + 18 * grid.get_position_in_parent()
			box.level_num = num
			box.locked = false

func _on_BackButton_pressed():
	if current_grid > 1:
		current_grid -= 1
		gridbox.rect_position.x += grid_width

func _on_NextButton_pressed():
	if current_grid < num_grids:
		current_grid += 1
		gridbox.rect_position.x -= grid_width
