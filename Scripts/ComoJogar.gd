extends Node2D



func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()

	

func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()



func _on_TextureButton_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func _on_TextureButton2_pressed():
	get_tree().quit()
