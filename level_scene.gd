class_name LevelScene

extends Node2D

signal save_starting_state
signal load_starting_state
signal post_step

@export var map_width: int = 10
@export var map_height: int = 8
@export var start_indented: bool = true
@export var indented_rows_shorter: bool = true
@export var left:int = 120
@export var top:int = 40

@export var resources:Dictionary[HexTile.elements,int] = {
	HexTile.elements.FIRE: 0,
	HexTile.elements.WATER: 0,
	HexTile.elements.EARTH: 0,
	HexTile.elements.AIR: 0,
	HexTile.elements.GOLD: 0,
	HexTile.elements.SILVER: 0,
	HexTile.elements.MERCURY: 0,
	HexTile.elements.LIGHTNING: 0
}

var starting_state_saved:bool = false

var buttons:Dictionary[HexTile.elements,ElementButton]

var selected_element = HexTile.elements.VOID

func _ready() -> void:
	buttons = {
		HexTile.elements.FIRE:%FireButton,
		HexTile.elements.WATER: %WaterButton,
		HexTile.elements.EARTH:%EarthButton,
		HexTile.elements.AIR: %AirButton,
		HexTile.elements.GOLD: %GoldButton,
		HexTile.elements.SILVER: %SilverButton,
		HexTile.elements.MERCURY: %MercuryButton,
		HexTile.elements.LIGHTNING: %LightningButton
	}
	
	for n:HexTile.elements in resources.keys():
		buttons[n].count = resources[n]
		if (selected_element == HexTile.elements.VOID) and (resources[n] > 0):
			selected_element = n
			buttons[n].selected = true
			%TileMap.selected_element = selected_element

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("CycleLeft"):
		cycle_element(-1)
	if Input.is_action_just_pressed("CycleRight"):
		cycle_element(1)
	if Input.is_action_just_pressed("Restart") and starting_state_saved:
		load_starting_state.emit()

func cycle_element(dir:int):
	var valid_elements:Array[HexTile.elements] = []
	var starting_index:int = -1
	var target_element:HexTile.elements = selected_element
	for n:HexTile.elements in buttons.keys():
		if n == selected_element:
			starting_index = valid_elements.size()
		if buttons[n].count > 0:
			valid_elements.append(n)
	if valid_elements.size() > 0:
		if dir < 0:
			target_element = valid_elements[starting_index - 1]
		elif dir > 0:
			target_element = valid_elements[(starting_index + 1) % valid_elements.size()]
		else:
			target_element = valid_elements[starting_index % valid_elements.size()]
	else:
		target_element = HexTile.elements.VOID
	
	if buttons.has(selected_element):
		buttons[selected_element].selected = false
	if buttons.has(target_element):
		buttons[target_element].selected = true
	selected_element = target_element
	$TileMap.selected_element = selected_element

func element_button_pressed(button:ElementButton):
	if button.count > 0:
		buttons[selected_element].selected = false
		button.selected = true
		selected_element = button.element
		$TileMap.selected_element = selected_element

func used_element(element:HexTile.elements):
	buttons[element].count -= 1
	cycle_element(0)


func _on_save_starting_state() -> void:
	starting_state_saved = true

func _on_load_starting_state() -> void:
	for element in buttons.keys():
		buttons[element].count = resources[element]


func _on_restart_button_restart_button() -> void:
	if starting_state_saved:
		load_starting_state.emit()

func _on_advance_button_advance_button() -> void:
	%TileMap.calculate_next_state.emit()
	%TileMap.execute_step.emit()
	%TileMap.post_step.emit()


func _on_tile_map_post_step() -> void:
	post_step.emit()

func get_tile_map():
	return %TileMap.tile_map
