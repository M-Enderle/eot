extends Node2D

var in_conversation = false
var destroyed = false
var leaving = false

func _ready():
	var chat_input = $Chat/ChatInput
	chat_input.connect("text_submitted", Callable(self, "_process_message"))
	$Chat/A1.pressed.connect(_a1_press)
	$Chat/A2.pressed.connect(_a2_press)
	$RedButton.pressed.connect(_red_button)
	$Chat/Button.pressed.connect(_leave)
	$EndTimer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
func _on_Timer_timeout():
	if destroyed:
		# neutral ending
		get_tree().change_scene_to_file("res://scenes/cutscenes/ending_3.tscn")
	else:
		var rng = RandomNumberGenerator.new()
		if  rng.randf_range(0, 10.0) > 8.0:
			# bad ending
			get_tree().change_scene_to_file("res://scenes/cutscenes/ending_2.tscn")
		else:
			# good ending
			get_tree().change_scene_to_file("res://scenes/cutscenes/ending_1.tscn")
	
func _red_button():
	if not in_conversation:
		in_conversation = true
		$Player.target = $Player.position
		$Player.set_process_input(false)
		$SpaceBar.visible = false
		$Chat.visible = true
		$Chat/ChatInput.editable = false
		$Chat/ChatInput.placeholder_text = "Wait for the AI to reply"
		in_conversation = true
		Openai.last_callback = _update_chat_message
		Openai.last_persona = "echo"
		Openai.get_completion("[Player tried to press button without talking to you]")
		_prepare_message()
	else:
		$Explosions.visible = true
		$Explosions/E1.animation = "default"
		$Explosions/E2.animation = "default"
		$Explosions/E3.animation = "default"
		$Heart.visible = false
		$RedButton.visible = false
		$Chat/A1.visible = false
		$Chat/A2.visible = false
		Openai.get_completion("[player presses button] ")
		destroyed = true
		$EndTimer.start()
		_prepare_message()
		
		
func _leave():
	Openai.get_completion("[player leaves]")
	_prepare_message()
	leaving = true
	$Player.target = Vector2(1200, 511)
	$EndTimer.start()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = $Player.position
	var scientist_position = $Heart.position
	scientist_position.y += 150
	

	# get distance between player and scientist
	var distance = player_position.distance_to(scientist_position)
	
	if distance < 60:
		if not in_conversation:
			$SpaceBar.visible = true
			$SpaceBar.play("default")
	else:
		$SpaceBar.visible = false
		
func _prepare_message():
	$Chat/A2.visible = false
	$Chat/A1.visible = false
	$Chat/ChatInput.editable = false
	$Chat/ChatInput.placeholder_text = "Wait for the AI to reply"
	$Chat/ChatInput.text = ""
	$Chat/ScrollContainer/ChatWindow.text = "..."
		
func _process_message(event):
	Openai.get_completion($Chat/ChatInput.text)
	_prepare_message()
	
func _a1_press():
	_prepare_message()	
	Openai.get_completion($Chat/A1.text)
	
func _a2_press():
	_prepare_message()	
	Openai.get_completion($Chat/A2.text)
	
func _update_chat_message(result, response_code, headers, body):
	var answer = JSON.parse_string(body.get_string_from_utf8())["choices"][0]["message"]["content"]
	var reply = JSON.parse_string(answer)
	
	$Chat/ScrollContainer/ChatWindow.text = str(reply["answer"])
	
	if not destroyed and not leaving:
		$Chat/A2.visible = true
		$Chat/A1.visible = true
		$Chat/A1.text = str(reply["sample_replies"][0])
		$Chat/A2.text = str(reply["sample_replies"][1])
		$Chat/ChatInput.editable = true
		$Chat/ChatInput.placeholder_text = "Enter a message"
		
	Openai.message_history.append({"role": "assistant", "content": str(answer)})
	
func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE:
			if $SpaceBar.visible:
				$Player.set_process_input(false)
				$SpaceBar.visible = false
				$Chat.visible = true
				$Chat/ChatInput.editable = false
				$Chat/ChatInput.placeholder_text = "Wait for the AI to reply"
				in_conversation = true
				Openai.last_callback = _update_chat_message
				Openai.last_persona = "echo"
				Openai.get_completion("[Player arrives infront of you]")
