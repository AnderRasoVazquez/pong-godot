extends Node2D

onready var label_left = get_node("HUD/left_score")
onready var label_right = get_node("HUD/right_score")
onready var left = get_node("left")
onready var right = get_node("right")
onready var rumble_timer = get_node("rumble_timer")
onready var camera = get_node("camera")
onready var ball = get_node("ball")
onready var explosion_container = get_node("explosion_container")
onready var separator = get_node("separator")
onready var explosion = preload("res://scenes/explosion.tscn")

var screen_size
var score_left = 0
var score_right = 0
var shake_amount = 1.0
var rumble = 1
var activate_rumble = false

func _ready():
	randomize()
	ball.connect("ball_collision", self, "_on_ball_collision")
	screen_size = get_viewport_rect().size
	separator.set_pos(screen_size / 2)
	ball.set_pos(screen_size / 2)
	left.set_pos(Vector2(screen_size.width * 0.10, screen_size.height * 0.5))
	right.set_pos(Vector2(screen_size.width * 0.90, screen_size.height * 0.5))
	label_left.set_pos(Vector2(screen_size.width * 0.25, 50))
	label_right.set_pos(Vector2(screen_size.width * 0.75, 50))
	set_process(true)

func _process(delta):
	label_right.set_text(str(score_right))
	label_left.set_text(str(score_left))

	var ball_pos = ball.get_pos()
#
	# Check gameover
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x): # TODO dividirlo para hacer un score
		if (ball_pos.x < 0):
			score_right += 1
		if (ball_pos.x > screen_size.x):
			score_left += 1
		rumble = 1
		ball.restart_speed()
		ball.set_pos( screen_size / 2)
#
	if activate_rumble:
		rumble(rumble)

func rumble(rumble):
	camera.set_offset(Vector2( \
        rand_range(-rumble, rumble) * shake_amount, \
        rand_range(-rumble, rumble) * shake_amount \
    ))

func _on_rumble_timer_timeout():
	activate_rumble = false

func _on_ball_collision():
	var e = explosion.instance()
	explosion_container.add_child(e)
	e.set_global_pos(ball.get_pos())
	activate_rumble = true
	rumble_timer.start()
	rumble *= 1.1
	if rumble > 5:
		rumble = 5