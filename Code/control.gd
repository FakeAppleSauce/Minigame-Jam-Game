extends Control

@onready var order_screen: Node2D = $"../OrderScreen"
@onready var work_bench_button: Button = $workBenchButton
@onready var work_bench: Node2D = $"../WorkBench"
@onready var work_bench_background: ColorRect = $"../WorkBench/workBenchBackground"
@onready var rep_counter: Label = $RepCounter
@onready var infraction_counter: Label = $InfractionCounter

var button_slide = false
var limbs = ["leftArm", "rightArm", "leftFoot", "rightFoot", "head"]

signal notePosition
signal deleteAttachedLimbs

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if button_slide == true:
		if order_screen.visible == false:
			if work_bench_button.position.x != 1151.6 && work_bench.position.x != 0:
				work_bench_button.position.x = move_toward(work_bench_button.position.x, 1151.6, 50)
				work_bench.position.x = move_toward(work_bench.position.x, 0, 50)
			else:
				button_slide = false
		elif order_screen.visible == true:
			if work_bench_button.position.x != 58.2 && work_bench.position.x != -1161:
				work_bench_button.position.x = move_toward(work_bench_button.position.x, 58.2, 50)
				work_bench.position.x = move_toward(work_bench.position.x, -1161, 50)
			else:
				button_slide = false


func _on_button_pressed() -> void:
	openWorkBench()
	
	
func openWorkBench():
	if order_screen.visible == true:
		work_bench_button.text = "Order Screen"
		order_screen.visible = false

		
	elif order_screen.visible == false:
		order_screen.visible = true
		work_bench_button.text = "Work Bench"

	button_slide = true
	notePosition.emit()

var goods = 0
func _on_send_order_pressed() -> void:
	for i in 5:
		if Global.currentBuildStatus[limbs[i - 1]]["effect"] == Global.currentOrder[limbs[i - 1]]:
			print(limbs[i - 1] + " good")
			goods += 1
		else:
			print(limbs[i - 1] + " bad")
			
	if goods == 5:
		Global.repAmount += 100
		change_counters("rep")
		deleteAttachedLimbs.emit()
		goods = 0
		for i in 5:
			Global.currentBuildStatus[limbs[i-1]]["effect"] = "null"
			Global.currentBuildStatus[limbs[i-1]]["ID"] = null
			Global.currentBuildStatus[limbs[i-1]]["occupied"] = false
		
	elif goods < 5:
		Global.infractions += 1
		change_counters("infractions")
		goods = 0

func change_counters(counter: String):
	if counter == "rep":
		rep_counter.text = "Reputation: " + str(Global.repAmount)
		
	elif counter == "infractions":
		infraction_counter.text = "Infractions: " + str(Global.infractions)
		infraction_counter.self_modulate.b = 1 - 1.00/4 * Global.infractions
		infraction_counter.self_modulate.g = 1 - 1.00/4 * Global.infractions
		infraction_counter.self_modulate.r = 1 - 1.00/4 * (Global.infractions - 3)
		print(infraction_counter.self_modulate.b)
	
