extends RigidBody2D

var hovering = false
var equipped = false
var distance_vector = Vector2(0, 0)


var displacement = 0
var spring_force = 0
var damping_force = 0

var initial_Xposition = 0
var moveToOrderScreen = false

#0 Work Bench
#1 Order Screen
@export var limb_location: int = 0
@export var limbID = 0

@onready var area_2d: Area2D = $WorkBench/Chute/Area2D
@onready var ui: Control = $"../../UI"
@onready var order_screen: Node2D = $"../../OrderScreen"
@onready var life_bar: ColorRect = $lifeBar
@onready var life: Timer = $life
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	ui.notePosition.connect(_on_note_position)
	apply_central_impulse(Vector2.RIGHT * 5000)
	limbID = Global.limbID
	Global.limbID += 1



func _process(delta: float) -> void:
	life_bar.position.x = sprite_2d.position.x - life_bar.size.x/2
	life_bar.size.x = 79/20 * life.time_left
	life_bar.color.g = (255/20 * life.time_left)*0.004

func _physics_process(delta: float) -> void:
	if hovering == true:
		if Input.is_action_just_pressed("Hold"):
			distance_vector = get_global_mouse_position() - position
			equipped = true
			sprite_2d.scale = Vector2(0.101, 0.172)

	if Input.is_action_pressed("Hold") && equipped == true:
		displacement = get_global_mouse_position() - position
		spring_force = displacement*1000 #what the hell is happening
		damping_force = -linear_velocity*50
		apply_central_force(spring_force + damping_force)
	
	if Input.is_action_just_released("Hold"):
		equipped = false
		sprite_2d.scale = Vector2(0.071, 0.142)
		
		
	if ui.button_slide == true && limb_location == 0 && order_screen.visible == true:
		freeze = true
		position.x = move_toward(position.x, initial_Xposition - 1162, 50)
	elif ui.button_slide == true && limb_location == 0 && order_screen.visible == false:
		position.x = move_toward(position.x, initial_Xposition + 1162, 50)
		if position.x >= initial_Xposition + 1162:
			freeze = false
 


func _on_mouse_entered() -> void:
	hovering = true


func _on_mouse_exited() -> void:
	hovering = false
	
func _on_note_position():
	initial_Xposition = position.x

	
func _on_life_timeout() -> void:
	queue_free()
