extends RigidBody2D

var speed = 400
const INITIAL_SPEED = 200
const MAX_SPEED = 500
const ACC = 1.1
var who_hits = "left"

signal ball_collision
signal collision_with_paddle
signal shield_hit

func _ready():
	randomize()
	restart_speed()
	set_fixed_process(true)

func _fixed_process(delta):
	var bodies = get_colliding_bodies()

	for body in bodies:
		emit_signal("ball_collision")
		if body.is_in_group("platform"):
			emit_signal("collision_with_paddle")
			who_hits = body.get_name()
			var speed = get_linear_velocity().length()
			var direction = get_pos() - body.get_node("ancor").get_global_pos()
			var velocity = direction.normalized() * max(INITIAL_SPEED, min(speed * ACC, MAX_SPEED * ACC))
			set_linear_velocity(velocity)
		elif body.is_in_group("shield"):
			emit_signal("shield_hit", body.owner)
			body.queue_free()

func restart_speed():
	var alter_dir = randi() % 2 == 0
	var dir = 1 if not alter_dir else -1
	set_linear_velocity(Vector2(INITIAL_SPEED * dir, 0))