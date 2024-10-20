extends Control

var data

func send_data(data_send,scene = null):
	if scene != null:
		get_tree().change_scene_to_file(scene)
	data = data_send
	await get_tree().create_timer(1).timeout
	data = null
