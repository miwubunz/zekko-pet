extends Node

func send_error(error: String) -> void:
	OS.alert(error, "Error!")