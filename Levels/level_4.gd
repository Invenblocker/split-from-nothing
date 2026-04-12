extends Node2D

signal level_finished

func _ready() -> void:
	var tiles = %LevelScene.get_tile_map()
	%LevelScene.add_element(7, 0, HexTile.elements.FIRE, true)
	%LevelScene.add_element(8, 3, HexTile.elements.FIRE, true)
	%LevelScene.add_element(4, 2, HexTile.elements.FIRE, true)
	%LevelScene.add_element(6, 7, HexTile.elements.FIRE, false)
	%LevelScene.add_element(0, 1, HexTile.elements.FIRE, false)
	%LevelScene.add_element(11, 4, HexTile.elements.FIRE, false)
	%LevelScene.add_element(10, 5, HexTile.elements.FIRE, false)
	%LevelScene.add_element(5, 6, HexTile.elements.FIRE, true)
	%LevelScene.add_element(9, 4, HexTile.elements.FIRE, true)
	%LevelScene.add_element(9, 6, HexTile.elements.FIRE, false)
	%LevelScene.add_element(1, 5, HexTile.elements.FIRE, false)
	%LevelScene.add_element(8, 0, HexTile.elements.FIRE, true)
	%LevelScene.add_element(6, 0, HexTile.elements.FIRE, true)
	%LevelScene.add_element(8, 7, HexTile.elements.FIRE, false)
	%LevelScene.add_element(3, 6, HexTile.elements.FIRE, true)
	%LevelScene.add_element(10, 6, HexTile.elements.FIRE, false)
	%LevelScene.save_starting_state.emit()

func _on_level_scene_post_step() -> void:
	var remaining_fire = false
	var tiles = %LevelScene.get_tile_map()
	for row in tiles:
		for tile in row:
			if tile != null:
				if (tile.element == HexTile.elements.FIRE):
					remaining_fire = true
					break
	
	if !remaining_fire:
		%ObjectiveLabel.visible = false
		%CompleteLabel.visible = true
		level_finished.emit()
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://level_select.tscn")


func _on_timer_timeout() -> void:
	%HintLabel.visible = true
