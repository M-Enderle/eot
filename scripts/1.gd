extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = $Player.position
	var scientist_position = $Scientist.position

	# get distance between player and scientist
	var distance = player_position.distance_to(scientist_position)
	
	if distance < 60:
		$SpaceBar.visible = true
		$SpaceBar.play("default")
	else:
		$SpaceBar.visible = false
	
func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE:
			if $SpaceBar.visible:
				$Player.set_process_input(false)
