extends KinematicBody2D
class_name Entity


export(float) var mass: float = 1.0


# Temporary override of the get_class function which normally would return the base KinematicBody2D class
func get_class() -> String:
    return "Entity"


func _on_trigger_activated(trigger_identifier: String) -> void:
    print("e", "   ", trigger_identifier, "   ", get_name())
    pass


func _on_trigger_deactivated(trigger_identifier: String) -> void:
    print("l")
    pass