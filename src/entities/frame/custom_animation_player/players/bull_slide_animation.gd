extends "../custom_animation_player.gd"




func _play_custom_animation(custom_properties: Dictionary) -> void:
	_tween_player.interpolate_property(owner, "position", owner.position, owner.position + Vector2(200.0, 0.0), 0.8, Tween.TRANS_EXPO, Tween.EASE_OUT)
	_tween_player.start()
	_animation_player.play("slide_right")
