extends RigidBody2D

var speed = 400
const INITIAL_SPEED = 150
const MAX_SPEED = 300
const ACC = 1.1
var who_hits = "left"

signal ball_collision
signal collision_with_paddle

func _ready():
	randomize()
	restart_speed()
	set_fixed_process(true)

func _fixed_process(delta):
	# move the body
	var bodies = get_colliding_bodies()

	for body in bodies:
		emit_signal("ball_collision")
		if body.is_in_group("platform"):
			#vel += vel * acc * delta
			emit_signal("collision_with_paddle")
			who_hits = body.get_name()
			var speed = get_linear_velocity().length()
			var direction = get_pos() - body.get_node("ancor").get_global_pos()
			var velocity = direction.normalized() * max(INITIAL_SPEED, min(speed * ACC, MAX_SPEED * ACC))
			set_linear_velocity(velocity)
	print(get_linear_velocity())

func restart_speed():
	var alter_dir = randi() % 2 == 0
	var dir = 1 if not alter_dir else -1
	set_linear_velocity(Vector2(150 * dir, 0))