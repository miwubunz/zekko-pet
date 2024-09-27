extends Control

# startup

func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_size(Vector2i(700,700))
	$AnimationPlayer.play("outro")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://main/scenes/control.tscn")
	pass

func _process(delta):
	pass
