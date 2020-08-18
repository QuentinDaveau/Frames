extends Node2D
class_name LogicBody

signal state_update(state)

export(NodePath) var _signal_source: NodePath

func _ready() -> void:
	if not _signal_source:
		return
	var _source_body = get_node(_signal_source)
	if not _source_body.has_method("_on_source_state_update") :
		printerr("Source body isn't a LogicBody!")
		return
	_source_body.connect("state_update", self, "_on_source_state_update")


func _on_source_state_update(new_state: bool) -> void:
	pass


