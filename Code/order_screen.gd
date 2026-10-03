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


var limbs = ["head", "leftArm", "rightArm", "leftFoot", "rightFoot"]
var limbEffects = [false, false, false, false, false]

var overlappingLA = false
var overlappingRA = false
var overlappingLL = false
var overlappingRL = false
var overlappingH = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.runOrderVisuals.connect(_run_order_visuals)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_left_arm_connector_body_entered(body: Node2D) -> void:
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


func _on_right_arm_connector_body_entered(body: Node2D) -> void:
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


func _on_left_foot_connector_body_entered(body: Node2D) -> void:
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


func _on_right_foot_connector_body_entered(body: Node2D) -> void:
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


func _on_head_connector_body_entered(body: Node2D) -> void:
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


func setCurrentLimb(limbType: String, limbEffect: String, limbID: int):
	Global.currentBuildStatus[str(limbType)]["effect"] = limbEffect 
	Global.currentBuildStatus[str(limbType)]["ID"] = limbID 

var tempVar = "nothin"
func _run_order_visuals():
	for i in 5:
		if Global.currentOrder[limbs[i - 1]] == "null":
			limbEffects[i - 1] = false
		elif Global.currentOrder[limbs[i - 1]] == "none":
			limbEffects[i - 1] = true
	
	leftArm.visible = limbEffects[1]
	rightArm.visible = limbEffects[2]
	leftFoot.visible = limbEffects[3]
	rightFoot.visible = limbEffects[4]
	head.visible = limbEffects[0]


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
