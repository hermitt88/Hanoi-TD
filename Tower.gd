class_name Tower
extends Area2D

var playerHere = false
var towerIndex
var towerCapacity
var cellSize = 64
var rodWidth = 16
var diskThickness = 28
signal towerSignal(towerIndex, playerHere, towerArray, towerCapacity)

var rng = RandomNumberGenerator.new()

var Bullet = preload("res://Bullet.tscn")

const colorWhite = Color(255, 255, 255, 1)

var towerArray = Array()

func _ready():
	randomize()
	towerIndex = self.get_index()
	towerCapacity = 3
	fire()

func _process(_delta):
	update()

func _draw():
	for i in towerArray.size():
		draw_disk(i, towerArray[i])

func draw_disk(height, diskLevel):
	var center = Vector2(rodWidth * 0.5, cellSize * (towerCapacity - height - 0.5))
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
		newBullet.position.y = 192 - 48 + rng.randi_range(-31, 31)
		var BulletDamage = 0
		for i in towerArray.size():
			BulletDamage += towerArray[i] * pow(i + 1, 2)
		newBullet.damage = BulletDamage
		add_child(newBullet)
	yield(get_tree().create_timer(2), "timeout")
	fire()

func _on_Main_updateTower(nth, to):
	if towerIndex == nth:
		towerArray = to

func _on_Tower_area_entered(area):
	if area.get_name() == "Player":
		$ColorRect.modulate = Color(0, 0, 255, 0.1)
		playerHere = true
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerCapacity)

func _on_Tower_area_exited(area):
	if area.get_name() == "Player":
		$ColorRect.modulate = colorWhite
		playerHere = false
		emit_signal("towerSignal", towerIndex, playerHere, towerArray, towerCapacity)
