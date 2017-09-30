extends Area2D

signal power_up_catched

onready var collision = get_node("collision")
onready var effect = get_node("effect")
onready var sprite = get_node("sprite")
var type

# diferentes power ups
#var types = ['shield', 'grow', 'missil']
var types = ['grow']
var type_texture = {'shield': 'res://art/sheet.powerupBlue_shield.atex',
				'grow': 'res://art/sheet.powerupGreen_star.atex',
				'missil': 'res://art/sheet.powerupRed_bolt.atex'
			}

func _ready():
	randomize()
	type = types[randi() % types.size()]
	var texture = load(type_texture[type])
	sprite.set_texture(texture)
	effect.interpolate_property(sprite, "transform/scale", sprite.get_scale(),
								Vector2(2.0, 2.0), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(sprite, "visibility/opacity", 1, 0, 0.3,
								Tween.TRANS_QUAD, Tween.EASE_OUT)

func _on_power_up_body_enter( body ):
	print("power up catched")
	emit_signal("power_up_catched", type)
	effect.start()
	clear_shapes()

func _on_effect_tween_complete( object, key ):
	queue_free()
