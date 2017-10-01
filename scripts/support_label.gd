extends Label


var text_opt = ["GREAT", "AWESOME", "NICE", "COOL", "YEAH", "LUCKY", "WOW", "EASY"]
onready var effect = get_node("effect")

func _ready():
	randomize()
	set_text(text_opt[rand_range(0, text_opt.size())])
	effect.interpolate_property(self, "visibility/opacity", 1, 0, 0.5,
								Tween.TRANS_QUAD, Tween.EASE_IN)
	effect.start()
func _on_time_timeout():
	queue_free()
