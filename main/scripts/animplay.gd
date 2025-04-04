extends Control

var save_path = "user://data.inf"

# startup
func _ready():
	var spr = $splash
	const TWEEN = 0.5
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_size(Vector2i(1052,1052) / Vector2i(2,2)) 
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	await get_tree().process_frame
	var screen = DisplayServer.screen_get_size()
	var window = DisplayServer.window_get_size()
	DisplayServer.window_set_position(Vector2(screen.x / 2 - window.x / 2, screen.y / 2 - window.y / 2))
	create_tween().tween_property(spr, "modulate:a", 1, TWEEN)
	await get_tree().create_timer(TWEEN + 1.5).timeout
	create_tween().tween_property(spr, "modulate:a", 0, TWEEN)
	await get_tree().create_timer(TWEEN).timeout
	scene_sender()

func scene_sender():
	if FileAccess.file_exists(save_path):
		get_tree().change_scene_to_file("res://main/scenes/main.tscn")
	else:
		get_tree().change_scene_to_file("res://main/scenes/control.tscn")
