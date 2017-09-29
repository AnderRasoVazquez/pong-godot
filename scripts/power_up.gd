extends Area2D

signal power_up_catched

onready var collision = get_node("collision")
onready var effect = get_node("effect")
onready var sprite = get_node("sprite")

func _ready():
	effect.interpolate_property(sprite, "transform/scale", sprite.get_scale(),
								Vector2(2.0, 2.0), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(sprite, "visibility/opacity", 1, 0, 0.3,
								Tween.TRANS_QUAD, Tween.EASE_OUT)

func _on_power_up_body_enter( body ):
	print("power up catched")
	emit_signal("power_up_catched")
	effect.start()
	clear_shapes()

func _on_effect_tween_complete( object, key ):
	queue_free()
