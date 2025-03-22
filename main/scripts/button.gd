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

@onready var items_map = {"food": food, "drinks": drinks, "settings": sett}

@onready var og_color = self.get_theme_color("font_color")

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
	var items = ["food", "drinks", "settings"]
	for item in items:
		if self.name != item:
			unshow_items(item)
			var node = get_parent().find_child(item)
			node.able = true
			create_tween().tween_property(node, "position:x", pos, time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(node, "theme_override_font_sizes/font_size", 40, time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			node.modulate = og_color

func show_items(what):
	var node = items_map[what]
	ignoreorpass(node, MOUSE_FILTER_PASS)
	create_tween().tween_property(node, "position", Vector2(66, 58), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	create_tween().tween_property(node, "modulate:a", 1, 0.3).connect("finished", Callable(self, "reenable"))

func unshow_items(what):
	var node = items_map[what]
	ignoreorpass(node, MOUSE_FILTER_IGNORE)
	node.mouse_filter = MOUSE_FILTER_IGNORE
	create_tween().tween_property(node, "position", Vector2(66, 80), time_tween2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	create_tween().tween_property(node, "modulate:a", 0, 0.3)

func ignoreorpass(e, a) -> void:
	for i in e.get_children():
		if i is Control or i is TextureButton or i is Label or i is MenuButton:
			i.mouse_filter = a
		if i.get_child_count() > 0:
			ignoreorpass(i, a)
