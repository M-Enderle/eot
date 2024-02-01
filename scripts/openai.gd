extends Node2D

var api_key = "sk-"
var temperature = 0.5
var model = "gpt-3.5-turbo"
var stream : bool = true

# Disallow parallel
signal stream_busy(is_busy:bool)
	
func _ready():
	print($Client)
	#$HTTPSSEClient.new_sse_event.connect(_on_new_sse_event)
	#var system_message = {"role":"system", "content": "You are a helpful virtual assistant."}
	
func _on_new_sse_event():
	print("test") 
	
func _call_gpt(prompt, ai_status_message):
	var new_message = {"role": "user", "content": prompt} 
	
	var host = "https://api.openai.com"
	var path = "/v1/chat/completions"
	var url = host + path
	
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]
	
	var body = JSON.stringify({
			"model": model,
			"messages": [new_message], # Send the array to chatGPT
			"temperature": temperature,
			"stream": true,
	})
	
	$HTTPSSEClient.connect_to_host(host, path, headers, body, ai_status_message, 443)
	stream_busy.emit(true)

func test():
	_call_gpt("Hello", $TEST)
	
