extends Node2D

signal state_update(state)

export(Array, NodePath) var _signal_sources: Array

var _state: bool = false
var _sources_list: Dictionary = {}


func _ready() -> void:
	for source_path in _signal_sources:
		if not source_path:
			return
		var _source = get_node(source_path)
		if not _source.has_method("_on_source_state_update") :
			printerr("Source body isn't a LogicBody!")
			continue
		_source.connect("state_update", self, "_on_source_state_update", [_source])
		_sources_list[_source] = false


func _on_source_state_update(new_state: bool, source) -> void:
	if _sources_list[source] == new_state:
		printerr("Duplicate logic signal with same state!")
		return
	_sources_list[source] = new_state
	_check_sources_status()


func _check_sources_status() -> void:
	var all_sources_on: bool = true
	for value in _sources_list.values():
		if not value:
			all_sources_on = false
			break
	if _state and not all_sources_on:
		_state = false
	if not _state and all_sources_on:
		_state = true
	emit_signal("state_update", _state)

