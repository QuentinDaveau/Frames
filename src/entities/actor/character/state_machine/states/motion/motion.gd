extends State
class_name Motion

onready var DEAD_ZONE: float = 0.2
var _input_direction: Vector2 = Vector2.ZERO


func initialize(properties: Dictionary = {}) -> void:
	_input_direction = properties["input_direction"]


func handle_input(event) -> void:
	if (event.is_echo()):
		return
	if event is InputEventJoypadMotion:
		_update_input_direction(event)
	elif event is InputEventKey:
		_update_key_direction(event)


func get_input_direction() -> Vector2:
	return _input_direction


func set_input_direction(input_direction: Vector2) -> void:
	_input_direction = input_direction


func update_look_direction(direction: int) -> void:
	owner.set_look_direction(direction)


func _update_input_direction(event: InputEventJoypadMotion) -> void:
	if abs(event.axis_value) < DEAD_ZONE:
		event.axis_value = 0.0
	if event.axis == 0:
		_input_direction.x = event.axis_value
	elif event.axis == 1:
		_input_direction.y = event.axis_value


func _update_key_direction(event: InputEventKey) -> void:
	_input_direction.x = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))






#func init_input_direction(controller_id: int) -> void:
##	_input_direction.x = Input.get_joy_axis(controller_id, 0)
##	_input_direction.y = Input.get_joy_axis(controller_id, 1)
##	if abs(_input_direction.x) < DEAD_ZONE:
##		_input_direction.x = 0.0
##	if abs(_input_direction.y) < DEAD_ZONE:
##		_input_direction.y = 0.0
#	_input_direction.x = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
