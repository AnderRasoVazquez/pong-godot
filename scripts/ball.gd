extends KinematicBody2D

var speed = 100
const INITIAL_SPEED = 100
var vel = Vector2() # pixels/sec
var acc = 2
# set this to < 1.0 to demonstrate loss of energy
var bounce_coefficent = 1.0

signal ball_collision

func _ready():
	randomize()
	restart_speed()
	set_fixed_process(true)

func _fixed_process(delta):
	# move the body
	var motion = move(vel * delta)
	if is_colliding():
		emit_signal("ball_collision")
		if get_collider().is_in_group("platform"):
			vel += vel * acc * delta
		# find the normal
		var n = get_collision_normal()
		# reflect the motion *and* the velocity
		motion = n.reflect(motion)
		vel = n.reflect(vel) * bounce_coefficent
		# remember to also move the resulting motion amount
		move(motion)

func restart_speed():
	var dir = [-1.5, 1.5]
	vel = Vector2(dir[rand_range(0,2)], 0) * INITIAL_SPEED