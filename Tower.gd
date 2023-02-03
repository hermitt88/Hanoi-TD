class_name Tower
extends Area2D

var playerHere = false
var towerIndex
var towerLevel
var cellSize = 64
var rodWidth = 16
var diskThickness = 28
signal towerSignal(towerIndex, playerHere, towerArray, towerLevel)
#signal towerLevelUp()
#signal maxTowerLevel()

#var rng = RandomNumberGenerator.new()

var Bullet = preload("res://Bullet.tscn")
var atkDuration
var atkPierce
var atkFreeze

const colorWhite = Color(255, 255, 255, 1)
const colorRed = Color(255, 0, 0, 1)
const colorGreen = Color(0, 255, 0, 1)
const colorBlue = Color(0, 0, 255, 1)
const colorArray = [colorWhite, colorRed, colorGreen, colorBlue]
# Red: Rapid, Green: Pierce, Blue: Freeze

var towerArray = Array()

func _ready():
	randomize()
	towerIndex = self.get_index()
	towerLevel = 3
	while towerArray.size() < towerLevel:
		generateFloor()
	atkDuration = 2
	atkPierce = 0
	atkFreeze = 0.5
	#fire()

func _process(_delta):
	update()

func _draw():
	for i in towerArray.size():
		draw_tower(i + 1, towerArray[i])

func generateFloor():
	var thisFloor = {}
	var typeNum
	thisFloor["power"] = 0
	thisFloor["disk"] = null
	if towerArray.size():
		#typeNum = rng.randi_range(1, 3) #number of atk types
		typeNum = randi() % 3 + 1
	else:
		typeNum = 0
	thisFloor["type"] =  typeNum
	towerArray.append(thisFloor)
	pass

func draw_tower(height, disk):
	var diskLevel = disk["power"]
	var poleColor = colorArray[disk["type"]]
	draw_rect(Rect2(Vector2(-rodWidth * 0.5, -height * cellSize), Vector2(rodWidth, cellSize)), poleColor)
	if diskLevel:
		var center = Vector2(rodWidth * 0.5, cellSize * (-height + 0.5))
		var circleCenter1 = center + Vector2.LEFT * diskThickness * diskLevel * 0.5
		var circleCenter2 = center + Vector2.RIGHT * diskThickness * diskLevel * 0.5
		var circleRadius = diskThickness * 0.5
		var rectStart = center + Vector2.LEFT * diskThickness * diskLevel * 0.5 + Vector2.UP * diskThickness * 0.5
		var rectSize = Vector2(diskThickness * diskLevel, diskThickness)
		draw_circle(circleCenter1, circleRadius, colorWhite)
		draw_circle(circleCenter2, circleRadius, colorWhite)
		draw_rect(Rect2(rectStart, rectSize), colorWhite)

func fire():
	if towerArray:
		var newBullet = Bullet.instance()
		newBullet.position.y = - 48
		#newBullet.position.y = 192 - 48 + randi() % 65 - 32
		var BulletDamage = 0
		for i in towerArray.size():
			BulletDamage += towerArray[i]["power"] * pow(i + 1, 2)
		newBullet.damage = BulletDamage
		add_child(newBullet)
	yield(get_tree().create_timer(atkDuration), "timeout")
	fire()

func _on_Main_updateTower(nth, to):
	if towerIndex == nth:
		towerArray = to

func _on_Tower_area_entered(area):
	if area.get_name() == "Player":
		print("Player entered")
		#$ColorRect.modulate = Color(0, 0, 255, 0.1)
		playerHere = true
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerLevel)

func _on_Tower_area_exited(area):
	if area.get_name() == "Player":
		print("Player exited")
		#$ColorRect.modulate = colorWhite
		playerHere = false
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerLevel)
