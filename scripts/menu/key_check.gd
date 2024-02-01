extends HTTPRequest

var valid = null
var error_label = null
var request_open = false


func test_api_key(_error_label):
	var url_open_ai = "https://api.openai.com/v1/models"
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + Store.openai_key]
	error_label = _error_label
	
	request_completed.connect(_on_api_request_completed)
	request(url_open_ai, headers, HTTPClient.METHOD_GET)
	
	
func test_rev(_error_label):
	var url_rev = Store.rev_ip + "/v1/chat/completions"
	var headers = ["Content-Type: application/json"]
	var json = JSON.stringify({
		 "model": "gpt-3.5-turbo",
		 "messages": [{"role": "user", "content": "Say Hi"}],
		 "temperature": 0.2,
		 "max_tokens": 1
   })
	
	error_label = _error_label
	
	request_completed.connect(_on_rev_request_completed)
	
	timeout = 10
	request_open = true
	
	request(url_rev, headers, HTTPClient.METHOD_POST, json)
	
	
func _on_api_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if not "error" in json:
		get_tree().change_scene_to_file("res://scenes/cutscenes/intro.tscn")
	else:
		error_label.visible = true
		Store.openai_key = "sk-"
		

func _on_rev_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	if not json:
		error_label.visible = true
		Store.rev_ip = ""
	else:
		get_tree().change_scene_to_file("res://scenes/cutscenes/intro.tscn")
		

