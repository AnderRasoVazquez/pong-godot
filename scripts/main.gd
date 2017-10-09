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

var screen_size
var score_left = 0
var score_right = 0
var shake_amount = 1.0
var rumble = 1
var activate_rumble = false


func _ready():
	randomize()
	get_node("music").play()
	set_power_up_spawn_timer()
	ball.connect("ball_collision", self, "_on_ball_collision")
	ball.connect("collision_with_paddle", self, "_on_collision_with_paddle")
	ball.connect("shield_hit", power_up_container, "_on_shield_hit")
	screen_size = get_viewport_rect().size
	camera.set_pos(screen_size / 2)
	separator.set_pos(screen_size / 2)
	ball.set_pos(screen_size / 2)
	left.connect("shield_hit_by_shoot", power_up_container, "_on_shield_hit")
	right.connect("shield_hit_by_shoot", power_up_container, "_on_shield_hit")
	left.set_pos(Vector2(screen_size.width * 0.10, screen_size.height * 0.5))
	right.set_pos(Vector2(screen_size.width * 0.90, screen_size.height * 0.5))
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("restart"):
		restart()

func restart():
	score_left = 0
	score_right = 0

func _process(delta):
	label_right.set_text(str(score_right))
	label_left.set_text(str(score_left))

	var ball_pos = ball.get_pos()
#
	# Check gameover
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
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
	camera.set_offset(Vector2(0, 0))

func _on_ball_collision():
	get_node("sound_effects").play("expl1")
	var e = explosion.instance()
	explosion_container.add_child(e)
	e.set_global_pos(ball.get_pos())
	activate_rumble = true
	rumble_timer.start()
	rumble *= 1.1
	if rumble > 5:
		rumble = 5

func _on_collision_with_paddle():
	left.set_pos(Vector2(screen_size.width * 0.10, left.get_pos().y))
	right.set_pos(Vector2(screen_size.width * 0.90, right.get_pos().y))
	var sup_lab = support_label.instance()
	HUD.add_child(sup_lab)
	var ball_pos = ball.get_global_pos()
	if ball_pos.x <= screen_size.x / 2:
		# sup_lab.set_global_pos(Vector2(ball_pos.x, ball_pos.y))
		sup_lab.set_global_pos(left.get_node("gun/muzzle").get_global_pos())
	else:
		sup_lab.set_global_pos(right.get_node("gun/muzzle").get_global_pos())

func _on_timer_timeout():
	var p = power_up.instance()
	p.connect("power_up_catched", self, "_on_power_up_catched")
	power_up_container.add_child(p)
	p.set_pos(Vector2(rand_range(screen_size.x * 0.3, screen_size.x * 0.7),
						rand_range(screen_size.y * 0.3, screen_size.y * 0.7)))
	set_power_up_spawn_timer()

func _on_power_up_catched(type):
	get_node("sound_effects").play("shield_up")
	power_up_container.execute(type)

func set_power_up_spawn_timer():
	power_up_spawn_timer.set_wait_time(rand_range(5, 10))
	power_up_spawn_timer.start()