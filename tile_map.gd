extends Node2D

signal calculate_next_state
signal execute_step

const HEX_TILE = preload("res://hex_tile.tscn")

var map_width: int = 10
var map_height: int = 8
var start_indented: bool = true
var indented_rows_shorter: bool = true

var start_x:int = 16
var start_y:int = 16

var tile_width:int = 40
var tile_height:int = 35

var tile_map
var selected_tile

func _ready() -> void:
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
	if Input.is_action_just_pressed("Advance"):
		step()

func step():
	calculate_next_state.emit()
	execute_step.emit()
