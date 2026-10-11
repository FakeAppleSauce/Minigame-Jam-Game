extends Control

@onready var tutorial: CheckBox = $tutorial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")
	if tutorial.is_pressed() == true:
		Global.tutorialOn = true
		print(Global.tutorialOn)
		
	else:
		Global.tutorialOn = false
		print(Global.tutorialOn)
