extends Node2D

onready var HUD = get_node("HUD")
onready var label_left = get_node("HUD/left_score")
onready var label_right = get_node("HUD/right_score")
onready var support_label = preload("res://scenes/support_label.tscn")
onready var left = get_node("left")
onready var right = get_node("right")
onready var rumble_timer = get_node("rumble_timer")
onready var camera = get_node("camera")
onready var ball = get_node("ball")
onready var explosion_container = get_node("explosion_container")
onready var power_up_container = get_node("power_up_container")
onready var shield_container = get_node("shield_container")
onready var separator = get_node("separator")
onready var explosion = preload("res://scenes/explosion.tscn")
onready var power_up = preload("res://scenes/power_up.tscn")
onready var power_up_spawn_timer = get_node("power_up_spawn_timer")
onready var shield = preload("res://scenes/shield.tscn")

# POWER UP
# que aparezcan y el que las de que las gane
# alargar pala
# escudo para no perder
# misil que revienta la pala del otro

var screen_size
var score_left = 0
var score_right = 0
var shake_amount = 1.0
var rumble = 1
var activate_rumble = false

func _ready():
	randomize()
	power_up_spawn_timer.set_wait_time(rand_range(5, 10))
	power_up_spawn_timer.start()
	ball.connect("ball_collision", self, "_on_ball_collision")
	ball.connect("collision_with_paddle", self, "_on_collision_with_paddle")
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

func _on_collision_with_paddle():
	var sup_lab = support_label.instance()
	HUD.add_child(sup_lab)
	var ball_pos = ball.get_global_pos()
	if ball_pos.x <= screen_size.x / 2:
		sup_lab.set_global_pos(Vector2(ball_pos.x, ball_pos.y))
	else:
		sup_lab.set_global_pos(Vector2(ball_pos.x * 0.9, ball_pos.y))

func _on_timer_timeout():
	var p = power_up.instance()
	p.connect("power_up_catched", self, "_on_power_up_catched")
	power_up_container.add_child(p)
	p.set_pos(Vector2(rand_range(screen_size.x * 0.3, screen_size.x * 0.7),
						rand_range(screen_size.y * 0.3, screen_size.y * 0.7)))
	power_up_spawn_timer.set_wait_time(rand_range(20, 40))
	power_up_spawn_timer.start()

func _on_power_up_catched():
	# TODO hacer un strategy, este codigo no tiene que estar aqui
	# power_up use power
	print("building shield")
	var s = shield.instance()
	shield_container.add_child(s)
	if ball.who_hits == "left":
		s.set_pos(Vector2(screen_size.x * 0.05, screen_size.y / 2))
	else:
		s.set_pos(Vector2(screen_size.x * 0.95, screen_size.y / 2))
	s.connect("shield_hit", self, "_on_shield_hit")

func _on_shield_hit():
	print("shield_hit signal catched")
	ball.vel.x *= -1
