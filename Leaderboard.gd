extends Control


const url = "https://smileycarl.com/food_chain_api/api"
const use_ssl = true

var ScoreCard = preload("res://ScoreEntry.tscn")
var latest_score = null

func _ready():
	pass


func poll():
	print("Polling leaderboard...")
	var err = $HTTPRequest.request(url + "/scores")
	if err != OK: push_error("An error occured in the HTTP request")


func _on_HTTPRequest_request_completed(_result, _response_code, _headers, body):
	for child in $VBoxContainer.get_children():
		child.queue_free()

	var i = 1 # score indices start at 1
	var response = parse_json(body.get_string_from_utf8())
	for row in response:
		var score_card = ScoreCard.instance()
		score_card.refresh(i, row["name"], row["score"])
		$VBoxContainer.add_child(score_card)
		i += 1

	print("Leaderboard updated!")


func submit_score(score):
	var headers = ["Content-Type: application/json"]
	$HTTPPost.request(url + "/submit",
		headers, use_ssl, HTTPClient.METHOD_POST,
		JSON.print({
			"name": $Username.text,
			"score": score
		}))
	latest_score = 0 # disable multiple entries


func _on_PostButton_pressed():
	print("Latest Score: ", latest_score)
	print("By: ", $Username.text)

	if $Username.text and latest_score:
		submit_score(latest_score)
