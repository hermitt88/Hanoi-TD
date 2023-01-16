extends Area2D

var velocity = Vector2()
var speed = 200

var screen_size

var onHand = null

signal playerSignal(onHand)

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
	if velocity.length():
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.play("idle")
	
	position += velocity * speed * delta
	#velocity = move_and_slide(velocity * speed)
	position.x = clamp(position.x, 0, screen_size.x)
	
	if onHand:
		$Label.text = String(onHand)
	else:
		$Label.text = "Empty"

func _on_Player_area_entered(area):
	#print(area.get_index())
	if onHand:
		emit_signal("playerSignal", onHand)


func _on_Player_area_exited(area):
	pass


func _on_Main_updateHand(to):
	onHand = to
