extends Node
class_name CustomAnimationPlayer

signal animation_finished()
signal animation_started()

export(bool) var _can_be_overridden: bool = true
export(Dictionary) var _animations: Dictionary

var _animation_player: AnimationPlayer
var _tween_player: Tween
var _animation_player_finished: bool = true
var _tween_player_finished: bool = true


func play(custom_properties: Dictionary = {}) -> void:
    emit_signal("animation_started")
    _play_custom_animation(custom_properties)


func set_players(animation_player: AnimationPlayer, tween_player: Tween) -> void:
    _animation_player = animation_player
    _tween_player = tween_player
    _animation_player.connect("animation_started", self, "_animation_player_started")
    _animation_player.connect("animation_finished", self, "_animation_player_finished")
    _tween_player.connect("tween_started", self, "_tween_player_started")
    _tween_player.connect("tween_completed", self, "_tween_player_finished")

    for animation_name in _animations.keys():
        _animation_player.add_animation(animation_name, _animations[animation_name])


func _play_custom_animation(custom_properties: Dictionary) -> void:
    pass
        


func _animation_component_started(signal_origin: String) -> void:
    match signal_origin:
        "animation":
            _animation_player_finished = false
        "tween":
            _tween_player_finished = false


func _animation_component_finished(signal_origin: String) -> void:
    match signal_origin:
        "animation":
            _animation_player_finished = true
        "tween":
            _tween_player_finished = true
    if _animation_player_finished && _tween_player_finished:
        emit_signal("animation_finished")


func _animation_player_started(animation_name: String) -> void:
    _animation_player_finished = false


func _animation_player_finished(animation_name: String) -> void:
    _animation_player_finished = true


func _tween_player_started(animated_object: Object, key: NodePath) -> void:
    _tween_player_finished = false


func _tween_player_finished(animated_object: Object, key: NodePath) -> void:
    _tween_player_finished = true