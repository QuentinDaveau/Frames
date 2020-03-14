extends Node2D
class_name RopeManager

signal rope_points_updated(rotation_point, distance_left)

enum CONTACT_SIDE {left = -1, right = 1}

var _joints: Array = []
var _joints_offset: Array = []
var _line_points: Array = []
var _joints_side: Array = []
var _joints_lengths: Array = []

var _total_length: float = 800.0
var _length_left: float

var _active_joint_position: Vector2
var _parent_joint_position: Vector2
var _active_parent_vect: Vector2

var _hanged_body: Node2D
var _hanged_body_position: Vector2
var _old_hanged_position: Vector2


func setup(spawn_position: Vector2, raycast_offset: Vector2, total_length: float, hanged_body: Node2D) -> void:
	_total_length = total_length
	_hanged_body = hanged_body
	_old_hanged_position = _hanged_body.global_position
	_active_joint_position = spawn_position
	_joints.append(_active_joint_position)
	_joints_offset.append(raycast_offset)
	global_position = spawn_position


func _ready() -> void:
	_update_params()


func _process(delta) -> void:
	_update_rope_line()


func _physics_process(delta) -> void:
	_hanged_body_position = _hanged_body.global_position
	if _check_joint_disconnection():
		_old_hanged_position = _hanged_body_position
		_update_rope_line()
		return
	
	_update_cast()
	
	if $Cast/RayCast2D.is_colliding():
		var collider = $Cast/RayCast2D.get_collider()
		var closest_point: Vector2
		
		if collider is TileMap:
			var collider_coords: Vector2 = collider.world_to_map($Cast/RayCast2D.get_collision_point() - ($Cast/RayCast2D.get_collision_normal() * 0.1))
			var colliding_cell = collider.get_cellv(collider_coords)
			var collider_global_coords: Vector2 = collider.map_to_world(collider_coords) + (collider.cell_size / 2.0)
			
			if colliding_cell == -1:
				return
			
			closest_point = _find_closest_point(collider_global_coords,  collider.tile_set.tile_get_shape(colliding_cell, 0).points, collider.cell_size / 2.0)
			if closest_point == Vector2.ZERO:
				return
			_add_active_joint(closest_point , _find_contact_side(), collider_global_coords)
		else:
			closest_point = _find_closest_point(collider.global_position, collider.get_node("CollisionPolygon2D").polygon)
			if closest_point == Vector2.ZERO:
				return
			_add_active_joint(closest_point , _find_contact_side(), collider.global_position)
	_old_hanged_position = _hanged_body_position
	_update_rope_line()


func destroy() -> void:
	queue_free()


func _add_active_joint(joint_position: Vector2, side_collision: int = 0, collider_position: Vector2 = Vector2.ZERO) -> void:
	_parent_joint_position = _active_joint_position
	_active_joint_position = joint_position
	_joints.append(joint_position)
	_joints_offset.append((joint_position - collider_position).normalized())
	_joints_side.append(side_collision)
	_joints_lengths.append(_active_joint_position.distance_to(_parent_joint_position))
	_update_params()


func _remove_active_joint() -> void:
	_joints.pop_back()
	_joints_offset.pop_back()
	_joints_side.pop_back()
	_joints_lengths.pop_back()
	_active_joint_position = _parent_joint_position
	_parent_joint_position = _joints[_joints.size() - 2]
	_update_params()


func _check_joint_disconnection() -> bool:
	if _joints.size() < 2:
		return false
	
	if sign(_active_parent_vect.angle_to(_hanged_body_position - _parent_joint_position)) == _joints_side.back():
		_remove_active_joint()
		return true
	return false


func _update_params() -> void:
	_length_left = _total_length
	for length in _joints_lengths:
		_length_left -= length
	if _length_left < 0:
		_length_left = 0.01
	
	_active_parent_vect = _active_joint_position - _parent_joint_position
	_rebatch_line_points()
	emit_signal("rope_points_updated", _active_joint_position, _length_left)


func _update_cast() -> void:
	$Cast.global_position = _hanged_body_position
	$Cast.rotation = _hanged_body_position.angle_to_point(_active_joint_position + _joints_offset.back()) + PI/2
	$Cast/RayCast2D.cast_to.y = _hanged_body_position.distance_to(_active_joint_position + _joints_offset.back()) - $Cast/RayCast2D.position.y
	$Cast/RayCast2D.force_raycast_update()


func _update_rope_line() -> void:
	var new_points = _line_points.duplicate()
	new_points.append(_hanged_body.global_position - global_position)
	$Line2D.points = new_points
	$Line2D.update()


func _rebatch_line_points() -> void:
	_line_points.clear()
	for joint_position in _joints:
		_line_points.append(joint_position - global_position)


func _find_contact_side() -> int:
	if (_hanged_body_position - _active_joint_position).angle_to(_old_hanged_position - _active_joint_position) > 0:
		return CONTACT_SIDE.right
	else:
		return CONTACT_SIDE.left


func _find_closest_point(collider_position: Vector2, polygons: PoolVector2Array, origin_offset: Vector2 = Vector2.ZERO) -> Vector2:
	var closest_point: Vector2 = Vector2.ZERO
	var cast_radius: float = 2 * abs(sin((_active_joint_position - _old_hanged_position).angle_to(_active_joint_position - _hanged_body_position) / 2.0) * $Cast/RayCast2D.get_collision_point().distance_to(_active_joint_position))
	
	for polygon in polygons:
		var polygon_pos: Vector2 = polygon - origin_offset
		if (collider_position + polygon_pos).distance_to($Cast/RayCast2D.get_collision_point()) > cast_radius:
			continue
#		if ((collider_position + polygon_pos) - _active_joint_position).length() < 1.0:
#			continue
		if closest_point == Vector2.ZERO:
			closest_point = collider_position + polygon_pos
			continue
		closest_point = _compare_points_to_rope(closest_point, collider_position + polygon_pos)
	return closest_point


func _compare_points_to_rope(point_a: Vector2, point_b: Vector2) -> Vector2:
	var dist_a = _get_dist_to_line(_active_joint_position, _old_hanged_position, point_a)
	var dist_b = _get_dist_to_line(_active_joint_position, _old_hanged_position, point_b)
	
	if dist_a < dist_b:
		return point_a
	else:
		return point_b


func _get_dist_to_line(line_start: Vector2, line_end: Vector2, point_position: Vector2) -> float:
	var start_to_point: Vector2 = Vector2(point_position.x - line_start.x, point_position.y - line_start.y)
	var start_to_end: Vector2 = Vector2(line_end.x - line_start.x, line_end.y - line_start.y)
	var ratio_on_line: float = start_to_point.dot(start_to_end) / start_to_end.length_squared()
	var closest_point_position: Vector2 = Vector2(line_start.x + (start_to_end.x * ratio_on_line), line_start.y + (start_to_end.y * ratio_on_line))
	return point_position.distance_to(closest_point_position)
