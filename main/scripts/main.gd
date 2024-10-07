extends Control

var inventoring = false

@onready var timer = $timer

var click = false
var move = false
var offset = Vector2i(180,120)
var spd = 0.2
var pos
var pos_face
var moved = false

var wanna_talk = true

@onready var inv = $inv/Panel/ScrollContainer/HBoxContainer
@onready var inv2 = $inv
@onready var tooltiptxt = $inv/Label

@onready var timer2 = $sleeping

var index = 0

# items
var path = {
	"food": [
		"burger.png", "pizza.png", "fries.png", "cookie.png", "apple.png", "bread.png"
	],
	"drinks": [
		"water.png", "cola.png", "juice.png", "tea.png", "coffee.png"
	]
}

var loaded = {}

@onready var anims = $rin/anim
@onready var face = $rin/face
@onready var body = $rin/body

@onready var chat = $chat

@onready var popup = $popup

var checking = false

var popup_state = "closed"

var save_path_data = "user://data.inf"

var mouse_pos
@onready var timer_poke = $timer_poke

var look_offset
var to_look = true
var able_to_pat = true

var max_offset = 30
var moving = false

var file_data

var selecting = false

@onready var og_face = face.position

var state = "idle"
var states = ["idling", "pat", "sleeping"]

var able = true
var able2 = true

var able_to_move = true

@onready var mood = $rin

func _ready() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	

	idle()
	
	var win_size = Vector2i(350, 350)
	DisplayServer.window_set_size(win_size)
	var screen_size = DisplayServer.screen_get_size()
	await get_tree().process_frame
	var window_position = screen_size - win_size
	
	DisplayServer.window_set_position(window_position)
	for i in path.keys():
		loaded[i] = {}
		for e in path[i]:
			var final_path = "res://main/sprites/%s/%s" % [i, e]
			loaded[i][e] = load(final_path)
	loady()
	$rin.happiness = file_data.mood.happiness
	$rin.eatingness = file_data.mood.eatingness
	$rin.sleepiness = file_data.mood.sleepiness
	print(file_data.items.size())
	tooltiptxt.modulate.a = 0


func _process(delta: float) -> void:
	print(state)
	if Input.is_action_just_pressed("click") and body.get_rect().has_point(body.get_local_mouse_position()) and able:
		if !selecting:
			click = true
			if state != "pat" and !moving and able_to_move:
				timer.start()
			if state != "pat" and able_to_pat:
				timer_poke.start()
		else:
			selecting = false
	
	if Input.is_action_just_released("click") and able:
		if moving:
			move = false
			moving = false
			timer_poke.stop()
			anims.play("move_end")
			await get_tree().create_timer(0.3).timeout
			popup.set_item_disabled(2,false)
			able_to_pat = true
		click = false
		timer.stop()
	
	
	if move and able:
		pos = Vector2(DisplayServer.mouse_get_position()) - Vector2(offset)

	if pos != null and able:
		DisplayServer.window_set_position(Vector2i(lerp(Vector2(DisplayServer.window_get_position()), pos, spd)))
	
	
	var win_pos = DisplayServer.window_get_position()
	
	var mouse = DisplayServer.mouse_get_position()
	var dirc = (Vector2(mouse) - (og_face + Vector2(win_pos) + global_position)).normalized()
	
	look_offset = dirc * max_offset
	
	if to_look and !selecting and able:
		pos_face = og_face + look_offset
	else:
		pos_face = og_face
	
	if pos_face != null and able:
		face.position = lerp(face.position, pos_face, spd)
	
	if body.get_rect().has_point(body.get_local_mouse_position()) and able:
		to_look = false
	else:
		to_look = true
	
	if Input.is_action_just_pressed("click_left") and able2 and !moving:
		popup.popup()
		popup.position = get_global_mouse_position()
		selecting = true
	
	
	if mood.eatingness == 100 or file_data.items.size() <= 0:
		popup.set_item_disabled(1, true)
	elif mood.eatingness != 100:
		if state == states[2] or chat.talking or inventoring:
			popup.set_item_disabled(1, true)
		else:
			popup.set_item_disabled(1, false)
	
	if mood.sleepiness == 0:
		if state != states[2]:
			popup.set_item_disabled(2, true)
		else:
			popup.set_item_disabled(2, false)
	elif mood.sleepiness != 0:
		if chat.talking or inventoring or !able_to_pat or moving:
			popup.set_item_disabled(2, true)
		else:
			popup.set_item_disabled(2, false)

func idle():
	anims.play("breathe")
	state = states[0]


func _on_timeout() -> void:
	if !moved:
		popup.set_item_disabled(2,true)
		moving = true
		able_to_pat = false
		timer.stop()
		anims.play("move")
		move = true


func _on_poke_timeout() -> void:
	if !click:
		popup.set_item_disabled(2,true)
		mood.happiness += 10
		if mood.happiness > 100:
			mood.happiness = 100
		state = states[1]
		timer_poke.stop()
		timer.stop()
		face.play("blush")
		anims.play("blush")
		await get_tree().create_timer(1.5).timeout
		popup.set_item_disabled(2,false)
		state = states[0]
		anims.play("breathe")
	return


func _on_id_pressed(id: int) -> void:
	match id:
		0:
			chat.say_rndm()
			popup.set_item_disabled(2,true)
		1:
			popup.set_item_disabled(0,true)
			inventoring = true
			$inv.visible = true
			popup.set_item_disabled(1, true)
			inv2.visible = true
		2:
			controller.send_data("res://main/scenes/shop.tscn", "food")
		3:
			controller.send_data("res://main/scenes/shop.tscn", "settings")
		4:
			able = false
			to_look = false
			create_tween().tween_property(self, "modulate:a", 0, 0.5)
			await get_tree().create_timer(0.5).timeout
			get_tree().quit()
		5:
			if state != states[2]:
				timer2.start()
				for i in range(popup.get_item_count()):
					popup.set_item_disabled(i,true)
				popup.set_item_disabled(2,false)
				popup.set_item_text(2,tr("WAKE"))
				wanna_talk = false
				to_look = false
				able = false
				face.play("sleep")
				state = states[2]
				$rin.modulate = Color(0.5,0.5,0.5)
			else:
				timer2.stop()
				for i in range(popup.get_item_count()):
					popup.set_item_disabled(i,false)
				popup.set_item_text(2,tr("SLEEP"))
				wanna_talk = true
				able = true
				face.play("blush")
				face.stop()
				face.frame = 0
				state = states[0]
				$rin.modulate = Color(1,1,1)
	pass

func loady():
	var file = FileAccess.open(save_path_data, FileAccess.READ)
	if not FileAccess.file_exists(save_path_data):
		print("NODATA")
	var data = JSON.parse_string(file.get_as_text())
	file_data = data
	print(file_data.settings.language)
	match file_data.settings.language:
		"en":
			TranslationServer.set_locale("en")
		"es":
			TranslationServer.set_locale("es")
	
	if file_data.items.size() != 0:
		for i in file_data.items:
			print(i.item)
			print(i.type)
			add_item(loaded[i.type][i.item + ".png"], tr(i.item.capitalize()), i.id)

func add_item(item, namey, id):
	var l = TextureRect.new()
	l.texture = item
	l.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	l.set_script(load("res://main/scripts/hover_item.gd"))
	l.tag = namey
	l.id = id

	inv.add_child(l)

func _on_money_giver_timeout() -> void:
	var money = int(file_data.settings.money)
	print(money)
	file_data.settings.money = money + 2
	var file = FileAccess.open(save_path_data, FileAccess.WRITE)
	file.store_string(JSON.stringify(file_data, "\t"))
	file.close()
	pass # Replace with function body.

func update_mood(happiness, eatingness, sleepiness):
	file_data.mood.happiness = happiness
	file_data.mood.eatingness = eatingness
	file_data.mood.sleepiness = sleepiness
	var file = FileAccess.open(save_path_data, FileAccess.WRITE)
	file.store_string(JSON.stringify(file_data, "\t"))
	file.close()

func delete_item(id):
	inventoring = false
	face.play("eat")
	able_to_pat = false
	able_to_move = false
	var p = $inv/Label
	var o = $inv/bg
	create_tween().tween_property(p, "modulate:a", 0, 0.1)
	create_tween().tween_property(o, "modulate:a", 0, 0.1)

	inv2.visible = false
	popup.set_item_disabled(1, false)
	popup.set_item_disabled(0,false)
	if mood.eatingness != 100:
		mood.eatingness += file_data.items[id].heal
		if mood.eatingness > 100:
			mood.eatingness = 100

		file_data.items.remove_at(id)

		for i in range(file_data.items.size()):
			file_data.items[i].id = i

		var file = FileAccess.open(save_path_data, FileAccess.WRITE)
		file.store_string(JSON.stringify(file_data, "\t"))
		file.close()

		for i in inv.get_children():
			inv.remove_child(i)

		for i in file_data.items:
			print(i.item)
			print(i.type)
			add_item(loaded[i.type][i.item + ".png"], tr(i.item.capitalize()), i.id)
	await get_tree().create_timer(1).timeout
	able_to_pat = true
	able_to_move = true

func _on_button_pressed() -> void:
	popup.set_item_disabled(0,false)
	inventoring = false
	popup.set_item_disabled(1, false)
	inv2.visible = false
	pass # Replace with function body.
