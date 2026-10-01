extends Node2D

@onready var left_joint: PinJoint2D = $ZombieBuild/leftArm/leftJoint
@onready var right_joint: PinJoint2D = $ZombieBuild/rightArm/rightJoint
@onready var left_foot_joint: PinJoint2D = $ZombieBuild/leftFoot/leftFootJoint
@onready var right_foot_joint: PinJoint2D = $ZombieBuild/rightFoot/rightFootJoint
@onready var head_joint: PinJoint2D = $ZombieBuild/head/headJoint


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_left_arm_connector_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if Global.currentBuildStatus["leftArm"]["occupied"] == false:
			if body.limbType == "arm":
				Global.currentBuildStatus["leftArm"]["occupied"] = true
				body.move_to_position(left_joint.position, body.limbID, left_joint, "leftArm")
				body.gravity_scale = 1
				setCurrentLimb("leftArm", body.effect, body.limbID)


func _on_right_arm_connector_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if Global.currentBuildStatus["rightArm"]["occupied"] == false:
			if body.limbType == "arm":
				Global.currentBuildStatus["rightArm"]["occupied"] = true
				body.move_to_position(right_joint.position, body.limbID, right_joint, "rightArm")
				body.gravity_scale = 1
				setCurrentLimb("rightArm", body.effect, body.limbID)


func _on_left_foot_connector_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if Global.currentBuildStatus["leftFoot"]["occupied"] == false:
			if body.limbType == "leg":
				Global.currentBuildStatus["leftFoot"]["occupied"] = true
				body.move_to_position(left_foot_joint.position, body.limbID, left_foot_joint, "leftFoot")
				body.gravity_scale = 1
				setCurrentLimb("leftFoot", body.effect, body.limbID)


func _on_right_foot_connector_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if Global.currentBuildStatus["rightFoot"]["occupied"] == false:
			if body.limbType == "leg":
				Global.currentBuildStatus["rightFoot"]["occupied"] = true
				body.move_to_position(right_foot_joint.position, body.limbID, right_foot_joint, "rightFoot")
				body.gravity_scale = 1
				setCurrentLimb("rightFoot", body.effect, body.limbID)


func _on_head_connector_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if Global.currentBuildStatus["head"]["occupied"] == false:
			if body.limbType == "head":
				Global.currentBuildStatus["head"]["occupied"] = true
				body.move_to_position(head_joint.position, body.limbID, head_joint, "head")
				body.gravity_scale = 1
				setCurrentLimb("head", body.effect, body.limbID)


func setCurrentLimb(limbType: String, limbEffect: String, limbID: int):
	Global.currentBuildStatus[str(limbType)]["effect"] = limbEffect 
	Global.currentBuildStatus[str(limbType)]["ID"] = limbID 
