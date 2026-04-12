extends Node2D

func _ready() -> void:
	var tiles = %LevelScene.get_tile_map()
	%LevelScene.add_element(1, 2, HexTile.elements.GOLD, false)
	%LevelScene.add_element(1, 1, HexTile.elements.GOLD, false)
	%LevelScene.add_element(2, 1, HexTile.elements.GOLD, false)
	%LevelScene.add_element(3, 0, HexTile.elements.GOLD, false)
	%LevelScene.add_element(4, 0, HexTile.elements.GOLD, false)
	%LevelScene.add_element(5, 0, HexTile.elements.GOLD, false)
	%LevelScene.add_element(5, 1, HexTile.elements.GOLD, false)
	%LevelScene.add_element(0, 3, HexTile.elements.GOLD, false)
	%LevelScene.add_element(6, 2, HexTile.elements.GOLD, false)
	%LevelScene.add_element(1, 4, HexTile.elements.GOLD, false)
	%LevelScene.add_element(5, 3, HexTile.elements.GOLD, false)
	%LevelScene.add_element(1, 5, HexTile.elements.GOLD, false)
	%LevelScene.add_element(2, 5, HexTile.elements.GOLD, false)
	%LevelScene.add_element(3, 5, HexTile.elements.GOLD, false)
	%LevelScene.add_element(5, 4, HexTile.elements.GOLD, false)
	%LevelScene.add_element(4, 2, HexTile.elements.AIR, true)
	%LevelScene.add_element(5, 2, HexTile.elements.AIR, true)
	%LevelScene.add_element(4, 3, HexTile.elements.AIR, true)
	%LevelScene.add_element(4, 1, HexTile.elements.AIR, true)
	%LevelScene.add_element(3, 1, HexTile.elements.AIR, true)
	%LevelScene.add_element(2, 3, HexTile.elements.AIR, false)
	%LevelScene.add_element(1, 3, HexTile.elements.AIR, false)
	%LevelScene.add_element(2, 2, HexTile.elements.AIR, false)
	%LevelScene.add_element(2, 4, HexTile.elements.AIR, false)
	%LevelScene.add_element(3, 4, HexTile.elements.AIR, false)
	%LevelScene.save_starting_state.emit()

func _on_level_scene_post_step() -> void:
	var air_count:int = 0
	var anti_air_count:int = 0
	var tiles = %LevelScene.get_tile_map()
	for row in tiles:
		for tile in row:
			if tile != null:
				if (tile.element == HexTile.elements.AIR):
					if tile.antimatter:
						anti_air_count += 1
					else:
						air_count += 1
	
	if (air_count >= 5) and (anti_air_count <= 0):
		%ObjectiveLabel.visible = false
		%CompleteLabel.visible = true
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://level_select.tscn")


func _on_timer_timeout() -> void:
	%HintLabel.visible = true
