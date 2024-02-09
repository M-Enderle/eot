extends HTTPRequest

var error_label = null

func test_api_key(_error_label):
	var url_open_ai = "https://api.openai.com/v1/models"
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + Openai.openai_key]
	error_label = _error_label
	
	request_completed.connect(_on_api_request_completed)
	request(url_open_ai, headers, HTTPClient.METHOD_GET)

func _on_api_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if not "error" in json:
		get_tree().change_scene_to_file("res://scenes/cutscenes/intro.tscn")
	else:
		error_label.visible = true
		Openai.openai_key = "sk-"
