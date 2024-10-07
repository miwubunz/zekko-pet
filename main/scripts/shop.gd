extends Control

@onready var music = $bg
@onready var menu = $menubutton
@onready var menu_lang = $items/settings/Control/menubutton
@onready var slider = $slider
@onready var filedlg = $filedlg

@onready var button = $Control/VBoxContainer/food
@onready var button2 = $Control/VBoxContainer/settings

var file_data

var money = 9

var user_path = "user://date.inf"
var save_path_data = "user://data.inf"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, false)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, false)
	var screen = DisplayServer.screen_get_size()
	var window = Vector2i(700,700)
	menu.get_popup().id_pressed.connect(Callable(self,"thingy_id"))
	menu_lang.get_popup().id_pressed.connect(Callable(self,"lang"))

	DisplayServer.window_set_size(window)
	loady()
	await get_tree().process_frame
	DisplayServer.window_set_position(Vector2(screen.x / 2 - window.x / 2, screen.y / 2 - window.y / 2))
	get_tree().auto_accept_quit = false
	thingy_id(int(file_data.settings.music))
	music.play()
	music.volume_db = linear_to_db(slider.value / 100)
	print(slider.value)
	match controller.data:
		"food":
			button.clickie()
		"settings":
			button2.clickie()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$money/money.text = str(money)
	music.volume_db = linear_to_db(slider.value / 100)
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().change_scene_to_file("res://main/scenes/main.tscn")

func thingy_id(id):
	if id < 3:
		for i in range(menu.get_popup().get_item_count()):
			menu.get_popup().set_item_checked(i, false)
	
		menu.get_popup().set_item_checked(id, true)
	
	print(id)
	match id:
		0:
			music.stop()
			music.stream = null
			file_data.settings.music = id
			var file = FileAccess.open(save_path_data, FileAccess.WRITE)
			file.store_string(JSON.stringify(file_data, "\t"))
			file.close()
		1:
			music.stop()
			music.stream = load("res://main/music/shopambient.wav")
			music.play()
			file_data.settings.music = id
			var file = FileAccess.open(save_path_data, FileAccess.WRITE)
			file.store_string(JSON.stringify(file_data, "\t"))
			file.close()
		2:
			print("putgin")
			music.stop()
			music.stream = load("res://main/music/shop2.wav")
			music.play()
			file_data.settings.music = id
			var file = FileAccess.open(save_path_data, FileAccess.WRITE)
			file.store_string(JSON.stringify(file_data, "\t"))
			file.close()
		#3:
			#filedlg.popup_centered()

func loady():
	var file = FileAccess.open(save_path_data, FileAccess.READ)
	if not FileAccess.file_exists(save_path_data):
		print("NODATA")
	var data = JSON.parse_string(file.get_as_text())
	file_data = data
	TranslationServer.set_locale(file_data.settings.language)
	print(file_data.settings.language)
	money = file_data.settings.money
	slider.value = file_data.settings.vol
	
	for i in range(menu_lang.get_popup().get_item_count()):
		menu_lang.get_popup().set_item_checked(i, false)
	
	menu_lang.get_popup().set_item_checked(0 if file_data.settings.language == "en" else 1, true)
	

func lang(id):
	for i in range(menu_lang.get_popup().get_item_count()):
		menu_lang.get_popup().set_item_checked(i, false)
	
	menu_lang.get_popup().set_item_checked(id, true)
	match id:
		0:
			TranslationServer.set_locale("en")
			file_data.settings.language = "en"
			var file = FileAccess.open(save_path_data, FileAccess.WRITE)
			file.store_string(JSON.stringify(file_data, "\t"))
			file.close()
		1:
			TranslationServer.set_locale("es")
			file_data.settings.language = "es"
			var file = FileAccess.open(save_path_data, FileAccess.WRITE)
			file.store_string(JSON.stringify(file_data, "\t"))
			file.close()


func _on_slider_changed(value: float) -> void:
	file_data.settings.vol = slider.value
	var file = FileAccess.open(save_path_data, FileAccess.WRITE)
	file.store_string(JSON.stringify(file_data, "\t"))
	file.close()
	pass # Replace with function body.

func update_money():
	file_data.settings.money = money
	var file = FileAccess.open(save_path_data, FileAccess.WRITE)
	file.store_string(JSON.stringify(file_data, "\t"))
	file.close()

func update_items(obj, type, heal):
	var item = {
		"item": obj.to_lower(),
		"type": type,
		"id": file_data.items.size(),
		"heal": heal
	}
	
	file_data.items.append(item)

	var file = FileAccess.open(save_path_data, FileAccess.WRITE)
	file.store_string(JSON.stringify(file_data, "\t"))
	file.close()
