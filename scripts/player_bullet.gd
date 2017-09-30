extends Area2D

signal shield_hit

var vel = Vector2()
var speed = 1000

func _ready():
	set_fixed_process(true)

func start_at(pos, flip_dir=false):
	set_pos(pos)
	if flip_dir:
		speed *=- 1
	vel = Vector2(speed, 0)

func _fixed_process(delta):
	set_pos(get_pos() + vel * delta)

func _on_visible_exit_screen():
	queue_free()

func _on_lifetime_timeout():
	queue_free()

func _on_player_bullet_body_enter( body ):
	if body.get_groups().has("platform"):
		print("platform hit")
		body.set_confused()
		body.normal_size()
		queue_free()
	if body.get_groups().has("shield"):
		print("shield hit by bullet")
		emit_signal("shield_hit", body.owner)
		body.queue_free()
		queue_free()
