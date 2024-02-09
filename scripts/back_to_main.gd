extends Node2D


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and $Node2D/Timer.time_left <= 0:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
