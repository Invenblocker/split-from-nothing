extends Node2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_back_button_button_down() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func level_button(index:int) -> void:
	get_tree().change_scene_to_file("res://Levels/level_" + str(index) +".tscn")
