extends Area2D

var needleEffect = "nothin"

var alreadyEntered = false

@onready var needles: Node2D = $".."
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func setUpTexture():
	if needleEffect == "grow":
		sprite_2d.texture.region = Rect2(256, 0, 256, 256)
	elif needleEffect == "metal":
		sprite_2d.texture.region = Rect2(0, 256, 256, 256)
	elif needleEffect == "duplicate":
		sprite_2d.texture.region = Rect2(0, 0, 256, 256)
	elif needleEffect == "animal":
		sprite_2d.texture.region = Rect2(256, 256, 256, 256)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("Hold"):
		position = get_global_mouse_position()
	else:
		Global.needleEquipped = false
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "limbs":
		if alreadyEntered == false:
			alreadyEntered = true
			while Input.is_action_pressed("Hold"):
				await get_tree().process_frame
			
			if overlaps_body(body):
				body.changeEffect(needleEffect)


func _on_body_exited(_body: Node2D) -> void:
	if alreadyEntered == true:
		alreadyEntered = false
