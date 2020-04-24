extends MarginContainer

signal setting_changed

const url = "https://smileycarl.com/food_chain_api/api"
const use_ssl = true

var ScoreCard = preload("res://ScoreEntry.tscn")
var latest_score = 0
var polling = false

func _ready():
	print("Leaderboard ready")
	for _i in range(10):
		$Container/Scores.add_child(ScoreCard.instance())
	poll()
	print($Container/Scores.get_children())


func poll():
	print("Polling leaderboard...", polling)
	if polling: return # only 1 request at a time
	polling = true
	var err = $HTTPRequest.request(url + "/scores")
	if err != OK: push_error("An error occured in the HTTP request")

	$Container/HBoxContainer/PostButton.disabled = false if latest_score else true


func _on_HTTPRequest_request_completed(_result, _response_code, _headers, body):
	polling = false

	var i = 1 # score indices start at 1
	var response = parse_json(body.get_string_from_utf8())
	for row in response:
		var score_card = $Container/Scores.get_child(i-1)
		score_card.refresh(i, row["name"], row["score"])
		i += 1

	print("Leaderboard updated!")


func submit_score(score):
	var headers = ["Content-Type: application/json"]
	$HTTPPost.request(url + "/submit",
		headers, use_ssl, HTTPClient.METHOD_POST,
		JSON.print({
			"name": $Container/HBoxContainer/Username.text,
			"score": score
		}))
	print("Submitted: ", $Container/HBoxContainer/Username.text, " ", score)
	latest_score = 0 # disable multiple entries
	OS.delay_msec(500)
	poll()


func _on_PostButton_pressed():
	print("Latest Score: ", latest_score)
	print("By: ", $Container/HBoxContainer/Username.text)

	if $Container/HBoxContainer/Username.text and latest_score:
		submit_score(latest_score)


func _on_Username_text_changed(_new_text):
	emit_signal("setting_changed")


func _on_AutoSwitch_toggled(_button_pressed):
	emit_signal("setting_changed")


func _on_Username_focus_entered():
	if OS.get_name() == "HTML5":
		print("HTML5 operating system detected")
		var existing = $Container/HBoxContainer/Username.text
		var prompt = 'prompt("Enter Username", "%s");' % [existing]
		var new_text = JavaScript.eval(prompt)
		if new_text:
			$Container/HBoxContainer/Username.text = new_text
