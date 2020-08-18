extends Tween

signal bars_updated(opening)


export(NodePath) var _bars_path: NodePath

onready var _bars = get_node(_bars_path)


func open_bars(size_multiplier: float = 1) -> void:
	interpolate_property(_bars, "rect_min_size:x", _bars.rect_min_size.x \
			, 2800 * size_multiplier \
			, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	interpolate_property(_bars, "rect_min_size:y", _bars.rect_min_size.y \
			, 1600 * size_multiplier \
			, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT, 0.05)
	start()
	yield(self, "tween_all_completed")
	emit_signal("bars_updated", true)


func close_bars() -> void:
	interpolate_property(_bars, "rect_min_size:x", _bars.rect_min_size.x \
			, 600, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT, 0.05)
	interpolate_property(_bars, "rect_min_size:y", _bars.rect_min_size.y \
			, 256, 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	start()
	yield(self, "tween_all_completed")
	emit_signal("bars_updated", false)
