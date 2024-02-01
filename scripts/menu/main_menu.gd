extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var button = $StartButton
	button.connect("pressed", Callable(self, "start_game"))

	var line_edit = $KeyInput
	line_edit.connect("text_submitted", Callable(self, "start_game_from_lineedit"))

func start_game():
	if len($KeyInput.text) == 6 and $KeyInput.text.find(".") != -1:
		$ErrorLabel.visible = false
		Store.set_rev_ip($KeyInput.text)
		$KeyChecker.test_rev($ErrorLabel)
		
	elif $KeyInput.text.find("sk-") != -1:
		$ErrorLabel.visible = false
		Store.openai_key = $KeyInput.text
		$KeyChecker.test_api_key($ErrorLabel)
		
	else:
		$ErrorLabel.visible = true
	
func start_game_from_lineedit(event):
	start_game()
