extends RigidBody2D

const LIMB = preload("res://Scenes/limb.tscn")

var hovering = false
var equipped = false
var distance_vector = Vector2(0, 0)


var displacement = 0
var spring_force = 0
var damping_force = 0

var initial_Xposition = 0
var moveToOrderScreen = false

var is_moving = false
var target_position = Vector2(0,0)

var respawn = false
var attached = false
var tempVar = "nothin"

var isInLimbConnector = null

#0 Work Bench
#1 Order Screen
@export var limb_location: int = 0
@export var limbID = 0
@export var limbType = "arm"
@export var effect = "none"

@onready var ui: Control = $"../../UI"
@onready var order_screen: Node2D = $"../../OrderScreen"
@onready var life_bar: ColorRect = $lifeBar
@onready var life: Timer = $life
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var left_joint: PinJoint2D = $"../../OrderScreen/ZombieBuild/leftArm/leftJoint"
@onready var right_joint: PinJoint2D = $"../../OrderScreen/ZombieBuild/rightArm/rightJoint"
@onready var left_foot_joint: PinJoint2D = $"../../OrderScreen/ZombieBuild/leftFoot/leftFootJoint"
@onready var right_foot_joint: PinJoint2D = $"../../OrderScreen/ZombieBuild/rightFoot/rightFootJoint"
@onready var head_joint: PinJoint2D = $"../../OrderScreen/ZombieBuild/head/headJoint"


func _ready() -> void:
	ui.deleteAttachedLimbs.connect(_on_delete_limbs)
	ui.notePosition.connect(_on_note_position)
	if respawn == false:
		apply_central_impulse(Vector2.RIGHT * 5000)
		limbID = Global.limbID
		limbType = Global.currentLimbSpawn
		setUpTexture()
		Global.limbID += 1
	elif respawn == true:
		attached = true
		
	if limbType == "head":
		sprite_2d.rotation = 0
	else:
		sprite_2d.rotation = -45
	



func _process(_delta: float) -> void:
	life_bar.position.x = sprite_2d.position.x - life_bar.size.x/2
	@warning_ignore("integer_division")
	life_bar.size.x = snapped(79/20 * life.time_left, 0.01)
	@warning_ignore("integer_division")
	life_bar.color.g = snapped((255/20 * life.time_left)*0.004, 0.01)
	
	if Input.is_action_just_pressed("Delete") && hovering == true:
		if attached == true:
			tempVar = Global.currentBuildStatus.keys().filter(
				func(key): return Global.currentBuildStatus[key]["ID"] == limbID
			)
			
			Global.currentBuildStatus[tempVar[0]]["ID"] = null
			Global.currentBuildStatus[tempVar[0]]["effect"] = "null"
			Global.currentBuildStatus[tempVar[0]]["occupied"] = false
		
		queue_free()



func _physics_process(delta: float) -> void:
	if hovering == true:
		if Input.is_action_just_pressed("Hold"):
			distance_vector = get_global_mouse_position() - position
			equipped = true
			sprite_2d.scale = Vector2(0.454, 0.454)

	if Input.is_action_pressed("Hold") && equipped == true:
		displacement = get_global_mouse_position() - position
		spring_force = displacement*1000 #what the hell is happening
		damping_force = -linear_velocity*50
		apply_central_force(spring_force + damping_force)
	
	if Input.is_action_just_released("Hold"):
		equipped = false
		sprite_2d.scale = Vector2(0.394, 0.394)
		
		
	if ui.button_slide == true && limb_location == 0 && order_screen.visible == true && respawn == false:
		freeze = true
		position.x = move_toward(position.x, initial_Xposition - 1162, 50)
	elif ui.button_slide == true && limb_location == 0 && order_screen.visible == false && respawn == false:
		position.x = move_toward(position.x, initial_Xposition + 1162, 50)
		if position.x >= initial_Xposition + 1162:
			freeze = false
			
	if is_moving == true:
		global_position = global_position.move_toward(target_position, 500* delta)
		if position == target_position:
			is_moving = false
			freeze = false
 

func move_to_position(pos: Vector2, ID, joint, limbtype, limbEffect): 
	var limb_copy = LIMB.instantiate()
	
	
	limb_copy.position = pos - Vector2(0, 30)
	limb_copy.respawn = true
	limb_copy.limbID = ID
	if limbtype != "head":
		limb_copy.gravity_scale = 2
	
	call_deferred("add_sibling", limb_copy)
	await get_tree().process_frame
	joint.node_a = limb_copy.get_path()
	limb_copy.z_index = -5
	limb_copy.limbType = limbtype
	limb_copy.set_collision_mask_value(1, false)
	limb_copy.set_collision_layer_value(1, false)
	limb_copy.set_collision_mask_value(2, true)
	limb_copy.set_collision_layer_value(2, true)
	limb_copy.limb_location = 1
	limb_copy.effect = limbEffect
	
	limb_copy.setUpTexture()
	call_deferred("queue_free")

func _on_mouse_entered() -> void:
	hovering = true


func _on_mouse_exited() -> void:
	hovering = false
	
func _on_note_position():
	initial_Xposition = position.x

var temptempvar = "nothin"
func _on_life_timeout() -> void:
	if attached == true:
		temptempvar = Global.currentBuildStatus.keys().filter(
			func(key): return Global.currentBuildStatus[key]["ID"] == limbID
		)
		Global.currentBuildStatus[temptempvar[0]]["effect"] = "null"
		Global.currentBuildStatus[temptempvar[0]]["ID"] = null
		Global.currentBuildStatus[temptempvar[0]]["occupied"] = false
	
	queue_free()
	
func _on_delete_limbs():
	if attached == true:
		call_deferred("queue_free")


func changeEffect(newEffect):
	effect = newEffect
	setUpTexture()

func setUpTexture():
	if limbType != "null":
		print(Global.limbPNGPositions[str(limbType) + "_" + str(effect)])
		print(effect)
		sprite_2d.texture.region = Global.limbPNGPositions[str(limbType) + "_" + str(effect)]
