extends Node


export(Dictionary) var _animations: Dictionary


func _ready() -> void:
	for animation in _animations.values():
		get_node(animation).set_players($AnimationPlayer, $Tween)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("game_left_click"):
		play_animation("bull_slide")



func play_animation(animation: String) -> void:
	if not _animations.has(animation):
		return
	get_node(_animations[animation]).play()
