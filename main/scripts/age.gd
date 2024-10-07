extends RichTextLabel

var data_path = "user://date.inf"
var year
var month
var week
var day

func _ready() -> void:
	age()
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

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
		
		text = "[i]" + tr("AGE") + retrieve_str()

func retrieve_str():
	if year > 0:
		return str(year) + tr("YEAR") + ("" if year == 1 else "s")
	elif month > 0:
		return str(month) + tr("MONTH") + ("" if month == 1 else tr("PLURAL"))
	elif week > 0:
		return str(week) + tr("WEEK") + ("" if week == 1 else "s")
	elif day >= 0:
		return str(day) + tr("DAY") + ("" if day == 1 else "s")
	else:
		return "NOVALUE"
