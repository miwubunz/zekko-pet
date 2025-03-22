extends Control

@onready var music = $bg
@onready var menu = $menubutton
@onready var menu_lang = $items/settings/Control/menubutton
@onready var slider = $slider
@onready var filedlg = $filedlg

@onready var button = $Control/VBoxContainer/food
@onready var button2 = $Control/VBoxContainer/settings

@onready var items = $items
@onready var age = $Control/TextureRect/age

enum langs {
	EN,
	ES
}

var on_shop = false

var money : int = 0

var user_path = "user://date.inf"
var save_path_data = "user://data.inf"


func _ready() -> void:
	on_shop = false
	menu.get_popup().id_pressed.connect(Callable(self,"music_setter"))
	menu_lang.get_popup().id_pressed.connect(Callable(self,"lang"))

	language_setter()
	await get_tree().process_frame
	music_setter(int(DataManager.data.settings.music))
	music.volume_db = linear_to_db(slider.value / 100)
	await get_tree().process_frame
	music.play()

	match controller.data:
		"food":
			button.clickie()
		"settings":
			button2.clickie()


func _process(_delta: float) -> void:
	$money/money.text = abbr(money)
	music.volume_db = linear_to_db(slider.value / 100)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().change_scene_to_file("res://main/scenes/main.tscn")


func music_setter(id):
	for i in range(menu.get_popup().get_item_count()):
		menu.get_popup().set_item_checked(i, false)

	menu.get_popup().set_item_checked(id, true)

	match id:
		0:
			music.stop()
			music.stream = null
			DataManager.data.settings.music = int(id)
		1:
			music.stop()
			music.stream = load("res://main/music/shopambient.wav")
			music.play()
			DataManager.data.settings.music = int(id)
		_:
			if id in range(2,5):
				music.stop()
				music.stream = load("res://main/music/shop%s.wav" % str(id))
				music.play()
				DataManager.data.settings.music = int(id)
	DataManager.store_data()


func language_setter():
	var id : int = int(DataManager.data.settings.language)

	match id:
		0:
			TranslationServer.set_locale("en")
			DataManager.data.settings.language = int(langs.EN)
		1:
			TranslationServer.set_locale("es")
			DataManager.data.settings.language = int(langs.ES)
	money = int(DataManager.data.settings.money)
	slider.value = DataManager.data.settings.volume
	DataManager.store_data()
	
	for i in range(menu_lang.get_popup().get_item_count()):
		menu_lang.get_popup().set_item_checked(i, false)
	
	menu_lang.get_popup().set_item_checked(DataManager.data.settings.language, true)
	

func lang(id):
	for i in range(menu_lang.get_popup().get_item_count()):
		menu_lang.get_popup().set_item_checked(i, false)
	
	menu_lang.get_popup().set_item_checked(id, true)
	match id:
		0:
			TranslationServer.set_locale("en")
			DataManager.data.settings.language = int(langs.EN)
		1:
			TranslationServer.set_locale("es")
			DataManager.data.settings.language = int(langs.ES)
	DataManager.store_data()

	age.age()

	for i in items.get_children():
		for j in i.get_children():
			if j.get_child_count() > 0:
				var child = j.get_child(0)
				if child is TextureButton:
					child.set_name_price()


func _on_slider_changed(value: float) -> void:
	DataManager.data.settings.volume = slider.value
	DataManager.store_data()

func update_money():
	DataManager.data.settings.money = int(money)
	DataManager.store_data()

func update_items(obj, type, heal):
	var item = {
		"item": obj.to_lower(),
		"type": type,
		"id": int(DataManager.data.items.size()),
		"heal": heal
	}
	
	DataManager.data.items.append(item)
	DataManager.store_data()

func abbr(number : int) -> String:
	if number >= 1000000:
		var r = float(number) / 1000000
		return (str(int(r)) if r == int(r) else str(r)) + "m"
	elif number >= 1000:
		var r = float(number) / 1000
		return (str(int(r)) if r == int(r) else str(r)) + "k"
	else:
		return str(number)
