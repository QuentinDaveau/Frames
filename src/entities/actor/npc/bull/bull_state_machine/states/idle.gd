extends "bull_state.gd"


const TURN_DELAY: float = 3.0

var _turn_timer: float = 0.0


func enter() -> void:
	if _see_character:
		emit_signal("finished", "preparing")
	_turn_timer = TURN_DELAY
	.enter()


func update(delta) -> void:
	_turn_timer -= delta
	if _turn_timer <= 0.0:
		_turn_timer = TURN_DELAY
		owner.set_look_direction(-owner.get_look_direction())
	.update(delta)


func _on_character_spotted() -> void:
	._on_character_spotted()
	emit_signal("finished", "preparing")
