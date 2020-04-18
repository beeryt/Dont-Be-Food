extends RigidBody2D

export var min_speed = 150
export var max_speed = 250
var mob_types = ["Brian the Fish", "Greg the Whale", "Jocelyn the Jellyfish"]
var sprite

func _ready():
	sprite = $AnimatedSprite
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _on_start_game():
	queue_free()

func _on_Visibility_screen_exited():
	queue_free()
