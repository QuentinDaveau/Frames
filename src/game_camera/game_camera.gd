extends Camera2D
class_name GameCamera


export(NodePath) var _start_target_node: NodePath
export(float, 0, 1) var _start_smoothing: float = 0.0
export(Vector2) var _start_drag_margin: Vector2 = Vector2.ZERO

var _targets_stack: Array
var _targets_properties: Dictionary = {}
var _offset_power: Vector2 = Vector2.ZERO
var _target_node: Node2D = null


func _ready() -> void:
	set_target(get_node(_start_target_node), Vector2.ZERO, 1.0, 0.2, _start_smoothing, _start_drag_margin)
	global_position = get_node(_start_target_node).global_position


func _physics_process(delta: float) -> void:
	var target_position := _target_node.global_position
	var aimed_position := global_position
	var position_differential := global_position - target_position
	var _drag_margin: Vector2 = _targets_properties[_target_node]["drag_margin"]

	if abs(position_differential.x) > _drag_margin.x:
		aimed_position.x = target_position.x + (_drag_margin.x * sign(position_differential.x))
	if abs(position_differential.y) > _drag_margin.y:
		aimed_position.y = target_position.y + (_drag_margin.y * sign(position_differential.y))

	
	global_position = lerp(global_position, aimed_position, delta / (delta +_targets_properties[_target_node]["smooth"]))
	zoom = lerp(zoom, Vector2.ONE * _targets_properties[_target_node]["zoom"], delta / (delta + _targets_properties[_target_node]["zoom_smooth"]))


func set_target(target_node: Node2D, position_offset: Vector2 = Vector2.ZERO, zoom: float = 1.0, zoom_smooth: float = 0.2, smooth: float = 0.2, drag_margin: Vector2 = Vector2.ZERO) -> void:
	if target_node == _target_node:
		return
	if target_node in _targets_stack:
		_targets_stack.erase(target_node)
		_targets_properties.erase(target_node)
	_targets_stack.append(target_node)
	_targets_properties[target_node] = {
		"zoom": zoom, 
		"zoom_smooth": zoom_smooth, 
		"drag_margin": drag_margin, 
		"smooth": smooth,
		"position_offset": position_offset
	}
	_target_node = target_node

	


func remove_target(target_node: Node2D) -> void:
	if not _targets_stack.has(target_node):
		return
	_targets_stack.erase(target_node)
	_targets_properties.erase(target_node)
	if _target_node == target_node:
		_target_node = _targets_stack.back()
