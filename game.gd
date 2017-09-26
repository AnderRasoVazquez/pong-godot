extends Node2D

# class member variables go here, for example:
var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)
var score_left = 0
var score_right = 0
onready var label_left = get_node("HUD/left_score")
onready var label_right = get_node("HUD/right_score")
onready var explode_effect = get_node("effect")
onready var effect_timer = get_node("effect_timer")
onready var rumble_timer = get_node("rumble_timer")
onready var camera = get_node("camera")

# constant for ball speed for (in pixels/second)
const INITIAL_BALL_SPEED = 100
# ball speed in pixels/second
var ball_speed = INITIAL_BALL_SPEED
# constant for pad speed
const PAD_SPEED = 150

var shake_amount = 1.0

var rumble = 3
var activate_rumble = false

func _ready():
	randomize()
	# Called every time the node is added to the scene.
	# Initialization here
	screen_size = get_viewport_rect().size
	label_left.set_pos(Vector2(screen_size.width * 0.25, 50))
	label_right.set_pos(Vector2(screen_size.width * 0.75, 50))
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)

func _process(delta):
	label_right.set_text(str(score_right))
	label_left.set_text(str(score_left))
	var ball_pos = get_node("ball").get_pos()
	var left_rect = Rect2( get_node("left").get_pos() - pad_size*0.5, pad_size )
	var right_rect = Rect2( get_node("right").get_pos() - pad_size*0.5, pad_size )
	ball_pos += direction * ball_speed * delta
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
		effect_timer.start()
		explode_effect.set_global_pos(ball_pos)
		explode_effect.set_emitting(true)
		activate_rumble = true
		rumble_timer.start()
		
		
	# Flip, change direction and increase speed when touching pads
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		effect_timer.start()
		explode_effect.set_global_pos(ball_pos)
		explode_effect.set_emitting(true)
		if rumble == 0:
			rumble += 1
		else:
			rumble *= 1.1
		activate_rumble = true
		rumble_timer.start()
		
# Check gameover
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x): # TODO dividirlo para hacer un score
		if (ball_pos.x < 0):
			score_right += 1
		if (ball_pos.x > screen_size.x):
			score_left += 1
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		rumble = 0
	get_node("ball").set_pos(ball_pos)
	# Move left pad
	var left_pos = get_node("left").get_pos()
	
	if (left_pos.y - pad_size.y *0.5 > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y + pad_size.y *0.5 < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	
	get_node("left").set_pos(left_pos)
	
	# Move right pad
	var right_pos = get_node("right").get_pos()
	
	if (right_pos.y - pad_size.y *0.5 > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y + pad_size.y *0.5 < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta
	
	get_node("right").set_pos(right_pos)
	
	if activate_rumble:
		rumble(rumble)



func _on_effect_timer_timeout():
	explode_effect.set_emitting(false)

func rumble(rumble):
	camera.set_offset(Vector2( \
        rand_range(-rumble, rumble) * shake_amount, \
        rand_range(-rumble, rumble) * shake_amount \
    ))

func _on_rumble_timer_timeout():
	activate_rumble = false
