class_name ElementButton

extends Area2D

@export var element: HexTile.elements = HexTile.elements.FIRE
@export var count:int = 1
var selected:bool = false

const BUTTON_TEXTURE = preload("res://Graphics/ElementButton.png")
const SELECTED_TEXTURE = preload("res://Graphics/ElementSelected.png")
const EMPTY_TEXTURE = preload("res://Graphics/ElementUnavailable.png")

const VOID_TEXTURE = preload("res://Graphics/Void.png")
const FIRE_TEXTURE = preload("res://Graphics/Fire.png")
const WATER_TEXTURE = preload("res://Graphics/Water.png")
const EARTH_TEXTURE = preload("res://Graphics/Earth.png")
const AIR_TEXTURE = preload("res://Graphics/Air.png")
const GOLD_TEXTURE = preload("res://Graphics/Gold.png")
const SILVER_TEXTURE = preload("res://Graphics/Silver.png")
const MERCURY_TEXTURE = preload("res://Graphics/Mercury.png")
const LIGHTNING_TEXTURE = preload("res://Graphics/Lightning.png")

const MATTER_TEXTURES = [VOID_TEXTURE, FIRE_TEXTURE, WATER_TEXTURE, EARTH_TEXTURE, AIR_TEXTURE, GOLD_TEXTURE, SILVER_TEXTURE, MERCURY_TEXTURE, LIGHTNING_TEXTURE]

func _physics_process(delta: float) -> void:
	%ElementCount.text = "X " + str(count)
	if count > 0:
		if selected:
			%Button.texture = SELECTED_TEXTURE
		else:
			%Button.texture = BUTTON_TEXTURE
	else:
		%Button.texture = EMPTY_TEXTURE
	
	%ElementDisplay.texture = MATTER_TEXTURES[element]



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var parent
		parent = get_parent()
		while parent != null:
			if parent.has_method("element_button_pressed"):
				parent.element_button_pressed(self)
				break
			parent = parent.get_parent()
