extends TextureRect

var initpos = self.position.x
var npos = initpos + 10
var timetween = 1

func bounce():
	create_tween().tween_property(self, "position:x", npos, timetween).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(timetween).timeout
	create_tween().tween_property(self, "position:x", initpos, timetween).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(timetween).timeout
	bounce()
