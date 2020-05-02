extends Actor


func _on_trigger_activated(trigger_identifier: String) -> void:
	if trigger_identifier == "frame_falling":
		$StateMachine.force_stunned_state()
