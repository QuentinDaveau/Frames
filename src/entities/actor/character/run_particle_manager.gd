extends Node2D


export(String, FILE, "*.tscn") var _run_particle_path

onready var _run_particle = load(_run_particle_path)


func spawn_particle() -> void:
	var p: Particles2D = _run_particle.instance()
	p.scale.x = get_parent().scale.x
	owner.get_parent().add_child(p)
	p.global_position = global_position
	p.emitting = true
