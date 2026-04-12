extends Node2D


func _ready() -> void:
	%LevelScene.save_starting_state.emit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
	if Input.is_action_just_pressed("AddMatter"):
		%LevelScene.sandbox_add(false)
	if Input.is_action_just_pressed("AddAntiMatter"):
		%LevelScene.sandbox_add(true)
