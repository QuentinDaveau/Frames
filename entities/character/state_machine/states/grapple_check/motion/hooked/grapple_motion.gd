extends "../motion.gd"


const UP: Vector2 = Vector2.UP

onready var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var _grapple_manager = owner.get_node("GrappleManager")

var _velocity: Vector2 = Vector2.ZERO
var _move_speed: float = 0.0
var _move_acceleration: float = 0.0
var _gravity_multiplier: float = 1.0


func initialize(input_direction: Vector2, velocity: Vector2) -> void:
	_velocity = velocity
	.initialize(input_direction, velocity)


func enter() -> void:
	_apply_movement()


func update(delta) -> void:
#	_velocity.y += _gravity * _gravity_multiplier * delta
	
#	if _has_grapple_length(_velocity):
#		emit_signal("finished", "previous")
#		return
	
	_apply_movement()


func get_velocity() -> Vector2:
	return _velocity


func set_velocity(velocity: Vector2) -> void:
	_velocity = velocity


func set_velocity_limitations(move_speed: float, move_acceleration: float) -> void:
	_move_speed = move_speed
	_move_acceleration = move_acceleration


func set_rotation_point(point: Vector2) -> void:
	_rotation_point = point


func _apply_movement() -> void:
	_velocity = owner.move_and_slide(_velocity, UP)
