extends Node2D

export(Vector2) var _impulse_vector: Vector2 = Vector2(0, -1000.0)


func _ready() -> void:
	$ActorDetector.connect("actor_entered", self, "_bump_actor")


func _bump_actor(actor: Actor) -> void:
	actor.apply_impulse(_impulse_vector)
