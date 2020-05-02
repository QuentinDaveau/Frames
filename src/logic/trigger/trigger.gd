extends Area2D

signal trigger_activated()
signal trigger_deactivated()

enum TARGET_TYPE{character, frame, object}

export(String) var _trigger_identifier: String
export(TARGET_TYPE) var _target_type: int
export(bool) var _look_for_specific_target: bool = false
export(NodePath) var _specific_target: NodePath
export(bool) var _notify_target: bool = true
export(Array, NodePath) var _observers: Array


func _ready() -> void:
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exit")

	for observer in _observers:
		connect("trigger_activated", get_node(observer), "_on_trigger_activated", [_trigger_identifier])
		connect("trigger_deactivated", get_node(observer), "_on_trigger_deactivated", [_trigger_identifier])
		


func _on_body_enter(body: Node) -> void:
	if _specific_target:
		if not body == get_node(_specific_target):
			return
	else:
		if not body.get_class() == _get_desired_target_type():
			return
	if _notify_target:
		connect("trigger_activated", body, "_on_trigger_activated", [_trigger_identifier], CONNECT_ONESHOT)
	emit_signal("trigger_activated")
	


func _on_body_exit(body: Node) -> void:
	if _specific_target:
		if not body == get_node(_specific_target):
			return
	else:
		if not body.get_class() == _get_desired_target_type():
			return
	if _notify_target:
		connect("trigger_deactivated", body, "_on_trigger_deactivated", [_trigger_identifier], CONNECT_ONESHOT)
	emit_signal("trigger_deactivated")


func _get_desired_target_type() -> String:
	match _target_type:
		TARGET_TYPE.character:
			return "Character"
		TARGET_TYPE.frame:
			return "Frame"
		TARGET_TYPE.object:
			return ""
	return ""
