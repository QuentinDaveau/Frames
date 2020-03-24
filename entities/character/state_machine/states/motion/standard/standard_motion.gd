extends "../motion.gd"


const UP: Vector2 = Vector2.UP

onready var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _velocity: Vector2 = Vector2.ZERO
var _move_speed: float = 0.0
var _move_acceleration: float = 0.0
var _gravity_multiplier: float = 1.0


func initialize(input_direction: Vector2, velocity: Vector2) -> void:
	_velocity = velocity
	.initialize(input_direction, velocity)


func enter() -> void:
	_velocity.y += _gravity * _gravity_multiplier * get_physics_process_delta_time()
	_velocity.x = lerp(_velocity.x, _move_speed * get_input_direction().x, _move_acceleration)
	_apply_movement(get_physics_process_delta_time())


func update(delta) -> void:
	_velocity.y += _gravity * _gravity_multiplier * delta
	_velocity.x = lerp(_velocity.x, _move_speed * get_input_direction().x, _move_acceleration)
	_apply_movement(delta)


func get_velocity() -> Vector2:
	return _velocity


func set_velocity_limitations(move_speed: float, move_acceleration: float) -> void:
	_move_speed = move_speed
	_move_acceleration = move_acceleration


func set_gravity_multiplier(gravity_multiplier: float) -> void:
	_gravity_multiplier = gravity_multiplier


func _apply_movement(delta: float) -> void:
	_velocity = owner.move_and_slide(_velocity, UP)
