extends TextureButton

var timetween = 0.7

@onready var popup = $"../../../../prompt"
@onready var buysfx = $"../../../../sfx/buy"

@export var tag : String
@export var type : String
@export var price : int = 30

@onready var money = $"../../../.."

@onready var txtmoney = $"../../../../money/money"

@onready var anim = $"../../../../anim"

var shaking = false

@export var heal : int

var shake = 70

func _ready() -> void:
	connect("mouse_entered", Callable(self, "hover"))
	connect("mouse_exited", Callable(self, "unhover"))
	connect("pressed", Callable(self,"press"))
	pivot_offset = size / Vector2(2,2)
	pass

func press():
	popup.call_prompt(get_node("."))

func buy():
	if money.money >= price:
		buysfx.play()
		money.money -= price
		money.update_money()
		money.update_items(tag,type, heal)
	else:
		red()

func hover():
	create_tween().tween_property(self, "scale", Vector2(1.1,1.1), timetween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func unhover():
	create_tween().tween_property(self, "scale", Vector2(1,1), timetween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func red():
	anim.stop()
	anim.play("notif")
