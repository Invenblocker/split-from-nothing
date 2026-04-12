class_name HexTile

extends Area2D
enum elements {VOID, FIRE, WATER, EARTH, AIR, GOLD, SILVER, MERCURY, LIGHTNING}

var x: int
var y: int

var selected: bool = false
var hovered: bool = false

const TILE_TEXTURE = preload("res://Graphics/HexTile.png")
const HOVER_TEXTURE = preload("res://Graphics/HexHover.png")
const SELECTED_TEXTURE = preload("res://Graphics/HexSelected.png")
const ADJACENT_TEXTURE = preload("res://Graphics/HexAdjacent.png")
const ADJACENT_HOVER_TEXTURE = preload("res://Graphics/AdjacentHover.png")

const VOID_TEXTURE = preload("res://Graphics/Void.png")
const FIRE_TEXTURE = preload("res://Graphics/Fire.png")
const ANTI_FIRE_TEXTURE = preload("res://Graphics/AntiFire.png")
const WATER_TEXTURE = preload("res://Graphics/Water.png")
const ANTI_WATER_TEXTURE = preload("res://Graphics/AntiWater.png")
const EARTH_TEXTURE = preload("res://Graphics/Earth.png")
const ANTI_EARTH_TEXTURE = preload("res://Graphics/AntiEarth.png")
const AIR_TEXTURE = preload("res://Graphics/Air.png")
const ANTI_AIR_TEXTURE = preload("res://Graphics/AntiAir.png")
const GOLD_TEXTURE = preload("res://Graphics/Gold.png")
const ANTI_GOLD_TEXTURE = preload("res://Graphics/AntiGold.png")
const SILVER_TEXTURE = preload("res://Graphics/Silver.png")
const ANTI_SILVER_TEXTURE = preload("res://Graphics/AntiSilver.png")
const MERCURY_TEXTURE = preload("res://Graphics/Mercury.png")
const ANTI_MERCURY_TEXTURE = preload("res://Graphics/AntiMercury.png")
const LIGHTNING_TEXTURE = preload("res://Graphics/Lightning.png")
const ANTI_LIGHTNING_TEXTURE = preload("res://Graphics/AntiLightning.png")

const MATTER_TEXTURES = [VOID_TEXTURE, FIRE_TEXTURE, WATER_TEXTURE, EARTH_TEXTURE, AIR_TEXTURE, GOLD_TEXTURE, SILVER_TEXTURE, MERCURY_TEXTURE, LIGHTNING_TEXTURE]
const ANTIMATTER_TEXTURES = [VOID_TEXTURE, ANTI_FIRE_TEXTURE, ANTI_WATER_TEXTURE, ANTI_EARTH_TEXTURE, ANTI_AIR_TEXTURE, ANTI_GOLD_TEXTURE, ANTI_SILVER_TEXTURE, ANTI_MERCURY_TEXTURE, ANTI_LIGHTNING_TEXTURE]

var up_left_tile:HexTile = null
var up_right_tile:HexTile = null
var left_tile:HexTile = null
var right_tile:HexTile = null
var down_left_tile:HexTile = null
var down_right_tile:HexTile = null

var adjacent_tiles:Array[HexTile]

var element:elements = elements.VOID
var antimatter:bool = false

var next_element:elements = elements.VOID
var next_antimatter:bool = false

var starting_element:elements = elements.VOID
var starting_antimatter:bool = false

func _ready() -> void:
	adjacent_tiles = [right_tile, up_right_tile, up_left_tile, left_tile, down_left_tile, down_right_tile]
	get_parent().calculate_next_state.connect(_calculate_next_state)
	get_parent().execute_step.connect(_execute_step)
	get_parent().get_parent().save_starting_state.connect(_save_starting_state)
	get_parent().get_parent().load_starting_state.connect(_load_starting_state)

func _physics_process(delta: float) -> void:
	%ElementGraphic.modulate = Color(1, 1, 1, 1)
	if antimatter:
		%ElementGraphic.texture = ANTIMATTER_TEXTURES[element]
	else:
		%ElementGraphic.texture = MATTER_TEXTURES[element]
	var adjacent:bool = false
	var opposite:HexTile = null
	var neighbor_index:int = 0
	for neighbor:HexTile in adjacent_tiles:
		if neighbor == null:
			neighbor_index += 1
			continue
		if neighbor.selected:
			adjacent = true
			opposite = neighbor.adjacent_tiles[neighbor_index]
			break
		neighbor_index += 1
	if selected:
		%TileGraphic.texture = SELECTED_TEXTURE
	elif hovered:
		if adjacent:
			%TileGraphic.texture = ADJACENT_HOVER_TEXTURE
			if (opposite != null) and (opposite.element == elements.VOID):
				%ElementGraphic.texture = MATTER_TEXTURES[get_parent().selected_element]
				%ElementGraphic.modulate = Color(1,1,1,0.5)
		else:
			%TileGraphic.texture = HOVER_TEXTURE
	elif adjacent:
		%TileGraphic.texture = ADJACENT_TEXTURE
		if (opposite != null) and (opposite.hovered) and (opposite.element == elements.VOID):
			%ElementGraphic.texture = ANTIMATTER_TEXTURES[get_parent().selected_element]
			%ElementGraphic.modulate = Color(1,1,1,0.5)
	else:
		%TileGraphic.texture = TILE_TEXTURE

func _calculate_next_state() -> void:
	#print("Calculated step at: {", x, "}, {", y, "}")
	next_element = element
	next_antimatter = antimatter
	if element != elements.VOID: #Empty through matter/anti-matter, silver or mercury, all of which take priority
		for neighbor:HexTile in adjacent_tiles:
			if neighbor == null:
				continue
			if (neighbor.element == element) and (neighbor.antimatter != antimatter):
				next_element = elements.VOID
				return
			elif element != elements.GOLD:
				if ((neighbor.element == elements.SILVER) and (neighbor.antimatter != antimatter)) or ((neighbor.element == elements.MERCURY) and (neighbor.antimatter == antimatter)):
					next_element = elements.VOID
					return
	
	if element == elements.FIRE:
		for neighbor:HexTile in adjacent_tiles:
			if neighbor == null: continue
			if (neighbor.element == elements.WATER) and (neighbor.antimatter == antimatter):
				next_element = elements.VOID
			elif (neighbor.element == elements.AIR) and (next_element == elements.FIRE) and (neighbor.antimatter != antimatter):
				next_element = elements.AIR
				next_antimatter = neighbor.antimatter
	elif element == elements.WATER:
		var anti_earth_neighbors:int = 0
		for neighbor:HexTile in adjacent_tiles:
			if neighbor == null: continue
			if (neighbor.element == elements.FIRE) and (neighbor.antimatter != antimatter):
				next_element = elements.VOID
			elif (neighbor.element == elements.EARTH) and (neighbor.antimatter != antimatter):
				anti_earth_neighbors += 1
		if (next_element == elements.WATER) and (anti_earth_neighbors >= 2):
			next_element = elements.EARTH
			next_antimatter = !antimatter
	elif element == elements.EARTH:
		var water_neighbors: int = 0
		for neighbor:HexTile in adjacent_tiles:
			if neighbor == null: continue
			if (neighbor.element == elements.WATER) and (neighbor.antimatter == antimatter):
				water_neighbors += 1
		if water_neighbors >= 2:
			next_element = elements.WATER
	elif element == elements.AIR:
		var fire_neighbors:int = 0
		var lightning_neighbors:int = 0
		for neighbor:HexTile in adjacent_tiles:
			if neighbor == null: continue
			if (neighbor.element == elements.FIRE) and (neighbor.antimatter == antimatter):
				fire_neighbors += 1
			elif (neighbor.element == elements.LIGHTNING) and (neighbor.antimatter != antimatter):
				lightning_neighbors += 1
		if (fire_neighbors > 0) and (fire_neighbors >= lightning_neighbors):
			next_element = elements.FIRE
		elif lightning_neighbors > 0:
			next_element = elements.LIGHTNING
			next_antimatter = !antimatter
	elif element == elements.LIGHTNING:
		var earth_neighbors:int = 0
		var lightning_neigbors: int = 0
		var air_neighbors: int = 0
		for neighbor:HexTile in adjacent_tiles:
			if neighbor == null: continue
			if (neighbor.element == elements.LIGHTNING) and (neighbor.antimatter == antimatter):
				lightning_neigbors += 1
			elif (neighbor.element == elements.AIR) and (neighbor.antimatter == antimatter):
				air_neighbors += 1
			elif (neighbor.element == elements.EARTH):
				earth_neighbors += 1
		if earth_neighbors >= air_neighbors:
			next_element = elements.VOID
		elif air_neighbors > lightning_neigbors:
			next_element = elements.AIR
	
	elif element == elements.VOID:
		var earth_neighbors:int = 0
		var anti_earth_neighbors:int = 0
		var air_neighbors:int = 0
		var anti_air_neighbors: int = 0
		for neighbor:HexTile in adjacent_tiles:
			if neighbor == null:
				continue
			if neighbor.element == elements.AIR:
				if neighbor.antimatter:
					anti_air_neighbors += 1
				else:
					air_neighbors += 1
			elif neighbor.element == elements.EARTH:
				if neighbor.antimatter:
					anti_earth_neighbors += 1
				else:
					earth_neighbors += 1
		
		if (earth_neighbors >= 3) and (anti_earth_neighbors == 0):
			next_element = elements.EARTH
			next_antimatter = false
		elif (anti_earth_neighbors >= 3) and (earth_neighbors == 0):
			next_element = elements.EARTH
			next_antimatter = true
		elif (air_neighbors >= 1) and (anti_air_neighbors == 0):
			next_element = elements.AIR
			next_antimatter = false
		elif (anti_air_neighbors >= 1) and (air_neighbors == 0):
			next_element = elements.AIR
			next_antimatter = true
		elif air_neighbors != anti_air_neighbors:
			next_element = elements.LIGHTNING
			next_antimatter = air_neighbors < anti_air_neighbors

func _execute_step() -> void:
	#print("Executed step at: {", x, "}, {", y, "}")
	element = next_element
	antimatter = next_antimatter

func _save_starting_state():
	starting_element = element
	starting_antimatter = antimatter

func _load_starting_state():
	element = starting_element
	antimatter = starting_antimatter

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		#print("Clicked tile: {", x, "}, {", y, "}")
		#if element== elements.VOID:
			#antimatter = false
			#element = 1
		#elif antimatter:
			#element += 1
			#antimatter = false
			#if element >= elements.size():
				#element = 0
		#else:
			#antimatter = true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		get_parent().tile_click(self)
