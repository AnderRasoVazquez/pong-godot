extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal shield_hit

func _ready():
	pass

func _on_shield_body_enter( body ):
	print("shield hit")
	emit_signal("shield_hit")
	clear_shapes()
	queue_free()
