extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in self.get_children():
		print(i)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
