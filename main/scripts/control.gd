extends Control

var timer = 0

const path = "user://data.inf"
@onready var controluwu = $Control
@onready var anims = $Control/AnimationPlayer

@onready var talksfx = $sounds/talk
@onready var open = $sounds/appear
@onready var close = $sounds/disappear

@onready var arrow = $arrow
@onready var x = $x

@onready var zekko = $zekko

var dialogue_indicator = false # variable that will activate the dialogue when true

var index = 0
@onready var txt = $txt
var finished = false

var sentences = ["[center]Hi, I'm [b][i][wave]zekko.[/wave][/i][/b]", "[center][shake][b][i]Please,[/i][/b][/shake] take care of me."]

var sentence = ""

var sentencearray = 0

var reset = 0.02 # timer value

var able = false

const TWEEN = 0.7

var tweening = false # variable so that a tween doesnt keep tweening every frame

var toanim = 0 # whether the arrow or x sprite should be animated

func _ready() -> void:
	# make transparent window -- tested on windows 10 and linux mint 22
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_viewport().transparent_bg = true
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_size(Vector2i(1052,1052) / Vector2i(2,2)) 
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	var screen = DisplayServer.screen_get_size()
	var window = DisplayServer.window_get_size()
	DisplayServer.window_set_position(Vector2(screen.x / 2 - window.x / 2, screen.y / 2 - window.y / 2))
	
	txt.text = sentences[sentencearray]
	arrow.modulate.a = 0
	x.modulate.a = 0
	await get_tree().create_timer(0.5).timeout
	create_tween().tween_property(zekko, "modulate:a", 1, TWEEN)
	await get_tree().create_timer(1.5).timeout
	txt.visible = true
	dialogue_indicator = true

	if !FileAccess.file_exists(path):
		DataManager.create_file()

func _process(delta: float) -> void:
	if timer != null and dialogue_indicator:
		timer -= 1 * delta
		if timer < 0 and !finished:
			if index <= txt.get_parsed_text().length():
				talksound()
				txt.visible_characters += 1
				index += 1
				timer = reset
				if txt.get_parsed_text()[index - 2] == ",":
					timer = 0.5 # add a little delay when theres a comma
			else:
				timer = 2 # delay before setting the next sentence
				finished = true
		if timer < 0 and finished and !tweening:
			open.play()
			open_indicator()
			able = true
			tweening = true
			await get_tree().create_timer(1.5).timeout
			if sentencearray != sentences.size() - 1 and finished and dialogue_indicator:
				closer()
			elif sentencearray >= sentences.size() - 1 and finished and dialogue_indicator:
				close_more()
	

	elif Input.is_action_just_pressed("enter") and !finished and dialogue_indicator:
		open.play()
		timer = null
		finished = true
		txt.visible_characters = txt.text.length()
		index = txt.text.length()
		able = true
		open_indicator()

func talksound():
	var random_ = randf_range(0.9,1.1)
	talksfx.pitch_scale = random_
	talksfx.play()

func bye():
	create_tween().tween_property(zekko, "modulate:a", 0, TWEEN)
	await get_tree().create_timer(1).timeout
	anims.play("k")
	controluwu.visible = true

func closer():
	close.play()
	tweening = false
	able = false
	close_indicator()
	timer = reset
	sentencearray += 1
	txt.visible_characters = 0
	index = 0
	finished = false
	toanim += 1
	sentence = sentences[sentencearray]
	txt.text = sentence

func close_more():
	close.play()
	create_tween().tween_property(txt, "modulate:a", 0, TWEEN)
	able = false
	close_indicator()
	bye()

#region animations
func open_indicator():
	match toanim:
		0:
			arrow.bounce()
			arrow.modulate.a = 1
			arrow.scale.y = 1.5
			create_tween().tween_property(arrow, "scale:y", 1, TWEEN).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		1:
			x.bounce()
			x.modulate.a = 1
			x.scale.y = 1.5
			create_tween().tween_property(x, "scale:y", 1, TWEEN).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func close_indicator():
	match toanim:
		0:
			create_tween().tween_property(arrow, "scale:y", 1.5, TWEEN).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			create_tween().tween_property(arrow, "modulate:a", 0, 0.2)
		1:
			create_tween().tween_property(x, "scale:y", 1.5, TWEEN).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			create_tween().tween_property(x, "modulate:a", 0, 0.2)
#endregion


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/main.tscn")
	pass
