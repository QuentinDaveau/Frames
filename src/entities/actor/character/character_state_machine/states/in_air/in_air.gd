extends "../character_state.gd"

#export(NodePath) var GROUNDED_CHECK_PATH

#onready var GROUNDED_CHECK = get_node(GROUNDED_CHECK_PATH)


func enter() -> void:
	.enter()


func handle_input(event) -> void:
	.handle_input(event)


func update(delta) -> void:
	.update(delta)
	if owner.is_on_ground():
		emit_signal("finished", "previous")
		return
