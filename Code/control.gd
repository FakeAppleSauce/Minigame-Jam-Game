extends Control

@onready var order_screen: Node2D = $"../OrderScreen"
@onready var work_bench_button: Button = $workBenchButton
@onready var work_bench: Node2D = $"../WorkBench"
@onready var work_bench_background: TextureRect = $"../WorkBench/workBenchBackground"
@onready var rep_counter: Label = $RepCounter
@onready var infraction_counter: Label = $InfractionCounter
@onready var order_number: Label = $"../OrderScreen/CurrentOrder/orderNumber"
@onready var rep_multiplier: Label = $repMultiplier
@onready var multiplier_particles: CPUParticles2D = $repMultiplier/multiplierParticles



@onready var send_order_button: TextureButton = $"../OrderScreen/sendOrderButton"

@onready var camera_2d: Camera2D = $"../Camera2D"

@onready var speech_text: Label = $"Tutorial Stuff/speechBubble/speechText"
@onready var speech_bubble: Control = $"Tutorial Stuff/speechBubble"


var button_slide = false
var workBenchUp = false
var limbs = ["leftArm", "rightArm", "leftFoot", "rightFoot", "head"]

var multiplierCurrentShake: float = 0
var shake_decay_rate: float = 5.0

signal notePosition
signal deleteAttachedLimbs

func _ready() -> void:
	if Global.tutorialOn == true:
		speech_bubble.visible = true
	else:
		speech_bubble.visible = false


func _process(delta: float) -> void:
	if multiplierCurrentShake > 0:
		multiplierCurrentShake = lerp(multiplierCurrentShake, 0.0, shake_decay_rate * delta)
		
		rep_multiplier.position = Vector2(764, 16) + Vector2(
			randf_range(-multiplierCurrentShake, multiplierCurrentShake),
			randf_range(-multiplierCurrentShake, multiplierCurrentShake)
		)
	else:
		rep_multiplier.position = Vector2(764, 16)
	
	if Global.tutorialOn == true:
		if Input.is_action_just_pressed("Dialogue"):
			if Global.nextDialogue == "unlocked" && Global.currentDialogue != 34 and Global.currentDialogue != 43 and Global.currentDialogue != 51 and Global.currentDialogue != 58 and Global.currentDialogue < 65:
				speech_text.visible_ratio = 0
				Global.currentDialogue += 1
				speech_text.text = Global.dialogues[Global.currentDialogue]
				speech_bubble.position = Global.dialoguePositions[Global.currentDialogue]
			
				startNewDialogue()
			elif Global.currentDialogue == 34: 
				speech_text.visible_ratio = 1
				Global.currentDialogue = 35
				speech_text.text = Global.dialogues[Global.currentDialogue]
				speech_bubble.visible = false
				Global.nextDialogue = "locked"
				Global.nextSectionUnlocked = true
				
			elif Global.currentDialogue == 43: 
				speech_text.visible_ratio = 1
				Global.currentDialogue = 45
				speech_text.text = Global.dialogues[Global.currentDialogue]
				speech_bubble.visible = false
				Global.nextDialogue = "locked"
				Global.nextSectionUnlocked = true
				
			elif Global.currentDialogue == 51: 
				speech_text.visible_ratio = 1
				Global.currentDialogue = 53
				speech_text.text = Global.dialogues[Global.currentDialogue]
				speech_bubble.visible = false
				Global.nextDialogue = "locked"
				Global.nextSectionUnlocked = true
				
			elif Global.currentDialogue == 58: 
				speech_text.visible_ratio = 1
				Global.currentDialogue = 59
				speech_text.text = Global.dialogues[Global.currentDialogue]
				speech_bubble.visible = false
				Global.nextDialogue = "locked"
				Global.nextSectionUnlocked = true
	
	
	
#right = 576, left = -576
func _physics_process(_delta: float) -> void:
	if button_slide == true:
		if workBenchUp == false:
			if camera_2d.position.x != -576:
				work_bench_button.position.x = move_toward(work_bench_button.position.x, -1, 2.57)
				camera_2d.position.x = move_toward(camera_2d.position.x, -576, 50)
			else:
				button_slide = false
				workBenchUp = true
		elif workBenchUp == true:
			if camera_2d.position.x != 576:
				work_bench_button.position.x = move_toward(work_bench_button.position.x, 58.2, 2.57)
				camera_2d.position.x = move_toward(camera_2d.position.x, 576, 50)
			else:
				button_slide = false
				workBenchUp = false


func _on_button_pressed() -> void:
	openWorkBench()
	
	
func openWorkBench():
	if order_screen.visible == true:
		work_bench_button.text = "Order Screen"
		

		
	elif order_screen.visible == false:
		order_screen.visible = true
		work_bench_button.text = "Work Bench"

	button_slide = true
	notePosition.emit()

var goods = 0



func _on_send_order_pressed() -> void:
	for i in 5:
		if Global.currentBuildStatus[limbs[i - 1]]["effect"] == Global.currentOrder[limbs[i - 1]]:
			goods += 1
		else:
			for j in 5:
				pass
			
	if goods == 5:
		if Global.orderNumber != 0 && Global.orderNumber != 5 && Global.orderNumber != 9 && Global.orderNumber != 13 && Global.orderNumber != 17:
			Global.repAmount += round(50 * order_screen.repMultiplier)
			if Global.orderNumber == 1:
				Global.repAmount -= 1
			change_counters("rep")
		else:
			Global.repAmount = 1
		Global.orderNumber += 1
			
		
		if Global.orderNumber == 5 or Global.orderNumber == 9 or Global.orderNumber == 13 or Global.orderNumber == 17:
			Global.nextDialogue = "unlocked"
			speech_bubble.visible = true
			startNewDialogue()
			Global.currentOrder["head"] = "null"
			Global.currentOrder["leftArm"] = "null"
			Global.currentOrder["leftFoot"] = "null"
			Global.currentOrder["rightFoot"] = "null"
			if Global.orderNumber == 5:
				Global.currentOrder["rightArm"] = "grow"
			elif Global.orderNumber == 9:
				Global.currentOrder["rightArm"] = "metal"
			elif Global.orderNumber == 13:
				Global.currentOrder["rightArm"] = "duplicate"
			elif Global.orderNumber == 17:
				Global.currentOrder["rightArm"] = "animal"
			
			
		else:
			goods = 0
			order_screen._on_rep_timer_timeout()
			order_screen.repMultiplier = 50
			change_counters("repMultiplier")
		Global.createNewOrder()
		await get_tree().create_timer(0.5).timeout
		deleteAttachedLimbs.emit()
		
		
		for i in 5:
			Global.currentBuildStatus[limbs[i-1]]["effect"] = "null"
			Global.currentBuildStatus[limbs[i-1]]["ID"] = null
			Global.currentBuildStatus[limbs[i-1]]["occupied"] = false
			
		order_screen.left_arm_connector_sprite.visible = true
		order_screen.right_arm_connector_sprite.visible = true
		order_screen.left_foot_connector_sprite.visible = true
		order_screen.right_foot_connector_sprite.visible = true
		order_screen.head_connector_sprite.visible = true
			
		
		
	elif goods < 5:
		Global.infractions += 1
		change_counters("infractions")
		goods = 0
		
		if Global.infractions >= 5:
			Global.infractions = 0
			Global.currentOrder = {
				"head": "null",
				"leftArm": "null",
				"rightArm": "null",
				"leftFoot": "null",
				"rightFoot": "null"
			}
			Global.repAmount = 0
			order_screen.repMultiplier = 0
			Global.orderNumber = 0
			Global.currentDialogue = 0
			await get_tree().create_timer(0.1).timeout
			get_tree().change_scene_to_file("res://Scenes/home_page.tscn")



func change_counters(counter: String):
	if counter == "rep":
		rep_counter.text = "Reputation: " + str(Global.repAmount)
		for i in 5:
			rep_counter.self_modulate.g = move_toward(rep_counter.self_modulate.g, 0.5, 0.1)
			rep_counter.self_modulate.b = move_toward(rep_counter.self_modulate.g, 0.5, 0.1)
			await get_tree().create_timer(0.1).timeout
			rep_counter.self_modulate.g = move_toward(rep_counter.self_modulate.g, 1, 0.1)
			rep_counter.self_modulate.b = move_toward(rep_counter.self_modulate.g, 1, 0.1)
			await get_tree().create_timer(0.1).timeout
		
	elif counter == "infractions":
		infraction_counter.text = "Infractions: " + str(Global.infractions)
		infraction_counter.self_modulate.b = 1 - 1.00/4 * Global.infractions
		infraction_counter.self_modulate.g = 1 - 1.00/4 * Global.infractions
		infraction_counter.self_modulate.r = 1 - 1.00/4 * (Global.infractions - 3)
	
	elif counter == "repMultiplier":
		rep_multiplier.text = "+ " + str(round(50 * order_screen.repMultiplier))
		rep_multiplier.add_theme_color_override("font_color", Color(1, 1- 1.00/50 * (order_screen.repMultiplier), 1 - 1.00/50 * (order_screen.repMultiplier), 1))
		multiplierCurrentShake = order_screen.repMultiplier/10
		multiplier_particles.scale_amount_max = 10.0000/50 * order_screen.repMultiplier
		
	elif counter == "order_number":
		order_number.text = str(Global.orderNumber)



func startNewDialogue():
	if speech_text.visible_ratio != 1:
		speech_text.visible_ratio += 0.01
		await get_tree().create_timer(0.01).timeout
		startNewDialogue()
