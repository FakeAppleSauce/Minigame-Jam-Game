extends Node2D

const LIMB = preload("res://limb.tscn")

@onready var limbs: Node2D = $"../Limbs"
@onready var chute: ColorRect = $Chute

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_head_freezer_pressed() -> void:
	var limb_copy = LIMB.instantiate()
	limb_copy.position = get_global_mouse_position()
	limbs.add_child(limb_copy)


func _on_arm_freezer_pressed() -> void:
	var limb_copy = LIMB.instantiate()
	limb_copy.position = get_global_mouse_position()
	limbs.add_child(limb_copy)


func _on_leg_freezer_pressed() -> void:
	var limb_copy = LIMB.instantiate()
	limb_copy.position = get_global_mouse_position()
	limbs.add_child(limb_copy)
	



func _on_grow_needle_pressed() -> void:
	pass # Replace with function body.


func _on_wart_needle_pressed() -> void:
	pass # Replace with function body.


func _on_rainbow_needle_pressed() -> void:
	pass # Replace with function body.


func _on_swap_needle_pressed() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "Limbs":
		if body.limb_location == 0:
			body.limb_location = 1
			body.z_index = -5
			body.equipped = false
			body.set_collision_mask_value(1, false)
			body.set_collision_layer_value(1, false)
			body.linear_velocity.x = -12000
			await get_tree().create_timer(0.5).timeout
			body.set_collision_mask_value(2, true)
			body.set_collision_layer_value(2, true)

			body.moveToOrderScreen = true
