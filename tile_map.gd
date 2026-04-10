extends Node2D

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

func _ready() -> void:
	tile_map = []
	for a:int in range(map_width):
		var tile_row = []
		for b:int in range(map_height):
			var indented: bool = (b % 2 == 0) == start_indented
			if (a < map_width - 1) or not (indented_rows_shorter and indented):
				var x: int = tile_width * a + start_x
				var y: int = tile_height * b + start_y
				if indented:
					x += tile_width / 2
				var tile = HEX_TILE.instantiate()
				add_child(tile)
				tile.global_position = Vector2(x, y)
				tile_row.append(tile)
				tile.x = a
				tile.y = b
			else:
				tile_row.append(null)
		tile_map.append(tile_row)
