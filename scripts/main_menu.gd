extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var button = $StartButton
	button.connect("pressed", Callable(self, "start_game"))

	var line_edit = $KeyInput
	line_edit.connect("text_submitted", Callable(self, "start_game_from_lineedit"))

	Openai.test()

func start_game():
	print("Starting")
	
	
func start_game_from_lineedit(event):
	if len($KeyInput.text) == 6 and $KeyInput.text.find(".") != -1:
		Store.set_rev_ip($KeyInput.text)
		
	elif $KeyInput.text.find("sk-") != -1:
		print("OpenAI Key")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
