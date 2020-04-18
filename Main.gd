extends Node

export (PackedScene) var Mob
var score

func _ready():
	var scr = $Player.get_viewport_rect().size
	$StartPosition.position.x = scr.x / 2
	$StartPosition.position.y = scr.y * float(2)/float(3)
	$MobPath.curve.clear_points()
	$MobPath.curve.add_point(Vector2(0, 0))
	$MobPath.curve.add_point(Vector2(scr.x, 0))
	$MobPath.curve.add_point(Vector2(scr.x, scr.y))
	$MobPath.curve.add_point(Vector2(0, scr.y))
	$MobPath.curve.add_point(Vector2(0, 0))

	randomize()

func game_over(name):
	$ScoreTimer.stop()
	$MobTimer.stop()

	$HUD.show_game_over(name)

	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

	$Music.play()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	# choose a random location on Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	# create a mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	# set the mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	# set the mob's positon
	mob.position = $MobPath/MobSpawnLocation.position
	# add some randomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	if (mob.rotation > PI/2):
		mob.sprite.flip_v = true
	# set the velocity
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

	$HUD.connect("start_game", mob, "_on_start_game")
