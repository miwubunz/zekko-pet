extends Control

var data : Dictionary = {}
const data_path = "user://data.inf"
const config_file = "res://config.json"

func _ready() -> void:
	data = await parse_data()

func parse_data() -> Dictionary:
	if !FileAccess.file_exists(config_file):
		get_tree().change_scene_to_file("res://main/scenes/error.tscn")
		await get_tree().process_frame
		OS.alert("config file was not found. before running the game, run setup.py\nif you are not a dev and you did not clone the github repo on your own, open an issue on github:\nhttps://github.com/miwubunz/zekko-pet/issues/new", "Error on load!")
		get_tree().quit()
		return {}

	var file_ : FileAccess = FileAccess.open(config_file, FileAccess.READ)
	var file_content = file_.get_as_text()
	var content : Dictionary = JSON.parse_string(file_content)
	var p : String = content[Marshalls.utf8_to_base64("PASSKEY")]
	var PASS = Marshalls.base64_to_utf8(p.hex_decode().get_string_from_utf8())

	if FileAccess.file_exists(data_path):
		var file : FileAccess = FileAccess.open_encrypted_with_pass(data_path, FileAccess.READ, PASS)
		var data_str : String = file.get_as_text()

		if data_str.is_empty():
			return {}

		file.close()
		return JSON.parse_string(data_str)
	else:
		return {}

func store_data():
	var file_ : FileAccess = FileAccess.open(config_file, FileAccess.READ)
	var file_content = file_.get_as_text()
	var content : Dictionary = JSON.parse_string(file_content)
	var p : String = content[Marshalls.utf8_to_base64("PASSKEY")]
	var PASS = Marshalls.base64_to_utf8(p.hex_decode().get_string_from_utf8())

	var file : FileAccess = FileAccess.open_encrypted_with_pass(data_path, FileAccess.WRITE, PASS)
	file.store_line(JSON.stringify(data, "\t"))
	file.close()

func create_file():
	var file_ : FileAccess = FileAccess.open(config_file, FileAccess.READ)
	var file_content = file_.get_as_text()
	var content : Dictionary = JSON.parse_string(file_content)
	var p : String = content[Marshalls.utf8_to_base64("PASSKEY")]
	var PASS = Marshalls.base64_to_utf8(p.hex_decode().get_string_from_utf8())

	var file : FileAccess = FileAccess.open_encrypted_with_pass(data_path, FileAccess.WRITE, PASS)
	var json : Dictionary = {
		"user": {
			"creation_date": Time.get_date_string_from_system()
		},
		"items": [],
		"mood": {
			"happiness": 100,
			"eatingness": 100,
			"sleepiness": 0
		},
		"settings": {
			"language": 0,
			"money": int(250),
			"music": 0,
			"volume": 17,
			"last_position": {
				"x": null,
				"y": null
			}
		}
	}

	file.store_line(JSON.stringify(json, "\t"))
	file.close()

	data = json

	return json
