extends Control

@onready var order_screen: Node2D = $"../OrderScreen"
@onready var button: Button = $Button
@onready var work_bench: Node2D = $"../WorkBench"
@onready var work_bench_background: ColorRect = $"../WorkBench/workBenchBackground"

var button_slide = false

signal notePosition

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if button_slide == true:
		if order_screen.visible == false:
			if button.position.x != 1151.6 && work_bench.position.x != 0:
				button.position.x = move_toward(button.position.x, 1151.6, 50)
				work_bench.position.x = move_toward(work_bench.position.x, 0, 50)
			else:
				button_slide = false
		elif order_screen.visible == true:
			if button.position.x != 58.2 && work_bench.position.x != -1161:
				button.position.x = move_toward(button.position.x, 58.2, 50)
				work_bench.position.x = move_toward(work_bench.position.x, -1161, 50)
			else:
				button_slide = false


func _on_button_pressed() -> void:
	openWorkBench()
	
	
func openWorkBench():
	if order_screen.visible == true:
		order_screen.visible = false
		button.text = "Order Screen"

		
	elif order_screen.visible == false:
		order_screen.visible = true
		button.text = "Work Bench"

	button_slide = true
	notePosition.emit()
