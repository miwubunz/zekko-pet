extends Control

var to_select = false

var time_tween = 0.5
var p

func call_prompt(obj):
	if !to_select:
		p = obj
		$sure.text = tr("BUY_1") + tr(p.tag) + "[/i][/b]?[/wave]"
		$ye.position.y = $bg.size.y / 3
		$na.position.y = $bg.size.y / 3
		to_select = true
		scale = Vector2(0,0)
		create_tween().tween_property(self, "scale", Vector2(1,1), time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func uncall_prompt(yes):
	to_select = false
	scale = Vector2(1,1)
	create_tween().tween_property(self, "scale", Vector2(0,0), time_tween).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	match yes:
		true:
			print(p)
			p.buy()
		false:
			pass

func _on_ye_pressed() -> void:
	if to_select:
		uncall_prompt(true)
	pass


func _on_na_pressed() -> void:
	if to_select:
		uncall_prompt(false)
	pass
