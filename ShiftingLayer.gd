extends ParallaxLayer

func _process(delta):
	self.motion_offset.x += -80 * delta
	self.motion_offset.y += 120 * delta
