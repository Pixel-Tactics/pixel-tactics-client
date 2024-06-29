extends Label

func _process(_delta):
	if self.text == "":
		_send_request()

func _send_request():
	var url = "http://" + ProjectSettings.get_setting("application/config/match_service_url")
	url = url + "/region"
	
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_response.bind(request))
	
	var err = request.request(
		url,
		[
			"Content-Type: application/json",
		],
		HTTPClient.METHOD_GET
	)
	if err != OK:
		self.text = "Server: Unknown Region"

func _on_response(result, response_code, _headers, body, request_obj):
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		self.text = "Server: Unknown Region"
		return
		
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	self.text = "Server: " + response["region"]
	
	request_obj.queue_free()
