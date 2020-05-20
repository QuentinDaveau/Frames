extends "bull_state.gd"


export(float) var _ACCELERATION: float = 15
export(float) var _MAX_SPEED: float = 1000.0

var _charge_timer: float = 0.0


func update(delta) -> void:
	var _current_velocity: Vector2 = owner.get_velocity()
	_current_velocity.x = lerp(_current_velocity.x, _MAX_SPEED * owner.get_look_direction(), _ACCELERATION * delta)
	owner.set_velocity(_current_velocity)
	.update(delta)
	var collision: KinematicCollision2D = owner.move_and_collide(_current_velocity * delta, true, true, true)
	if collision:
		if collision.normal.x != 0:
			emit_signal("finished", "hitting")


func _on_character_lost(character_position: Vector2) -> void:
	._on_character_lost(character_position)
	if sign(character_position.x - owner.global_position.x) * owner.get_look_direction() <= 0:
		emit_signal("finished", "braking")
