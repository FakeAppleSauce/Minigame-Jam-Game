extends Node2D

const LIMB = preload("res://Scenes/limb.tscn")
const NEEDLE = preload("res://Scenes/needle.tscn")

@onready var limbs: Node2D = $"../Limbs"
@onready var chute: ColorRect = $Chute

@onready var needles: Node2D = $Needles

@onready var grow_needle: TextureButton = $Shelf/growNeedle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_head_freezer_pressed() -> void:
	Global.currentLimbSpawn = "head"
	var limb_copy = LIMB.instantiate()
	limb_copy.position = get_global_mouse_position()
	limbs.add_child(limb_copy)


func _on_arm_freezer_pressed() -> void:
	Global.currentLimbSpawn = "arm"
	var limb_copy = LIMB.instantiate()
	limb_copy.position = get_global_mouse_position()
	limbs.add_child(limb_copy)


func _on_leg_freezer_pressed() -> void:
	Global.currentLimbSpawn = "leg"
	var limb_copy = LIMB.instantiate()
	limb_copy.position = get_global_mouse_position()
	limbs.add_child(limb_copy)
	




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



func _on_grow_needle_button_down() -> void:
	var needle_copy = NEEDLE.instantiate()
	needle_copy.position = get_global_mouse_position()
	needles.add_child(needle_copy)
	needle_copy.needleEffect = "grow"
	Global.needleEquipped = true


func _on_duplicate_needle_button_down() -> void:
	var needle_copy = NEEDLE.instantiate()
	needle_copy.position = get_global_mouse_position()
	needles.add_child(needle_copy)
	needle_copy.needleEffect = "duplicate"
	Global.needleEquipped = true


#metal
func _on_something_needle_button_down() -> void:
	var needle_copy = NEEDLE.instantiate()
	needle_copy.position = get_global_mouse_position()
	needles.add_child(needle_copy)
	needle_copy.needleEffect = "metal"
	Global.needleEquipped = true

#animal
func _on_something_else_needle_button_down() -> void:
	var needle_copy = NEEDLE.instantiate()
	needle_copy.position = get_global_mouse_position()
	needles.add_child(needle_copy)
	needle_copy.needleEffect = "animal"
	Global.needleEquipped = true
