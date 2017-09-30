extends Node


var left_shielded = false
var right_shielded = false
onready var ball = get_node("../ball")
onready var left = get_node("../left")
onready var right = get_node("../right")
var screen_size
onready var shield = preload("res://scenes/shield.tscn")
onready var grow_timer_left = get_node("grow_timer_left")
onready var grow_timer_right = get_node("grow_timer_right")

func _ready():
	screen_size = get_viewport_rect().size

func execute(type):
	print("execute called")
	if type == "shield":
		shield_strategy()
	elif type == "grow":
		grow_strategy()
	elif type == "missil":
		missil_strategy()

func shield_strategy():
	print("shield strategy called")
	if ball.who_hits == "left" and not left_shielded:
		left_shielded = true
		build_shield(screen_size.x * 0.05)
	elif ball.who_hits == "right" and not right_shielded:
		right_shielded = false
		build_shield(screen_size.x * 0.95)
	else:
		print("already has shield")

func build_shield(pos_x):
	print("building shield")
	var s = shield.instance()
	add_child(s)
	s.connect("shield_hit", self, "_on_shield_hit")
	s.set_global_pos(Vector2(pos_x, s.get_pos().y))

func _on_shield_hit():
	print("shield_hit signal catched")
	if ball.vel.x > 0:
		right_shielded = false
	else:
		left_shielded = false
	ball.vel.x *= -1

func grow_strategy():
	print("grow strategy called")
	if ball.who_hits == "left":
		left.grow()
		grow_timer_left.start()
	elif ball.who_hits == "right":
		right.set_scale(Vector2(1, 3))
		grow_timer_right.start()

func _on_grow_timer_left_timeout():
	left.normal_size()

func _on_grow_timer_right_timeout():
	print("grow left stop")
	right.set_scale(Vector2(1, 1))

func missil_strategy():
	print("not implemented yet")
	if ball.who_hits == "left":
		left.bullets += 1
	elif ball.who_hits == "right":
		right.bullets += 1
