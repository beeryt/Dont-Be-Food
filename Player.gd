extends Area2D

signal hit(name)

# how fast the player will move (pixels/sec)
export var speed = 400

# size of the game window
var screen_size

var target = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
	if event is InputEventScreenDrag:
		target = event.position

func _process(delta):

	var target_velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		target_velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		target_velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		target_velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		target_velocity.y -= 1
	if target_velocity.length() > 0:
		target_velocity = target_velocity.normalized() * speed
	target += target_velocity * delta
	target.x = clamp(target.x, 0, screen_size.x)
	target.y = clamp(target.y, 0, screen_size.y)

	var velocity = Vector2()
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # player disappears after being hit
	emit_signal("hit", body.sprite.animation)
	$CollisionShape2D.set_deferred("disabled", true)
