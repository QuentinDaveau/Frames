extends Camera2D
class_name GameCamera


const SHAKE_THRESHOLD: float = 0.5

export(NodePath) var _start_target_node: NodePath
export(float, 0, 1) var _start_smoothing: float = 0.0
export(Vector2) var _start_drag_margin: Vector2 = Vector2.ZERO

var _targets_stack: Array
var _targets_properties: Dictionary = {}
var _target_node: Node2D = null
var _target_locked: bool = false
var _shake_speed: float = 0.01
var _shake_noise: float = 0.1
var _shake_damp: float = 0.5
var _shake_angular_noise: float = 1
var _shake_amount: Vector2 = Vector2.ZERO
var _shake_angle: float


func _ready() -> void:
	$Shaker.connect("tween_all_completed", self, "_shake_move_completed")
	set_target(get_node(_start_target_node), false, Vector2.ZERO, 1.0, 0.2, _start_smoothing, _start_drag_margin)
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


func set_target(target_node: Node2D, lock = false, position_offset: Vector2 = Vector2.ZERO, zoom: float = 1.0, zoom_smooth: float = 0.2, smooth: float = 0.2, drag_margin: Vector2 = Vector2.ZERO) -> void:
	if target_node == _target_node:
		return
	if target_node in _targets_stack:
		_targets_stack.erase(target_node)
		_targets_properties.erase(target_node)
	_targets_properties[target_node] = {
		"zoom": zoom, 
		"zoom_smooth": zoom_smooth, 
		"drag_margin": drag_margin, 
		"smooth": smooth,
		"position_offset": position_offset
	}
	if not _target_locked:
		_targets_stack.append(target_node)
		_target_node = target_node
		_target_locked = lock
	else:
		_targets_stack.insert(_targets_stack.size() - 1, target_node)

	
func remove_target(target_node: Node2D) -> void:
	if not _targets_stack.has(target_node):
		return
	_targets_stack.erase(target_node)
	_targets_properties.erase(target_node)
	if _target_node == target_node:
		if _target_locked:
			_target_locked = false
		_target_node = _targets_stack.back()


func get_current_target() -> Node2D:
	return _target_node


func update_target_properties(properties: Dictionary) -> void:
	for property in properties.keys():
		if not _targets_properties[_target_node].has(property):
			printerr("Uknown camera property: ", property)
			continue
		_targets_properties[_target_node][property] = properties[property]


func add_shake(amount: Vector2, angle: float = 0.0) -> void:
	if sign(_shake_amount.x):
		_shake_amount.x += amount.x * sign(_shake_amount.x)
	else:
		_shake_amount.x += amount.x
	if sign(_shake_amount.y):
		_shake_amount.y += amount.y * sign(_shake_amount.y)
	else:
		_shake_amount.y += amount.y
	if sign(_shake_angle):
		_shake_angle += angle * sign(_shake_angle)
	else:
		_shake_angle = angle
	_shake()


func set_shake(speed: float = -1.0, damp: float = -1.0, noise: float = -1.0, angular_noise: float = -1.0) -> void:
	if speed != -1.0:
		_shake_speed = speed
	if damp != -1.0:
		_shake_damp = damp
	if noise != -1.0:
		_shake_noise = noise
	if angular_noise != -1.0:
		_shake_angular_noise = angular_noise


func _shake_move_completed() -> void:
	if not _shake_amount:
		return
	randomize()
	_shake_amount = (-_shake_amount * (1 - _shake_damp)).rotated(rand_range(-PI/2 * _shake_noise, PI/2 * _shake_noise))
	_shake_angle = (-_shake_angle * (1 - _shake_damp)) + rand_range(- _shake_angular_noise * _shake_angle * 0.5, _shake_angular_noise * _shake_angle * 0.5)
	if _shake_amount.length() < SHAKE_THRESHOLD:
		_shake_amount = Vector2.ZERO
		_shake_angle = 0.0
	_shake()


func _shake() -> void:
	$Shaker.interpolate_property(self, "offset", offset, _shake_amount, _shake_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Shaker.interpolate_property(self, "rotation", rotation, _shake_angle, _shake_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Shaker.start()
