extends "../motion.gd"


const UP: Vector2 = Vector2.UP
const DOWN: Vector2 = Vector2.DOWN

onready var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _velocity: Vector2 = Vector2.ZERO
var _move_speed: float = 0.0
var _move_acceleration: float = 0.0
var _gravity_multiplier: float = 1.0
var _snap: bool = true


func initialize(properties: Dictionary = {}) -> void:
	_velocity = properties["velocity"]
	.initialize(properties)


func enter() -> void:
	_apply_movement(get_physics_process_delta_time())


func update(delta: float) -> void:
	_apply_movement(delta)


func set_snap(use_snap: bool) -> void:
	_snap = use_snap


func get_velocity() -> Vector2:
	return _velocity


func get_walking_direction() -> int:
	if _velocity.x > 0.0:
		return 1
	else:
		return -1


func set_velocity_limitations(move_speed: float, move_acceleration: float) -> void:
	_move_speed = move_speed
	_move_acceleration = move_acceleration


func set_gravity_multiplier(gravity_multiplier: float) -> void:
	_gravity_multiplier = gravity_multiplier
	


func _apply_movement(delta: float) -> void:
	_velocity.x = lerp(_velocity.x, _move_speed * get_input_direction().x, _move_acceleration * delta)
	if not owner.is_on_floor():
		_velocity.y += _gravity * _gravity_multiplier * delta
	if _snap:
		_velocity = owner.move_and_slide_with_snap(_velocity, DOWN, UP)
	else:
		_velocity = owner.move_and_slide_with_snap(_velocity, DOWN * 10, UP)
	# owner.move_and_collide(-(owner.get_floor_velocity() * delta).rotated())
