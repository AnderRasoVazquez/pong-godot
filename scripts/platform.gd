extends KinematicBody2D

const PAD_SPEED = 150

const MAX_SPEED = 350

var speed = PAD_SPEED
var confused = false

var bullets = 0

signal shield_hit_by_shoot

export var texture = "res://art/left_pallete.png"
export var move_up = "left_move_up"
export var move_down = "left_move_down"
export var shoot = "left_shoot"
export var run = "run"
export var flip_h = true
export var particle_color = Color(0,1,0.93,1)

onready var sound_effects = get_node("sound_effects")
onready var sprite = get_node("sprite")
onready var anim = get_node("anim")
onready var confuse_timer = get_node("confuse_timer")
onready var grow_effect = get_node("grow_effect")
onready var bullet_container = get_node("bullet_container")
onready var muzzle = get_node("gun/muzzle")
onready var gun = get_node("gun")
onready var particles = get_node("particles")
onready var bullet = preload("res://scenes/player_bullet.tscn")

func _ready():
	particles.set_color(particle_color)
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
	print("grow size")
	grow_effect.interpolate_property(self, "transform/scale", get_scale(),
								Vector2(1.0, 3.0), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	grow_effect.start()

func normal_size():
	print("normal size")
	sound_effects.play("shield_down")
	grow_effect.interpolate_property(self, "transform/scale", get_scale(),
							Vector2(1.0, 1.0), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	grow_effect.start()

func shoot():
	if bullets > 0:
		var b = bullet.instance()
		b.connect("shield_hit", self, "_on_shield_hit")
		bullet_container.add_child(b)
		b.start_at(muzzle.get_global_pos(), flip_h)
		sound_effects.play("laser1")
		sound_effects.play("expl")
		bullets -= 1
		if bullets == 0:
			gun.hide()
	else:
		print("no bullets bro")

func _on_shield_hit(owner):
	emit_signal("shield_hit_by_shoot", owner)

func set_confused():
	confused = true
	confuse_timer.start()
	anim.play("confused")

func _on_confuse_timer_timeout():
	confused = false
	anim.stop(true)
	sprite.set_opacity(1.0)
