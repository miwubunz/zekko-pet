extends Control

var happiness = 100
var eatingness = 100
var sleepiness = 0

var time

var late = false

@onready var control = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	print(sleepiness)
	time = Time.get_time_string_from_system().split(":")
	if int(time[0]) < 24 and int(time[0]) < 08:
		late = true
	else:
		late = false
	pass


func decrease_mood() -> void:
	if control.state != control.states[2]:
		if happiness != 0:
			happiness -= 1
		if eatingness != 0:
			eatingness -= 3
		if sleepiness != 100:
			if late:
				sleepiness += 15
			else:
				sleepiness += 5
		control.update_mood(happiness, eatingness, sleepiness)
	else:
		pass


func _on_sleeping_timeout() -> void:
	if sleepiness != 0:
		sleepiness -= 1
		control.update_mood(happiness, eatingness, sleepiness)
	pass
