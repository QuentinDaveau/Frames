extends KinematicBody2D
class_name Entity


export(float) var mass: float = 1.0


# Temporary override of the get_class function which normally would return the base KinematicBody2D class
#func get_class() -> String:
#	return "Entity"


func manually_raise_trigger(trigger_identifier: String, activated: bool = true) -> void:
	if activated:
		_on_trigger_activated(trigger_identifier)
	else:
		_on_trigger_deactivated(trigger_identifier)


func _on_trigger_activated(trigger_identifier: String) -> void:
	pass


func _on_trigger_deactivated(trigger_identifier: String) -> void:
	pass
