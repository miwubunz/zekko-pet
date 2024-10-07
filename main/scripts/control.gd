extends Control

var timer = 0
var save_path = "user://date.inf"
var save_path_data = "user://data.inf"

@onready var talksfx = $sounds/talk
@onready var open = $sounds/appear
@onready var close = $sounds/disappear

@onready var arrow = $arrow
@onready var x = $x

var g = false # variable that will activate the dialogue when true

var index = 0
@onready var txt = $txt
var finished = false

var sentences = ["[center]Hi, I'm [b][i][wave]zekko.[/wave][/i][/b]", "[center][shake][b][i]Please,[/i][/b][/shake] take care of me."]

var sentence = ""

var sentencearray = 0

var reset = 0.02 # timer value

var able = false

var timetween = 0.7

var l = false # variable so that a tween doesnt keep tweening every frame 

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
	await get_tree().create_timer(2).timeout
	txt.visible = true
	g = true
	save()
	save_data()

func _process(delta: float) -> void:
	print(sentencearray)
	if timer != null and g:
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
		if timer < 0 and finished and !l:
			open.play()
			openthing()
			able = true
			l = true
	
	if Input.is_action_just_pressed("enter") and able and sentencearray != sentences.size() - 1 and finished and g:
		close.play()
		l = false
		able = false
		closething()
		timer = reset
		sentencearray += 1
		txt.visible_characters = 0
		index = 0
		finished = false
		toanim += 1
		sentence = sentences[sentencearray]
		txt.text = sentence
	elif Input.is_action_just_pressed("enter") and !finished and g:
		open.play()
		timer = null
		finished = true
		txt.visible_characters = txt.text.length()
		index = txt.text.length()
		able = true
		openthing()
	elif Input.is_action_just_pressed("enter") and able and sentencearray >= sentences.size() - 1 and finished and g:
		close.play()
		create_tween().tween_property(txt, "modulate:a", 0, timetween)
		able = false
		closething()
		bye()

func talksound():
	var e = randf_range(0.9,1.1)
	talksfx.pitch_scale = e
	talksfx.play()

func save():
	if !FileAccess.file_exists(save_path):
		print("saved :3")
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_string(Time.get_date_string_from_system())
	else:
		print("file already exists :p")

func save_data():
	var data = {
		"items": [],
		"mood": {
			"happiness": 100,
			"eatingness": 100,
			"sleepiness": 0
		},
		"settings": {
			"language": "en",
			"money": 290,
			"music": 0,
			"vol": 17
		}
	}
	
	var file = FileAccess.open(save_path_data, FileAccess.WRITE)
	var json = JSON.stringify(data, "\t")
	
	file.store_line(json)
	
	file.close()
	
	print("saved :3")

func bye():
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://main/scenes/main.tscn")

#region animations
func openthing():
	match toanim:
		0:
			arrow.bounce()
			arrow.modulate.a = 1
			arrow.scale.y = 1.5
			create_tween().tween_property(arrow, "scale:y", 1, timetween).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		1:
			x.bounce()
			x.modulate.a = 1
			x.scale.y = 1.5
			create_tween().tween_property(x, "scale:y", 1, timetween).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func closething():
	match toanim:
		0:
			create_tween().tween_property(arrow, "scale:y", 1.5, timetween).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			create_tween().tween_property(arrow, "modulate:a", 0, 0.2)
		1:
			create_tween().tween_property(x, "scale:y", 1.5, timetween).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			create_tween().tween_property(x, "modulate:a", 0, 0.2)
#endregion
