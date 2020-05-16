extends Entity
class_name Actor

enum LOOK_DIRECTION{left= -1, right= 1}
enum COLLISION_STATE{none, ground, slide}
const WALL_ANGLE: float = PI/4

export(String) var _class_name: String = "Actor"
export(bool) var _lock_rotation: bool = true

var _current_look_direction: int = LOOK_DIRECTION.right
var _velocity: Vector2 = Vector2.ZERO
var _current_collision: int = COLLISION_STATE.none


# Temporary override of the get_class function which normally would return the base KinematicBody2D class
func get_class() -> String:
	return _class_name


func _physics_process(delta: float) -> void:
	if not _lock_rotation:
		return
	global_rotation = 0.0


func apply_impulse(impulse_vector: Vector2) -> void:
	pass


func set_look_direction(look_direction: int) -> void:
	if look_direction == _current_look_direction:
		return
	if abs(look_direction) != 1:
		return
	_current_look_direction = look_direction
	$SpritePivot.scale.x = _current_look_direction


func get_look_direction() -> int:
	return _current_look_direction


func move(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(_velocity * delta)
	if collision and collision.remainder:
		_slide(collision, delta)
	_manage_collision_state()


func is_on_ground() -> bool:
	return _current_collision == COLLISION_STATE.ground or _current_collision == COLLISION_STATE.slide


func get_velocity() -> Vector2:
	return _velocity


func set_velocity(velocity: Vector2) -> void:
	_velocity = velocity


func add_velocity(amount: Vector2) -> Vector2:
	_velocity += amount
	return _velocity


func _manage_collision_state() -> void:
	var collision = move_and_collide(Vector2.DOWN * 10, true, true, true)
	if not collision:
		_current_collision = COLLISION_STATE.none
		return
	elif -collision.normal.angle() > WALL_ANGLE and -collision.normal.angle() < PI - WALL_ANGLE:
		_current_collision = COLLISION_STATE.ground
	else:
		_current_collision = COLLISION_STATE.ground


func _slide(collision: KinematicCollision2D, delta: float, count: int = 0) -> void:
	var second_collision: KinematicCollision2D = move_and_collide(collision.remainder.slide(collision.normal))
	if (second_collision and second_collision.remainder) and count <= 4:
		_slide(second_collision, delta, count + 1)
	else:
		_velocity = _velocity.slide(collision.normal)
