extends KinematicBody2D
class_name ObjectEntity

#export(float, 0.0, 100.0) var linear_damp: float = 1.0
#export(float, 0.0, 100.0) var angular_damp: float = 1.0
#
#var _linear_velocity: Vector2 = Vector2.ZERO
#var _angular_velocity: float = 0.0
#
#
#func _physics_process(delta: float) -> void:
#	_apply_damp()
#
#
#func _apply_damp() -> void:
#	_apply_linear_damp()
#	_apply_angular_damp()
#
#
#func _apply_linear_damp() -> void:
#	if not _linear_velocity:
#		return
#	if _linear_velocity.length() < linear_damp: _linear_velocity = Vector2.ZERO
#	else: _linear_velocity -= (Vector2.RIGHT * linear_damp).rotated(_linear_velocity.angle())
#
#
#func _apply_angular_damp() -> void:
#	if not _angular_velocity:
#		return
#	if abs(_angular_velocity) < angular_damp: _angular_velocity = 0.0
#	else: _angular_velocity -= angular_damp
#
