extends Node

var limbID = 0
var currentLimbSpawn = "null"
var infractions = 0
var repAmount = 0

var needleEquipped = false

var onOrderScreen = true

var currentBuildStatus = {
	"head": {
		"occupied": false,
		"effect": "null",
		"ID": null
	},
	"leftArm": {
		"occupied": false,
		"effect": "null",
		"ID": null
	},
	"rightArm": {
		"occupied": false,
		"effect": "null",
		"ID": null
	},
	"leftFoot": {
		"occupied": false,
		"effect": "null",
		"ID": null
	},
	"rightFoot": {
		"occupied": false,
		"effect": "null",
		"ID": null
	}
}

var currentOrder = {
	"head": "null",
	"leftArm": "null",
	"rightArm": "null",
	"leftFoot": "null",
	"rightFoot": "null"
}

var limbs = ["head", "leftArm", "rightArm", "leftFoot", "rightFoot"]
var unlockedEffects = ["null", "none", "grow", "duplicate", "metal", "animal"]

var limbPNGPositions = {
	"leg_none": Rect2(0,0,256,256),
	"leg_duplicate": Rect2(256,0,256,256),
	"leg_grow": Rect2(512,0,256,256),
	"leg_metal": Rect2(768,0,256,256),
	"leg_animal": Rect2(0,256,256,256),
	"arm_none": Rect2(256,256,256,256),
	"arm_duplicate": Rect2(512,256,256,256),
	"arm_grow": Rect2(768,256,256,256),
	"arm_metal": Rect2(0,512,256,256),
	"arm_animal": Rect2(256,512,256,256),
	"head_none": Rect2(512,512,256,256),
	"head_duplicate": Rect2(768,512,256,256),
	"head_grow": Rect2(0,768,256,256),
	"head_metal": Rect2(256,768,256,256),
	"head_animal": Rect2(512,768,256,256)
}

signal runOrderVisuals

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func createNewOrder():
	for i in 5:
		currentOrder[limbs[i - 1]] = unlockedEffects[randi_range(0, len(unlockedEffects)) - 1]
		print(str(limbs[i - 1]) + ": " + str(currentOrder[limbs[i - 1]]))
	
	runOrderVisuals.emit()
