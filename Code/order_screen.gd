extends Node2D

#Joint References
@onready var left_joint: PinJoint2D = $ZombieBuild/leftArm/leftJoint
@onready var right_joint: PinJoint2D = $ZombieBuild/rightArm/rightJoint
@onready var left_foot_joint: PinJoint2D = $ZombieBuild/leftFoot/leftFootJoint
@onready var right_foot_joint: PinJoint2D = $ZombieBuild/rightFoot/rightFootJoint
@onready var head_joint: PinJoint2D = $ZombieBuild/head/headJoint

#Order Paper Sprite References
@onready var leftArm: Sprite2D = $CurrentOrder/OrderLeftArm
@onready var rightArm: Sprite2D = $CurrentOrder/OrderRightArm
@onready var leftFoot: Sprite2D = $CurrentOrder/OrderLeftLeg
@onready var rightFoot: Sprite2D = $CurrentOrder/OrderRightLeg
@onready var head: Sprite2D = $CurrentOrder/OrderHead

@onready var left_arm_connector: Area2D = $ZombieBuild/leftArm/leftArmConnector
@onready var right_arm_connector: Area2D = $ZombieBuild/rightArm/rightArmConnector
@onready var left_foot_connector: Area2D = $ZombieBuild/leftFoot/leftFootConnector
@onready var right_foot_connector: Area2D = $ZombieBuild/rightFoot/rightFootConnector
@onready var head_connector: Area2D = $ZombieBuild/head/headConnector

@onready var left_arm_connector_sprite: Sprite2D = $ZombieBuild/leftArm/leftArmConnectorSprite
@onready var right_arm_connector_sprite: Sprite2D = $ZombieBuild/rightArm/rightArmConnectorSprite
@onready var left_foot_connector_sprite: Sprite2D = $ZombieBuild/leftFoot/leftFootConnectorSprite
@onready var right_foot_connector_sprite: Sprite2D = $ZombieBuild/rightFoot/rightFootConnectorSprite
@onready var head_connector_sprite: Sprite2D = $ZombieBuild/head/headConnectorSprite

@onready var rep_timer: Timer = $CurrentOrder/repTimer

@onready var ui: Control = $"../UI"


var limbs = ["head", "leftArm", "rightArm", "leftFoot", "rightFoot"]
var limbEffects = [false, false, false, false, false]

var overlappingLA = false
var overlappingRA = false
var overlappingLL = false
var overlappingRL = false
var overlappingH = false

var repMultiplier = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.runOrderVisuals.connect(_run_order_visuals)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_left_arm_connector_body_entered(body: Node2D) -> void:
	if body.limb_location == 1:
		if body.isInLimbConnector == null:
			body.isInLimbConnector = "leftArm"
		
		while Input.is_action_pressed("Hold"):
			await get_tree().process_frame

		if left_arm_connector.overlaps_body(body) && body.isInLimbConnector == "leftArm":
			if body is RigidBody2D:
				if Global.currentBuildStatus["leftArm"]["occupied"] == false:
					if body.limbType == "arm":
						Global.currentBuildStatus["leftArm"]["occupied"] = true
						body.move_to_position(left_joint.position, body.limbID, left_joint, "arm", body.effect)
						body.gravity_scale = 1
						setCurrentLimb("leftArm", body.effect, body.limbID)
						left_arm_connector_sprite.visible = false


func _on_right_arm_connector_body_entered(body: Node2D) -> void:
	if body.limb_location == 1:
		if body.isInLimbConnector == null:
			body.isInLimbConnector = "rightArm"
		
		while Input.is_action_pressed("Hold"):
			await get_tree().process_frame
		
		if right_arm_connector.overlaps_body(body) && body.isInLimbConnector == "rightArm":
			if body is RigidBody2D:
				if Global.currentBuildStatus["rightArm"]["occupied"] == false:
					if body.limbType == "arm":
						Global.currentBuildStatus["rightArm"]["occupied"] = true
						body.move_to_position(right_joint.position, body.limbID, right_joint, "arm", body.effect)
						body.gravity_scale = 1
						setCurrentLimb("rightArm", body.effect, body.limbID)
						right_arm_connector_sprite.visible = false


func _on_left_foot_connector_body_entered(body: Node2D) -> void:
	if body.limb_location == 1:
		if body.isInLimbConnector == null:
			body.isInLimbConnector = "leftFoot"
			
		while Input.is_action_pressed("Hold"):
			await get_tree().process_frame
		
		if left_foot_connector.overlaps_body(body) && body.isInLimbConnector == "leftFoot":
			if body is RigidBody2D:
				if Global.currentBuildStatus["leftFoot"]["occupied"] == false:
					if body.limbType == "leg":
						Global.currentBuildStatus["leftFoot"]["occupied"] = true
						body.move_to_position(left_foot_joint.position, body.limbID, left_foot_joint, "leg", body.effect)
						body.gravity_scale = 1
						setCurrentLimb("leftFoot", body.effect, body.limbID)
						left_foot_connector_sprite.visible = false


func _on_right_foot_connector_body_entered(body: Node2D) -> void:
	if body.limb_location == 1:
		if body.isInLimbConnector == null:
			body.isInLimbConnector = "rightFoot"
		
		while Input.is_action_pressed("Hold"):
			await get_tree().process_frame
		
		if right_foot_connector.overlaps_body(body) && body.isInLimbConnector == "rightFoot":
			if body is RigidBody2D:
				if Global.currentBuildStatus["rightFoot"]["occupied"] == false:
					if body.limbType == "leg":
						Global.currentBuildStatus["rightFoot"]["occupied"] = true
						body.move_to_position(right_foot_joint.position, body.limbID, right_foot_joint, "leg", body.effect)
						body.gravity_scale = 1
						setCurrentLimb("rightFoot", body.effect, body.limbID)
						right_foot_connector_sprite.visible = false


func _on_head_connector_body_entered(body: Node2D) -> void:
	if body.limb_location == 1:
		if body.isInLimbConnector == null:
			body.isInLimbConnector = "head"
		
		while Input.is_action_pressed("Hold"):
			await get_tree().process_frame
		
		if head_connector.overlaps_body(body) && body.isInLimbConnector == "head":
			if body is RigidBody2D:
				if Global.currentBuildStatus["head"]["occupied"] == false:
					if body.limbType == "head":
						Global.currentBuildStatus["head"]["occupied"] = true
						body.move_to_position(head_joint.position, body.limbID, head_joint, "head", body.effect)
						body.gravity_scale = 1
						setCurrentLimb("head", body.effect, body.limbID)
						head_connector_sprite.visible = false


func setCurrentLimb(limbType: String, limbEffect: String, limbID: int):
	Global.currentBuildStatus[str(limbType)]["effect"] = limbEffect 
	Global.currentBuildStatus[str(limbType)]["ID"] = limbID 


var tempVar = "nothin"
func _run_order_visuals():
	
	if Global.currentOrder["head"] != "null":
		head.visible = true
		head.texture.region = Global.limbPNGPositions["head_" + str(Global.currentOrder["head"])]
	else:
		head.visible = false
		
	if Global.currentOrder["leftArm"] != "null":
		leftArm.visible = true
		leftArm.texture.region = Global.limbPNGPositions["arm_" + str(Global.currentOrder["leftArm"])]
	else:
		leftArm.visible = false
		
	if Global.currentOrder["rightArm"] != "null":
		rightArm.visible = true
		rightArm.texture.region = Global.limbPNGPositions["arm_" + str(Global.currentOrder["rightArm"])]
	else:
		rightArm.visible = false
	
	if Global.currentOrder["leftFoot"] != "null":
		leftFoot.visible = true
		leftFoot.texture.region = Global.limbPNGPositions["leg_" + str(Global.currentOrder["leftFoot"])]
	else: 
		leftFoot.visible = false
	
	if Global.currentOrder["rightFoot"] != "null":
		rightFoot.visible = true
		rightFoot.texture.region = Global.limbPNGPositions["leg_" + str(Global.currentOrder["rightFoot"])]
	else:
		rightFoot.visible = false


func _on_left_arm_connector_body_exited(body: Node2D) -> void:
	if body.isInLimbConnector == "leftArm":
		body.isInLimbConnector = null


func _on_right_arm_connector_body_exited(body: Node2D) -> void:
	if body.isInLimbConnector == "rightArm":
		body.isInLimbConnector = null


func _on_left_foot_connector_body_exited(body: Node2D) -> void:
	if body.isInLimbConnector == "leftFoot":
		body.isInLimbConnector = null
	

func _on_right_foot_connector_body_exited(body: Node2D) -> void:
	if body.isInLimbConnector == "rightFoot":
		body.isInLimbConnector = null


func _on_head_connector_body_exited(body: Node2D) -> void:
	if body.isInLimbConnector == "head":
		body.isInLimbConnector = null


func _on_rep_timer_timeout() -> void:
	if repMultiplier == 50:
		await get_tree().create_timer(4).timeout
	
	repMultiplier -= 1
	rep_timer.wait_time = 1
	ui.change_counters("repMultiplier")
	rep_timer.start()
