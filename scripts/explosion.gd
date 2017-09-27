extends Node2D

onready var explode_effect = get_node("effect")
onready var effect_timer = get_node("effect_timer")
onready var delete_timer = get_node("delete_timer")

func _ready():
	explode_effect.set_emitting(true)

func _on_effect_timer_timeout():
	explode_effect.set_emitting(false)
	delete_timer.start()

func _on_delete_timer_timeout():
	queue_free()
