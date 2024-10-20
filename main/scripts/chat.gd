extends Control

var timer = 0
var data_path = "user://date.inf"
var year
var month
var week
var day

@onready var mood = $"../zekko"

@onready var talksfx = $"../sounds/talk"
@onready var open = $"../sounds/appear"
@onready var close = $"../sounds/disappear"

@onready var timer_chat = $"../random_chat"

@onready var bg = $bg

var g = false # variable that will activate the dialogue when true

var index = 0
@onready var txt = $txt
var finished = false

var sentence = ""

var sentencearray = 0

@onready var popup = $"../popup"
@onready var control = $".."

var reset = 0.02 # timer value

var able = false

var timetween = 0.7

var l = false # variable so that a tween doesnt keep tweening every frame

func _ready() -> void:
	TranslationServer.set_locale("en")
	
	
	$bg.scale = Vector2(0,0)
	txt.text = ""
	pass


func _process(delta: float) -> void:
	$bg.size = txt.size
	$bg.position = txt.position
	$bg.pivot_offset = txt.size / Vector2(2,2)
	
	if timer != null and g:
		timer -= 1 * delta
		if timer < 0 and !finished:
			if index <= txt.get_parsed_text().length() - 1:
				talksound()
				txt.visible_characters += 1
				index += 1
				timer = reset
				match txt.get_parsed_text()[index - 1]: # delay for symbols
					",":
						timer = 0.5
					".":
						timer = 0.5
					"!":
						timer = 0.5
					"?":
						timer = 0.5
			else:
				timer = 1
				finished = true
		if timer < 0 and finished and !l:
			unshow()
			able = true
			l = true
	
	#if Input.is_action_just_pressed("enter") and able and finished and g:
		#control.state = control.states.IDLING
		#popup.set_item_disabled(2,false)
		#popup.set_item_disabled(0,false)
		#close.play()
		#l = false
		#able = false
		#timer = null
		#txt.visible_characters = 0
		#index = 0
		#sentence = ""
		#txt.text = sentence
		#close_anim()
		#g = false
	#elif Input.is_action_just_pressed("enter") and !finished and g:
		#timer = null
		#finished = true
		#txt.visible_characters = txt.text.length()
		#index = txt.text.length()
		#able = true

func talksound():
	var e = randf_range(0.9,1.1)
	talksfx.pitch_scale = e
	talksfx.play()

func say_rndm():
	control.state = control.states.TALKING
	popup.set_item_disabled(0, true)
	open.play()
	txt.visible_characters = 0
	index = 0
	timer = 0.02
	finished = false
	timer = reset
	able = true
	age()

	if month < 5:
		print("young")
		sntc("BEF_", "ALL_", "HAPPY_")
	elif month >= 5 and year < 1:
		print("old")
		sntc("AF_", "ALL_", "HAPPY_")
	elif year >= 1:
		print("older")
		sntc("YEAR_", "ALL_", "HAPPY_")

	open_anim()
	await get_tree().create_timer(0.3).timeout
	g = true

func sntc(bef, all, happy):
	var l = randi_range(1, 3) if mood.happiness > 30 else randi_range(1, 2)
	
	match l:
		1:
			var k = randi_range(1, 11)
			sentence = tr(bef + str(k))
		2:
			var k = randi_range(1, 7)
			sentence = tr(all + str(k))
		3:
			var k = randi_range(1, 6)
			sentence = tr(happy + str(k))
	
	txt.text = sentence
	print(sentence)

func mood_controller():
	if !g and control.state != control.states[2]:
		popup.set_item_disabled(2,true)

		var moods = []

		if mood.eatingness < 30:
			moods.append("HUNGRY")
		if mood.happiness < 30:
			moods.append("SAD")
		if mood.sleepiness > 70:
			moods.append("EEPY")
		
		if moods.size() > 0:
			print(moods.size())
			var moody = moods[randi_range(0, moods.size() - 1)]
			
			if moody == "HUNGRY":
				print("hungi")
				var k = randi_range(1, 16)
				sentence = tr("HUNGRY_" + str(k))
			elif moody == "SAD":
				print("sadi")
				var k = randi_range(1, 7)
				sentence = tr("SAD_" + str(k))
			elif moody == "EEPY":
				print("epi")
				var k = randi_range(1, 7)
				sentence = tr("EEPY_" + str(k))
		else:
			print("ignore")
			return
		txt.text = sentence
		
		control.state = control.states.TALKING
		popup.set_item_disabled(0, true)
		open.play()
		txt.visible_characters = 0
		index = 0
		timer = 0.02
		finished = false
		timer = reset
		able = true
		open_anim()
		await get_tree().create_timer(0.3).timeout
		g = true

func age():
	if FileAccess.file_exists(data_path):
		print("file found :D")
		var file = FileAccess.open(data_path, FileAccess.READ)
		var date = file.get_file_as_string(data_path)
		var result = date.split("-")
		var result2 = Time.get_date_string_from_system().split("-")
		
		year = int(result2[0]) - int(result[0])
		month = year * 12 + int(result2[1]) - int(result[1])
		day = year * 365 + month * 30 + int(result2[2]) - int(result[2])
		week = day / 7
		
		year = abs(year)
		month = abs(month)
		day = abs(day)
		week = abs(week)
		
		print("years " + str(year))
		print("months " + str(month))
		print("weeks " + str(week))
		print("days " + str(day))
		

func unshow():
	await get_tree().create_timer(2).timeout
	if able and finished and g:
		control.state = control.states.IDLING
		popup.set_item_disabled(2,false)
		popup.set_item_disabled(0,false)
		close.play()
		l = false
		able = false
		timer = null
		txt.visible_characters = 0
		index = 0
		sentence = ""
		txt.text = sentence
		close_anim()
		g = false

#region animations
func open_anim():
	create_tween().tween_property(bg, "scale", Vector2(0,0), 0)
	create_tween().tween_property(bg, "scale", Vector2(1.1,1.1), timetween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func close_anim():
	create_tween().tween_property(bg, "scale", Vector2(1.1,1.1), 0)
	create_tween().tween_property(bg, "scale", Vector2(0,0), timetween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
#endregion
