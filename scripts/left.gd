extends KinematicBody2D

const PAD_SPEED = 150

var speed = 150

func _ready():
	add_to_group("platform")
	set_process_input(true)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("left_move_up"):
		var motion = move(Vector2(0, -1) * PAD_SPEED * delta)
	if Input.is_action_pressed("left_move_down"):
		var motion = move(Vector2(0, 1) * PAD_SPEED * delta)