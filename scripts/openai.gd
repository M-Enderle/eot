extends HTTPRequest

signal response_received(response)

var openai_url: String = "https://api.openai.com/v1/chat/completions"

func _init() -> void:
	connect("request_completed", Callable(self, "_on_request_completed"))

func call_api(api_key: String, message: String, max_tokens: int = 100) -> void:
	var headers: Array = [
		"Authorization: Bearer " + api_key,
		"Content-Type: application/json",
	]

	var postData: Dictionary = {
		"model": "gpt-3.5-turbo",
		"messages": [{"role": "user", "content": message}],
		"max_tokens": max_tokens
	}

	var json = JSON.new()
	var error: int = request(openai_url, headers, HTTPClient.METHOD_POST, json.print(postData))
	if error != OK:
		push_error("HTTP request failed with error: " + str(error))

func _on_request_completed(result: int, response_code: int, headers: PackedByteArray, body: PackedByteArray) -> void:
	var json = JSON.new()
	var response = json.parse(body.get_string_from_utf8())
	if response.error == OK:
		var data = response.result
		if "choices" in data and data["choices"].size() > 0:
			emit_signal("response_received", data["choices"][0]["message"]["content"].split("\n"))
		else:
			emit_signal("response_received", [])
	else:
		push_error("JSON parsing error: " + str(response.error))
