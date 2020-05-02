extends "bull_state.gd"


const TURN_DELAY: float = 2.0

var _charge_timer: float = 0.0


func enter() -> void:
	_charge_timer = TURN_DELAY
	.enter()


func update(delta) -> void:
	_charge_timer -= delta
	if _charge_timer <= 0.0:
		emit_signal("finished", "charging")
	.update(delta)


func _on_character_lost(character_position: Vector2) -> void:
	._on_character_lost(character_position)
	owner.set_look_direction(sign(character_position.x - owner.global_position.x))
