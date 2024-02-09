extends HTTPRequest

var openai_key = ""
var message_history = []
var last_callback = null
var last_persona = ""


func _load_system_prompt(persona):
	return FileAccess.open("res://system_messages/echo.txt", FileAccess.READ).get_as_text()


func get_completion(message):
	var sys_prompt = _load_system_prompt(last_persona)
	message_history.append({"role": "user", "content": message})
	
	var json = JSON.stringify({
		 "model": "gpt-4",
		 "messages": [{"role": "system", "content": sys_prompt}] + message_history,
		 "temperature": 0.3,
   	})
	
	var url_open_ai = "https://api.openai.com/v1/chat/completions"
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + openai_key]
	
	request_completed.connect(last_callback)
	request(url_open_ai, headers, HTTPClient.METHOD_POST, json)
