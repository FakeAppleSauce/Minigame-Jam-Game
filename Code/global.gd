extends Node

var limbID = 0
var currentLimbSpawn = "null"
var infractions = 0
var repAmount = 0

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

var limbs = ["leftArm", "rightArm", "leftFoot", "rightFoot", "head"]
var unlockedEffects = ["null", "none"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func createNewOrder():
	for i in 5:
		currentOrder[limbs[i - 1]] = unlockedEffects[randi_range(0, 1)]
		print(str(limbs[i - 1]) + ": " + str(currentOrder[limbs[i - 1]]))
