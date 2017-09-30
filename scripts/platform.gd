extends KinematicBody2D

const PAD_SPEED = 150

const MAX_SPEED = 350

var speed = PAD_SPEED
var confused = false

var bullets = 0

export var texture = "res://art/left_pallete.png"
export var move_up = "left_move_up"
export var move_down = "left_move_down"
export var shoot = "left_shoot"
export var run = "run"
export var flip_h = true

onready var sprite = get_node("sprite")
onready var anim = get_node("anim")
onready var confuse_timer = get_node("confuse_timer")
onready var grow_effect = get_node("grow_effect")
onready var bullet_container = get_node("bullet_container")
onready var muzzle = get_node("gun/muzzle")
onready var gun = get_node("gun")
onready var bullet = preload("res://scenes/player_bullet.tscn")

func _ready():
	var t = load(texture)
	sprite.set_texture(t)
	if flip_h:
		set_rot(PI)
	add_to_group("platform")
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.is_action_pressed(shoot):
		shoot()

func _process(delta):
	gun.show() if bullets > 0 else gun.hide()

	if Input.is_action_pressed(run):
		speed = MAX_SPEED
	else:
		speed = PAD_SPEED
	if Input.is_action_pressed(move_up):
		if not confused:
			var motion = move(Vector2(0, -1) * speed * delta)
		else:
			var motion = move(Vector2(0, 1) * speed * delta)
	if Input.is_action_pressed(move_down):
		if not confused:
			var motion = move(Vector2(0, 1) * speed * delta)
		else:
			var motion = move(Vector2(0, -1) * speed * delta)

func grow():
	grow_effect.interpolate_property(self, "transform/scale", get_scale(),
								Vector2(1.0, 3.0), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	grow_effect.start()

func normal_size():
	grow_effect.interpolate_property(self, "transform/scale", get_scale(),
							Vector2(1.0, 1.0), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	grow_effect.start()

func shoot():
	if bullets > 0:
		var b = bullet.instance()
		bullet_container.add_child(b)
		b.start_at(muzzle.get_global_pos(), flip_h)
		#shoot_sounds.play("laser2")
		bullets -= 1
		if bullets == 0:
			gun.hide()
	else:
		print("no bullets bro")

func set_confused():
	confused = true
	confuse_timer.start()
	anim.play("confused")

func _on_confuse_timer_timeout():
	confused = false
	anim.stop(true)
	sprite.set_opacity(1.0)
