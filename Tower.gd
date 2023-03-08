class_name Tower
extends Area2D

var playerHere = false
var towerIndex
var towerLevel
var cellSize = 64
var rodWidth = 16
var diskThickness = 28
#signal towerLevelUp()
#signal maxTowerLevel()

onready var upgradeBar = $TextureProgress
onready var Player = get_node("/root/Main/Player")

#var rng = RandomNumberGenerator.new()

var Bullet = preload("res://Bullet.tscn")
var atkPierce
var atkDuration
var atkFreeze
var atkRange

const colorWhite = Color(255, 255, 255, 1)
const colorRed = Color(255, 0, 0, 1)
const colorRedGhost = Color(255, 0, 0, 0.2)
const colorGreen = Color(0, 255, 0, 1)
const colorBlue = Color(0, 0, 255, 1)
const colorBlueGhost = Color(0, 0, 255, 0.2)
const colorArray = [colorWhite, colorRed, colorGreen, colorBlue]
# Red: Pierce, Green: Rapid, Blue: Freeze

var towerArray = Array()
var diskArray = Array()

var blueGhost
var redGhost
var GhostDisk
var GhostColor

func _ready():
	randomize()
	towerIndex = self.get_index()
	towerLevel = 3
	while towerArray.size() < towerLevel:
		generateFloor()
	atkPierce = 0
	atkDuration = 2
	atkFreeze = 0
	atkRange = 640
	fire()
	upgradeBar.set("visible", false)
	
	GhostDisk = null
	GhostColor = null
	
	Player.connect("showGhost", self, "_on_showGhost")
	

func _process(_delta):
	update()

func _draw():
	for i in towerArray.size():
		draw_tower(i + 1, towerArray[i])
	for i in diskArray.size():
		draw_disk(i + 1, diskArray[i], colorWhite)
	if GhostColor:
		draw_disk(diskArray.size() + 1, GhostDisk, GhostColor)

func generateFloor():
	var thisFloor = {}
	var typeNum
	#thisFloor["power"] = pow(towerArray.size() + 1, 2)
	thisFloor["power"] = 2
	typeNum = randi() % 3 + 1
	thisFloor["type"] =  colorArray[typeNum]
	towerArray.append(thisFloor)
	pass

func draw_tower(height, pole):
	var poleColor = pole["type"]
	draw_rect(Rect2(Vector2(-rodWidth * 0.5, -height * cellSize), Vector2(rodWidth, cellSize)), poleColor)

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

func fire():
	if diskArray:
		var newBullet = Bullet.instance()
		newBullet.position.y = - 48 + randi() % 65 - 32
		var BulletDamage = 0
		var Pierce = 0
		var Freeze = 0
		var Duration = 2
		for i in diskArray.size():
			BulletDamage += diskArray[i] * towerArray[i]["power"]
			if towerArray[i]["type"] == colorRed:
				Pierce += 1
			if towerArray[i]["type"] == colorBlue:
				Freeze += 0.8
			if towerArray[i]["type"] == colorGreen:
				Duration *= 0.6
		newBullet.set("damage", BulletDamage)
		newBullet.set("atkPierce", Pierce)
		newBullet.set("atkFreeze", Freeze)
		newBullet.set("atkRange", atkRange)
		atkDuration = Duration
		add_child(newBullet)
	yield(get_tree().create_timer(atkDuration), "timeout")
	fire()

func _on_showGhost(tower, color, disk):
	if tower == self:
		GhostDisk = disk
		GhostColor = color
