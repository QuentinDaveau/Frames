extends ObjectEntity


const UP: Vector2 = Vector2.UP

export(bool) var rotation_locked: bool = true
onready var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
# func _physics_process(delta: float) -> void:
# 	global_rotation += 0.01
# 	global_position += Vector2(2, -2)
#	if Input.is_action_just_pressed("ui_down"):
#		_linear_velocity += Vector2(100.0, -1000.0)
#
#
#
#	if !is_on_floor():
#		_linear_velocity.y += _gravity * delta
#	._physics_process(delta)
#
#
#	_linear_velocity = move_and_slide(_linear_velocity, UP)	_linear_velocity = move_and_slide_linear_velocity, UP)
#
#
#func apply_impulse(impulse_force: Vector2, impulse_position: Vector2 = Vector2.ZERO) -> void:
#	if rotation_locked:
#		_linear_velocity += impulse_force
#		return
