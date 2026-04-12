extends Node2D

func _ready() -> void:
	var tiles = %LevelScene.get_tile_map()
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
