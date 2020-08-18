extends Area2D

signal trigger_activated()
signal trigger_deactivated()

enum TARGET_TYPE{all, actor, character, frame}

export(String) var _trigger_identifier: String
export(TARGET_TYPE) var _target_type: int
export(bool) var _look_for_specific_target: bool = false
export(NodePath) var _specific_target: NodePath
export(bool) var _notify_target: bool = true
export(Array, NodePath) var _observers: Array


func _ready() -> void:
	for observer in _observers:
		connect("trigger_activated", get_node(observer), "_on_trigger_activated", [_trigger_identifier])
		connect("trigger_deactivated", get_node(observer), "_on_trigger_deactivated", [_trigger_identifier])


func _on_body_entered(body: Node) -> void:
	if not _check_class(body):
		return
	if _notify_target:
		connect("trigger_activated", body, "_on_trigger_activated", [_trigger_identifier], CONNECT_ONESHOT)
	emit_signal("trigger_activated")


func _on_body_exited(body: Node) -> void:
	if not _check_class(body):
		return
	if _notify_target:
		connect("trigger_deactivated", body, "_on_trigger_deactivated", [_trigger_identifier], CONNECT_ONESHOT)
	emit_signal("trigger_deactivated")


func _check_class(body: Node) -> bool:
	if _specific_target:
		return body == get_node(_specific_target)
	else:
		return _body_is_desired_target_type(body)


func _body_is_desired_target_type(body: Node) -> bool:
	match _target_type:
		TARGET_TYPE.all:
			return true
		TARGET_TYPE.actor:
			if body is Actor: 
				return true
		TARGET_TYPE.character:
			if body is Character: 
				return true
		TARGET_TYPE.frame:
			if body is Frame: 
				return true
	return false
