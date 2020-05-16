extends State


var _see_character: bool = false
var _velocity: Vector2 = Vector2.ZERO


func enter() -> void:
	owner.get_node("SpritePivot/FieldOfView").connect("character_entered", self, "_on_character_spotted")
	owner.get_node("SpritePivot/FieldOfView").connect("character_exited", self, "_on_character_lost")


func exit() -> void:
	owner.get_node("SpritePivot/FieldOfView").disconnect("character_entered", self, "_on_character_spotted")
	owner.get_node("SpritePivot/FieldOfView").disconnect("character_exited", self, "_on_character_lost")


func initialize(properties: Dictionary = {}) -> void:
	_see_character = properties["see_character"]
	_velocity = properties["velocity"]


func get_properties() -> Dictionary:
	return {"velocity": _velocity, "see_character": _see_character}


func hit(hit: KinematicCollision2D) -> void:
	if not hit.collider is Entity:
		return
	if hit.normal.x > 0:
		hit.collider.manually_raise_trigger("bull_hit_left")
	else:
		hit.collider.manually_raise_trigger("bull_hit_right")


func _on_character_spotted() -> void:
	_see_character = true
	pass


func _on_character_lost(character_position: Vector2) -> void:
	_see_character = false
	pass
