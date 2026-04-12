extends Node2D

signal level_finished

func _ready() -> void:
	var tiles = %LevelScene.get_tile_map()
	%LevelScene.add_element(7, 1, HexTile.elements.EARTH, false)
	%LevelScene.add_element(0, 5, HexTile.elements.EARTH, false)
	%LevelScene.add_element(5, 3, HexTile.elements.EARTH, false)
	%LevelScene.add_element(5, 5, HexTile.elements.EARTH, false)
	%LevelScene.add_element(1, 4, HexTile.elements.EARTH, false)
	%LevelScene.add_element(4, 7, HexTile.elements.EARTH, true)
	%LevelScene.add_element(3, 8, HexTile.elements.EARTH, true)
	%LevelScene.add_element(5, 0, HexTile.elements.EARTH, true)
	%LevelScene.add_element(3, 4, HexTile.elements.EARTH, true)
	%LevelScene.add_element(4, 0, HexTile.elements.EARTH, true)
	%LevelScene.save_starting_state.emit()

func _on_level_scene_post_step() -> void:
	var all_tiles_empty = true
	var tiles = %LevelScene.get_tile_map()
	for row in tiles:
		for tile in row:
			if tile != null:
				if (tile.element != HexTile.elements.VOID):
					all_tiles_empty = false
					break
	
	if all_tiles_empty:
		%ObjectiveLabel.visible = false
		%CompleteLabel.visible = true
		level_finished.emit()
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://level_select.tscn")
