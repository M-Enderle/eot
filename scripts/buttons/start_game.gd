extends Button

func _pressed():
	get_tree().change_scene_to_file("res://game.tscn")

func _init():
	connect("mouse_entered", Callable(self, "entered"))
	connect("mouse_exited", Callable(self, "exited"))
	
func entered():
	$ButtonText.text = "[u]START GAME[/u]"
	
func exited():
	$ButtonText.text = "START GAME"
