extends HBoxContainer


func refresh(index, user, score):
	$Index.text = str(index) + "."
	$Name.text = str(user)
	$Score.text = str(score)
