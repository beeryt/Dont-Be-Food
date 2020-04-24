extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over(name):
	show_message("Eaten by\n" + str(name))
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Don't be Food!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$LeaderboardButton.show()
	#$SettingsButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$Leaderboard.hide()
	$StartButton.hide()
	$LeaderboardButton.hide()
	$SettingsButton.hide()
	$MessageLabel.show()
	$ScoreLabel.show()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_LeaderboardButton_pressed():
	$Leaderboard.show()
	$Leaderboard.poll()
	$LeaderboardButton.hide()
	$MessageLabel.hide()
