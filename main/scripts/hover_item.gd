extends TextureRect

@onready var tooltiptxt = $"../../../../Label"
@onready var bg = $"../../../../bg"

@export var tag : String
@export var id : int

@onready var control = $"../../../../.."

var offset = Vector2(150,250)

var uwu

var spd = 0.1
var time_tween = 0.1

var hovering = false

func _ready() -> void:
	connect("mouse_entered", Callable(self, "hover"))
	connect("mouse_exited", Callable(self, "unhover"))
	tooltiptxt.modulate.a = 0

func _process(_delta: float) -> void:
	var pos = get_global_mouse_position() - offset
	tooltiptxt.position = lerp(tooltiptxt.position, pos, spd)
	bg.position = lerp(tooltiptxt.position, pos, spd)
	bg.size = tooltiptxt.size
	bg.pivot_offset = bg.size / Vector2(2,2)
	bg.modulate.a = tooltiptxt.modulate.a
	
	if Input.is_action_just_pressed("click") and hovering:
		press()

func hover():
	create_tween().tween_property(tooltiptxt, "modulate:a", 1, time_tween)
	tooltiptxt.text = tag
	hovering = true

func unhover():
	create_tween().tween_property(tooltiptxt, "modulate:a", 0, time_tween)
	hovering = false

func press():
	control.delete_item(id)
