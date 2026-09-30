extends Control

@onready var order_screen: Node2D = $"../OrderScreen"
@onready var work_bench_button: Button = $workBenchButton
@onready var work_bench: Node2D = $"../WorkBench"
@onready var work_bench_background: ColorRect = $"../WorkBench/workBenchBackground"

var button_slide = false
var limbs = ["leftArm", "rightArm", "leftFoot", "rightFoot", "head"]

signal notePosition

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


func _on_send_order_pressed() -> void:
	for i in 5:
		if Global.currentBuildStatus[limbs[i - 1]]["effect"] == Global.currentOrder[limbs[i - 1]]:
			print(limbs[i - 1] + " good")
		else:
			print(limbs[i - 1] + " bad")
