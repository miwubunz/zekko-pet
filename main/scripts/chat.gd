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

var dialogue_indicator = false # variable that will activate the dialogue when true

var index = 0
@onready var txt = $txt
var finished = false

var sentence = ""

var sentencearray = 0

@onready var popup = $"../canvaslayer/popup"
@onready var control = $".."

const reset = 0.02 # timer value

var able = false

var timetween = 0.7

var delayed_symbols = [",", ".", "!", "?"]

var tweening = false # variable so that a tween doesnt keep tweening every frame


func _ready() -> void:
	TranslationServer.set_locale("en")
	
	$bg.scale = Vector2(0,0)
	txt.text = ""


func _process(delta: float) -> void:
	$bg.size = txt.size
	$bg.position = txt.position
	$bg.pivot_offset = txt.size / Vector2(2,2)
	
	if timer != null and dialogue_indicator:
		timer -= 1 * delta
		if timer < 0 and !finished:
			if index <= txt.get_parsed_text().length() - 1:
				talksound()
				txt.visible_characters += 1
				index += 1
				timer = reset
				if index < txt.get_parsed_text().length():
					if txt.get_parsed_text()[index - 1] in delayed_symbols and txt.get_parsed_text()[index] not in delayed_symbols:
						timer = 0.5 # delay for punctuation marks
					elif txt.get_parsed_text()[index - 1] == "." and txt.get_parsed_text()[index] == ".":
						timer = 0.2
			else:
				timer = 1
				finished = true
		if timer < 0 and finished and !tweening:
			unshow()
			able = true
			tweening = true


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
		sntc("BEF_", "ALL_", "HAPPY_")
	elif month >= 5 and year < 1:
		sntc("AF_", "ALL_", "HAPPY_")
	elif year >= 1:
		sntc("YEAR_", "ALL_", "HAPPY_")

	open_anim()
	await get_tree().create_timer(0.3).timeout
	dialogue_indicator = true


func sntc(bef, all, happy):
	var tweening = randi_range(1, 3) if mood.happiness > 30 else randi_range(1, 2)
	
	match tweening:
		1:
			var random_ = randi_range(1, 11)
			sentence = tr(bef + str(random_))
		2:
			var random_ = randi_range(1, 7)
			sentence = tr(all + str(random_))
		3:
			var random_ = randi_range(1, 6)
			sentence = tr(happy + str(random_))
	
	txt.text = sentence


func mood_controller():
	if !dialogue_indicator and control.state != control.states.SLEEPING:
		popup.set_item_disabled(2,true)

		var moods = []

		if mood.eatingness < 30:
			moods.append("HUNGRY")
		if mood.happiness < 30:
			moods.append("SAD")
		if mood.sleepiness > 70:
			moods.append("EEPY")
		
		if moods.size() > 0:
			var moody = moods[randi_range(0, moods.size() - 1)]
			
			if moody == "HUNGRY":
				var random_ = randi_range(1, 16)
				sentence = tr("HUNGRY_" + str(random_))
			elif moody == "SAD":
				var random_ = randi_range(1, 7)
				sentence = tr("SAD_" + str(random_))
			elif moody == "EEPY":
				var random_ = randi_range(1, 7)
				sentence = tr("EEPY_" + str(random_))
		else:
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
		dialogue_indicator = true


func age():
	var date = DataManager.data.user.creation_date
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
		

func unshow():
	await get_tree().create_timer(2).timeout
	if able and finished and dialogue_indicator:
		control.state = control.states.IDLING
		popup.set_item_disabled(2,false)
		popup.set_item_disabled(0,false)
		close.play()
		tweening = false
		able = false
		timer = null
		txt.visible_characters = 0
		index = 0
		sentence = ""
		txt.text = sentence
		close_anim()
		dialogue_indicator = false


#region animations
func open_anim():
	create_tween().tween_property(bg, "scale", Vector2(0,0), 0)
	create_tween().tween_property(bg, "scale", Vector2(1.1,1.1), timetween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func close_anim():
	create_tween().tween_property(bg, "scale", Vector2(1.1,1.1), 0)
	create_tween().tween_property(bg, "scale", Vector2(0,0), timetween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
#endregion
