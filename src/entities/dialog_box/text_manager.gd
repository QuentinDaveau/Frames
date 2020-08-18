extends Node

signal text_drawing_finished()

export(bool) var _wait_for_input: bool = true
export(float) var _single_character_drawing_speed: float = 0.025
export(NodePath) var _text_label_path: NodePath

onready var _dialog_player = owner.get_node("DialogPlayer")
onready var _bars_tweener = owner.get_node("BarsTweener")
onready var _text_label = get_node(_text_label_path)

var _text_is_drawing: bool = false
var _is_speaking: bool = false
var _dialog_queue: Array = []


func _ready() -> void:
	$Tween.connect("tween_all_completed", self, "_tween_finished")
	_dialog_player.connect("animation_finished", self, "_on_dialog_finished")
	_bars_tweener.connect("bars_updated", self, "_on_bars_finished")
	yield(get_tree().create_timer(2.0), "timeout")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		start_dialog("test")
	if _is_speaking and _wait_for_input and (not _text_is_drawing):
		if Input.is_action_just_pressed("ui_accept"):
			_next_action()


# Add a way to continue interrupted text ?
func start_dialog(dialog_id: String, overridable: bool = true, takes_priority: bool = false) -> void:
	var dialog_dict := {"id": dialog_id, "overridable": overridable}
	if takes_priority:
		_dialog_queue= [dialog_dict]
	if _is_speaking:
		if _dialog_queue[0]["overridable"]:
			_dialog_queue.pop_front()
			_dialog_queue.push_front(dialog_dict)
			return
		else:
			_dialog_queue.append(dialog_dict)
	else:
		_dialog_queue.append(dialog_dict)
	_bars_tweener.open_bars()


func draw_text(text: String, allow_pause: bool = true) -> void:
	if _dialog_player.is_playing() && allow_pause:
		_dialog_player.stop(false)
	var text_length: int = text.length()
	text = "[center]" + text + "[/center]"
	_text_label.visible_characters = 0
	_text_label.bbcode_text = text
	$Tween.interpolate_property(
		_text_label, "visible_characters", 0, text_length,
		_single_character_drawing_speed * text_length, Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	$Tween.start()


func _next_action() -> void:
	_dialog_player.play()


func _tween_finished() -> void:
	_text_is_drawing = false
	if not _wait_for_input:
		_next_action()


func _on_dialog_finished(anim_name: String) -> void:
	if anim_name == _dialog_queue[0]["id"]:
		_is_speaking = false
		_dialog_queue.pop_front()
		owner.follow_player()
		_text_label.bbcode_text = ""
		_bars_tweener.close_bars()


func _on_bars_finished(opening: bool) -> void:
	if opening:
		_dialog_player.play(_dialog_queue[0]["id"])
		_is_speaking = true
