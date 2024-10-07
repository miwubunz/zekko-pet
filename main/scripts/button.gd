extends Button

var time_tween = 0.5
var time_tween2 = 1
var pos = position.x
var new_pos = position.x - 5
var end_pos = position.x - 20
var able = true

@onready var food = $"../../../items/food"
@onready var drinks = $"../../../items/drinks"
@onready var sett = $"../../../items/settings"

@onready var og_color = self.get_theme_color("font_color")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", Callable(self, "enter"))
	connect("mouse_exited", Callable(self, "leave"))
	connect("pressed", Callable(self, "clickie"))
	food.modulate.a = 0
	drinks.modulate.a = 0
	sett.modulate.a = 0
	
	food.position.y = 80
	drinks.position.y = 80
	sett.position.y = 80
	
	food.mouse_filter = MOUSE_FILTER_IGNORE
	drinks.mouse_filter = MOUSE_FILTER_IGNORE
	sett.mouse_filter = MOUSE_FILTER_IGNORE
	print(og_color)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter():
	if able:
		create_tween().tween_property(self,"position:x", new_pos,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func leave():
	if able:
		create_tween().tween_property(self,"position:x", pos,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func clickie():
	if able:
		deanimate_all()
		able = false
		create_tween().tween_property(self,"position:x", pos,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(self,"theme_override_font_sizes/font_size",50,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		self.modulate = Color(255,255,255)
		show_items(name)

func deanimate_all():
	if self.name != "food":
		unshow_items("food")
		get_parent().find_child("food").able = true
		create_tween().tween_property(get_parent().find_child("food"),"position:x", pos,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(get_parent().find_child("food"),"theme_override_font_sizes/font_size",40,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		get_parent().find_child("food").modulate = og_color
	if self.name != "drinks":
		unshow_items("drinks")
		get_parent().find_child("drinks").able = true
		create_tween().tween_property(get_parent().find_child("drinks"),"position:x", pos,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(get_parent().find_child("drinks"),"theme_override_font_sizes/font_size",40,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		get_parent().find_child("drinks").modulate = og_color
	if self.name != "settings":
		unshow_items("settings")
		get_parent().find_child("settings").able = true
		create_tween().tween_property(get_parent().find_child("settings"),"position:x", pos,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(get_parent().find_child("settings"),"theme_override_font_sizes/font_size",40,time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		get_parent().find_child("settings").modulate = og_color

func show_items(what):
	match what:
		"food":
			ignoreorpass(food, MOUSE_FILTER_PASS)
			create_tween().tween_property(food, "position", Vector2(66,58), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(food, "modulate:a", 1,0.3).connect("finished", Callable(self, "reenable"))
		"drinks":
			ignoreorpass(drinks, MOUSE_FILTER_PASS)
			create_tween().tween_property(drinks, "position", Vector2(66,58), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(drinks, "modulate:a", 1, 0.3).connect("finished", Callable(self, "reenable"))
		"settings":
			ignoreorpass(sett, MOUSE_FILTER_PASS)
			create_tween().tween_property(sett, "position", Vector2(66,58), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(sett, "modulate:a", 1, 0.3).connect("finished", Callable(self, "reenable"))

func unshow_items(what):
	match what:
		"food":
			ignoreorpass(food, MOUSE_FILTER_IGNORE)
			food.mouse_filter = MOUSE_FILTER_IGNORE
			create_tween().tween_property(food, "position", Vector2(66,80), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(food, "modulate:a", 0, 0.3)
		"drinks":
			ignoreorpass(drinks, MOUSE_FILTER_IGNORE)
			drinks.mouse_filter = MOUSE_FILTER_IGNORE
			create_tween().tween_property(drinks, "position", Vector2(66,80), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(drinks, "modulate:a", 0, 0.3)
		"settings":
			ignoreorpass(sett, MOUSE_FILTER_IGNORE)
			sett.mouse_filter = MOUSE_FILTER_IGNORE
			create_tween().tween_property(sett, "position", Vector2(66,80), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(sett, "modulate:a", 0, 0.3)

func ignoreorpass(e, a) -> void:
	for i in e.get_children():
		if i is Control or i is TextureButton or i is Label or i is MenuButton:
			i.mouse_filter = a
		if i.get_child_count() > 0:
			ignoreorpass(i, a)
