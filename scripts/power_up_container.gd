extends Node2D

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
		build_shield(screen_size.x * 0.02, "left")
	elif ball.who_hits == "right" and not right_shielded:
		right_shielded = true
		build_shield(screen_size.x * 0.98, "right")
	else:
		print("already has shield")

func build_shield(pos_x, owner):
	print("building shield")
	var s = shield.instance()
	s.owner = owner
	add_child(s)
	s.set_global_pos(Vector2(pos_x, s.get_pos().y))

func _on_shield_hit(owner):
	get_node("../sound_effects").play("shield_down")
	print("shield_hit signal catched")
	if owner == "right":
		print("right shield destroyed")
		right_shielded = false
	else:
		print("right shield destroyed")
		left_shielded = false

func grow_strategy():
	print("grow strategy called")
	if ball.who_hits == "left":
		left.grow()
		grow_timer_left.start()
	elif ball.who_hits == "right":
		right.grow()
		grow_timer_right.start()

func _on_grow_timer_left_timeout():
	left.normal_size()

func _on_grow_timer_right_timeout():
	right.normal_size()

func missil_strategy():
	print("missil strategy called")
	if ball.who_hits == "left":
		left.bullets += 1
	elif ball.who_hits == "right":
		right.bullets += 1
