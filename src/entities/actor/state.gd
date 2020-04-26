extends Node
class_name State

signal finished(next_state_name)

# Initialize the state. E.g. change the animation
func initialize(input_direction: Vector2, velocity: Vector2) -> void:
	return

# Enters the state
func enter() -> void:
	return

# Clean up the state. Reinitialize values like a timer
func exit() -> void:
	return

func handle_input(event) -> void:
	return

func update(delta) -> void:
	return

func _on_animation_finished(anim_name) -> void:
	return
