class_name TilesMap

extends Node2D

signal calculate_next_state
signal execute_step
signal post_step

const HEX_TILE = preload("res://hex_tile.tscn")

var level:LevelScene = null
var map_width: int = 10
var map_height: int = 8
var start_indented: bool = true
var indented_rows_shorter: bool = true

var start_x:int = 120
var start_y:int = 40

var tile_width:int = 40
var tile_height:int = 35

var tile_map
var selected_tile: HexTile
var selected_element:HexTile.elements = HexTile.elements.VOID

var level_finished = false

func _ready() -> void:
	var parent = get_parent()
	if (parent!= null) and (parent is LevelScene):
		level = parent
		map_width = level.map_width
		map_height = level.map_height
		start_indented = level.start_indented
		indented_rows_shorter = level.indented_rows_shorter
		start_x = level.left
		start_y = level.top
	
	tile_map = []
	for a:int in range(map_width):
		var tile_column = []
		for b:int in range(map_height):
			var indented: bool = (b % 2 == 0) == start_indented
			if (a < map_width - 1) or not (indented_rows_shorter and indented):
				#Generate Tile
				var x: int = tile_width * a + start_x
				var y: int = tile_height * b + start_y
				if indented:
					x += tile_width / 2
				var tile = HEX_TILE.instantiate()
				tile.global_position = Vector2(x, y)
				tile.x = a
				tile.y = b
				tile_column.append(tile)
				
				#Add references between tiles.
				if b > 0:
					var previous = tile_column[b-1]
					if previous != null:
						if indented:
							previous.down_right_tile = tile
							tile.up_left_tile = previous
						else:
							previous.down_left_tile = tile
							tile.up_right_tile = previous
							
							previous = previous.left_tile
							if previous != null:
								previous.down_right_tile = tile
								tile.up_left_tile = previous
					elif (a > 0):
						previous = tile_map[a-1][b-1]
						previous.down_right_tile = tile
						tile.up_left_tile = previous
				
				if a > 0:
					var left = tile_map[a-1][b]
					left.right_tile = tile
					tile.left_tile = left
					
					if not indented:
						var down_left = left.down_right_tile
						if down_left != null:
							down_left.up_right_tile = tile
							tile.down_left_tile = down_left
			else:
				tile_column.append(null)
		tile_map.append(tile_column)
	#Add all created tiles to the scene (do this last so they all have proper context for ready)
	for a in tile_map:
		for b in a:
			if b!= null:
				add_child(b)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Cancel"):
		if selected_tile != null:
			selected_tile.selected = false
			selected_tile = null
	if Input.is_action_just_pressed("Advance"):
		step()

func step() -> void:
	if level_finished:
		return
	
	if selected_tile != null:
		selected_tile.selected = false
		selected_tile = null
	calculate_next_state.emit()
	execute_step.emit()
	post_step.emit()
	
func tile_click(tile: HexTile) -> void:
	if selected_element != HexTile.elements.VOID:
		if (selected_tile == null):
			if tile.element == HexTile.elements.VOID:
				selected_tile = tile
				tile.selected = true
		else:
			var opposite:HexTile = null
			var adjacent: bool = false
			for i:int in range(6):
				if tile.adjacent_tiles[i] == selected_tile:
					opposite = tile.adjacent_tiles[i].adjacent_tiles[i]
					adjacent = true
					break
			if not adjacent:
				selected_tile.selected = false
				selected_tile = null
			elif (opposite != null) and (tile.element == HexTile.elements.VOID) and (opposite.element == HexTile.elements.VOID):
				selected_tile.selected = false
				selected_tile = null
				tile.antimatter = false
				tile.element = selected_element
				opposite.antimatter = true
				opposite.element = selected_element
				if get_parent().has_method("used_element"):
					get_parent().used_element(selected_element)
