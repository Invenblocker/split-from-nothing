extends Node2D

func _ready() -> void:
	%LevelScene.save_starting_state.emit()


func _on_timer_timeout() -> void:
	%HintLabel.visible = true


func _on_level_scene_post_step() -> void:
	var fire_count:int = 0
	var anti_fire_count = 0
	var tiles = %LevelScene.get_tile_map()
	for row in tiles:
		for tile in row:
			if tile != null:
				if tile.element == HexTile.elements.FIRE:
					if tile.antimatter:
						anti_fire_count += 1
					else:
						fire_count += 1
	
	if (fire_count >= 2) and (anti_fire_count <= 0):
		%ObjectiveLabel.visible = false
		%CompleteLabel.visible = true
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://level_select.tscn")
