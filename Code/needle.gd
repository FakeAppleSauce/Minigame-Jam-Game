extends Area2D

var needleEffect = "nothin"

var alreadyEntered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Hold"):
		position = get_global_mouse_position()
	else:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if alreadyEntered == false:
		alreadyEntered = true
		while Input.is_action_pressed("Hold"):
			await get_tree().process_frame
		
		if overlaps_body(body):
			body.changeEffect(needleEffect)
