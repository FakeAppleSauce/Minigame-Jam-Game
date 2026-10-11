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



@onready var send_order_button: Button = $"../OrderScreen/sendOrderButton"
@onready var temporarytext: Label = $TEMPORARYTEXT
@onready var temporarytext_2: Label = $TEMPORARYTEXT2
@onready var temporarytext_3: Label = $TEMPORARYTEXT3

@onready var camera_2d: Camera2D = $"../Camera2D"


var button_slide = false
var workBenchUp = false
var limbs = ["leftArm", "rightArm", "leftFoot", "rightFoot", "head"]

var multiplierCurrentShake: float = 0
var shake_decay_rate: float = 5.0

signal notePosition
signal deleteAttachedLimbs

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if multiplierCurrentShake > 0:
		multiplierCurrentShake = lerp(multiplierCurrentShake, 0.0, shake_decay_rate * delta)
		
		rep_multiplier.position = Vector2(906, 21) + Vector2(
			randf_range(-multiplierCurrentShake, multiplierCurrentShake),
			randf_range(-multiplierCurrentShake, multiplierCurrentShake)
		)
	else:
		rep_multiplier.position = Vector2(906, 21)
	pass
	
	
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
		if Global.orderNumber != 0:
			Global.repAmount += 50 * order_screen.repMultiplier
			change_counters("rep")
		else:
			Global.repAmount = 1
		
		Global.orderNumber += 1
		deleteAttachedLimbs.emit()
		goods = 0
		Global.createNewOrder()
		order_screen._on_rep_timer_timeout()
		order_screen.repMultiplier = 50
		change_counters("repMultiplier")
		
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
			await get_tree().create_timer(0.1).timeout
			get_tree().change_scene_to_file("res://Scenes/home_page.tscn")



func change_counters(counter: String):
	if counter == "rep":
		rep_counter.text = "Reputation: " + str(Global.repAmount)
		
	elif counter == "infractions":
		infraction_counter.text = "Infractions: " + str(Global.infractions)
		infraction_counter.self_modulate.b = 1 - 1.00/4 * Global.infractions
		infraction_counter.self_modulate.g = 1 - 1.00/4 * Global.infractions
		infraction_counter.self_modulate.r = 1 - 1.00/4 * (Global.infractions - 3)
	
	elif counter == "repMultiplier":
		rep_multiplier.text = "+ " + str(50 * order_screen.repMultiplier)
		rep_multiplier.add_theme_color_override("font_color", Color(1.00/50 * (order_screen.repMultiplier), 0.05, 0, 1))
		multiplierCurrentShake = order_screen.repMultiplier/10
		multiplier_particles.scale_amount_max = 10.0000/50 * order_screen.repMultiplier
		
	elif counter == "order_number":
		order_number.text = str(Global.orderNumber)
	
