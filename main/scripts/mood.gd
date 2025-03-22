extends Control

var happiness = 100
var eatingness = 100
var sleepiness = 0

var time

var late = false

@onready var control = $".."


func _process(_delta: float) -> void:
	time = Time.get_time_string_from_system().split(":")
	if int(time[0]) < 24 and int(time[0]) < 08:
		late = true
	else:
		late = false
	pass


func decrease_mood() -> void:
	if control.state != control.states.SLEEPING:
		if happiness > 0:
			happiness -= 1
		happiness = max(happiness, 0)
		
		if eatingness > 0:
			eatingness -= 3
		eatingness = max(eatingness, 0)
		
		if sleepiness < 100:
			if late:
				sleepiness += 15
			else:
				sleepiness += 5
		sleepiness = min(sleepiness, 100)
		
		control.update_mood(happiness, eatingness, sleepiness)
	else:
		pass


func _on_sleeping_timeout() -> void:
	if sleepiness > 0:
		sleepiness -= 1
	
	control.update_mood(happiness, eatingness, sleepiness)
	pass
