extends Node2D

signal level_finished

func _ready() -> void:
	var tiles = %LevelScene.get_tile_map()
	%LevelScene.add_element(0, 6, HexTile.elements.WATER)
	%LevelScene.add_element(1, 6, HexTile.elements.WATER)
	%LevelScene.add_element(2, 6, HexTile.elements.WATER)
	%LevelScene.add_element(3, 6, HexTile.elements.WATER)
	%LevelScene.add_element(4, 6, HexTile.elements.WATER)
	%LevelScene.add_element(5, 6, HexTile.elements.WATER)
	%LevelScene.add_element(6, 6, HexTile.elements.WATER)
	%LevelScene.save_starting_state.emit()

func _on_level_scene_post_step() -> void:
	var water_count:int = 0
	var tiles = %LevelScene.get_tile_map()
	for row in tiles:
		for tile in row:
			if tile != null:
				if (tile.element == HexTile.elements.WATER) and (tile.antimatter == false):
					water_count += 1
	
	if water_count <= 0:
		%ObjectiveLabel.visible = false
		%CompleteLabel.visible = true
		level_finished.emit()
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://level_select.tscn")


func _on_timer_timeout() -> void:
	%HintLabel.visible = true
