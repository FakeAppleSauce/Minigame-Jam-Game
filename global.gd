extends Node

var limbID = 0
var currentLimbSpawn = "null"
var currentBuildStatus = {
	"head": {
		"occupied": false,
		"effect": null,
		"ID": null
	},
	"leftArm": {
		"occupied": false,
		"effect": null,
		"ID": null
	},
	"rightArm": {
		"occupied": false,
		"effect": null,
		"ID": null
	},
	"leftFoot": {
		"occupied": false,
		"effect": null,
		"ID": null
	},
	"rightFoot": {
		"occupied": false,
		"effect": null,
		"ID": null
	}
}

var currentOrder = {
	"head": "none",
	"leftArm": "none",
	"rightArm": "none",
	"leftFoot": "none",
	"rightFoot": "none"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
