extends Node2D

func _ready():
	yield(VisualServer, "frame_post_draw")
	
	var img = $ViewportContainer/Viewport.get_texture().get_data()
	img.convert(Image.FORMAT_RGBA8)
	img.save_png("test.png")
