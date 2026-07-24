extends Control


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/Menus/Main_Menu.tscn")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
