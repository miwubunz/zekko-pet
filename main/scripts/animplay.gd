extends Control

var save_path = "user://data.inf"

# startup

func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_size(DisplayServer.window_get_size() / Vector2i(2,2)) 
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	var screen = DisplayServer.screen_get_size()
	var window = DisplayServer.window_get_size()

	DisplayServer.window_set_size(window)
	print(window)
	await get_tree().process_frame
	DisplayServer.window_set_position(Vector2(screen.x / 2 - window.x / 2, screen.y / 2 - window.y / 2))
	$AnimationPlayer.play("outro")
	await get_tree().create_timer(3).timeout
	k()
	pass

func _process(delta):
	pass

func k():
	if FileAccess.file_exists(save_path):
		get_tree().change_scene_to_file("res://main/scenes/main.tscn")
	else:
		get_tree().change_scene_to_file("res://main/scenes/control.tscn")
