extends Node


export(Dictionary) var _animations: Dictionary


func _ready() -> void:
	for animation in _animations.values():
		get_node(animation).set_players($AnimationPlayer, $Tween)


func play_animation(animation: String) -> void:
	if not _animations.has(animation):
		return
	get_node(_animations[animation]).play()
