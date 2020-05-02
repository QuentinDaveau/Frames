extends SignalManager


var is_on_ledge: bool = false
var can_play: bool = true


func _process(delta: float) -> void:
	if not can_play:
		return
	if Input.is_action_just_pressed("game_left_click"):
		if not is_on_ledge:
			owner.get_node("AnimationManager").play_animation("bull_slide", {"direction": "right"})
		else:
			owner.get_node("AnimationManager").play_animation("bull_fall")
			can_play = false


func signal_recieved(trigger_name: String) -> void:
	match trigger_name:
		"on_ledge":
			is_on_ledge = true
		"bull_hit_right":
			if not can_play:
				return
			if not is_on_ledge:
				owner.get_node("AnimationManager").play_animation("bull_slide", {"direction": "right"})
			else:
				owner.get_node("AnimationManager").play_animation("bull_fall")
				can_play = false
		"bull_hit_left":
			if not can_play:
				return
			if is_on_ledge:
				is_on_ledge = false
			owner.get_node("AnimationManager").play_animation("bull_slide", {"direction": "left"})
