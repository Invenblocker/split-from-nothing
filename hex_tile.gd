extends Area2D

var x: int
var y: int

var selected: bool = false
var hovered: bool = false

func _physics_process(delta: float) -> void:
	if selected:
		%TileGraphic.visible = false
		%HoverGraphic.visible = false
		%PickedGraphic.visible = true
	elif hovered:
		%TileGraphic.visible = false
		%HoverGraphic.visible = true
		%PickedGraphic.visible = false
	else:
		%TileGraphic.visible = true
		%HoverGraphic.visible = false
		%PickedGraphic.visible = false

func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("Clicked tile: {", x, "}, {", y, "}")
		selected = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Cancel"):
		print("Cancel")
		selected = false
