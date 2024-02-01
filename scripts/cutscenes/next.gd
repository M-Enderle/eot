extends Node2D


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var children = self.get_children()
		children.reverse()
		for c in children:
			if c.visible:
				c.visible = false
				if children.find(c) == len(children) - 1:
					get_tree().change_scene_to_file("res://levels/1.tscn")
				break
		
