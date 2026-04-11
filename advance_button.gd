extends Area2D

var auto_advance: bool = false

signal advance_button

const ADVANCE_TEXTURE = preload("res://Graphics/Advance.png")
const AUTO_TEXTURE = preload("res://Graphics/AutoAdvance.png")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if not auto_advance:
			advance_button.emit()
