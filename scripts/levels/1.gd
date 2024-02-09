extends Node2D

var in_conversation = false

func _ready():
	$ExitButton.pressed.connect(_exit)
	var chat_input = $Chat/ChatInput
	chat_input.connect("text_submitted", Callable(self, "_process_message"))
	$Chat/A1.pressed.connect(_a1_press)
	$Chat/A2.pressed.connect(_a2_press)
	$Chat/Button.pressed.connect(_leave)
	$LastFrame/Timer.connect("timeout", Callable(self, "_change_level"))
	Openai.message_history = []
	
func _leave():
	$Chat.visible = false
	$Player.set_process_input(true)
	
func _exit():
	$LastFrame.visible = true
	$LastFrame/Timer.start()
	
func _change_level():	
	get_tree().change_scene_to_file("res://scenes/levels/final.tscn")
	
func _process(delta):
	var player_position = $Player.position
	var scientist_position = $Scientist.position

	var distance = player_position.distance_to(scientist_position)
	
	if distance < 60:
		if not in_conversation:
			$SpaceBar.visible = true
			$SpaceBar.play("default")
	else:
		$SpaceBar.visible = false
		
	var distance_exit = player_position.distance_to($ExitButton.position)
	
	if distance_exit < 60:
		$ExitButton.visible = true
	else:
		$ExitButton.visible = false
		
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
				Openai.last_persona = "turing"
				Openai.get_completion("[Player arrives infront of you]")
