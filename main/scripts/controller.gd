extends Control

var data


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func send_data(scene, data_send):
	get_tree().change_scene_to_file("res://main/scenes/shop.tscn")
	data = data_send
	await get_tree().create_timer(1).timeout
	data = null
