extends LogicBody


var _switched_on: bool = false


func _on_source_state_update(new_state: bool) -> void:
	if _switched_on == new_state:
		return
	if new_state:
		_switched_on = true
	else:
		_switched_on = false
	$Sprite.material.set_shader_param("lit", _switched_on)
