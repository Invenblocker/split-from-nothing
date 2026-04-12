extends Node2D


func _on_sandbox_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Levels/sandbox.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		%CreditsCanvas.visible = false


func _on_credits_button_button_down() -> void:
	%CreditsCanvas.visible = true


func _on_levels_button_button_down() -> void:
	get_tree().change_scene_to_file("res://level_select.tscn")


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
