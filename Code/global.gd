extends Node

var limbID = 0
var currentLimbSpawn = "null"
var infractions = 0
var repAmount = 0

var needleEquipped = false

var onOrderScreen = true

var orderNumber = 0

var tutorialOn = false

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
var unlockedEffects = ["null", "none"]

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

var canStart = false
var currentDialogue = -1
var nextDialogue = "unlocked"
var nextSectionUnlocked = false
var dialogues = [
	#introduction
	"Welcome to your first day at your unpaid internship at NotASketchyCompany LLC!!",
	"before we start your training, we need to give you a quick rundown on the situation at hand.",
	"The world has been taken over by a contamination that turned everyone into yucky zombies",
	"The governmnet has hired us to find some way to stop this apocalypse",
	"My plan, as the senior scientist on duty, is to find a hybrid zombie that fights back the original zombies.",
	"However, I need someone to prepare the zombies with different attributes, so I can test the different versions more efficiently.",
	"This is where you come in.",
	'As my unpaid intern, I need you to prepare the zombie "orders" I send your way',
	#initial tutorial
	"Ok, now that you get the goal here, lets begin with the initial training",
	"On your right, you'll see a piece of paper with a diagram of the current zombie build I need",
	"On your left is your current zombie your building. The torso is already given to you.",
	"However, it is your job to create and attach the limbs that are requested on the order",
	"Now, lets move onto your work bench",
	#Wait for input
	"Here is where you create your limbs",
	"On the left you have 3 labeled coolers that hold your 3 different limbs",
	"Go ahead and click one to take out a limb!",
	#Wait for input
	"You're a natural at this kid! At this rate you might start getting paid in a few years",
	"Anywho, for now, I am only testing regular limbs so we wont worry about the needles on the shelf",
	"That yellow bar above each limb is a life bar. If that bar disappears, the limb is no good anymore and will die.",
	"However, this resets once the limb is attached to the torso, but it will still continue to count down",
	"To move the limbs into the Order Station, you want to drag the limb into the chute on the right of your screen",
	#Wait for input
	"Perfect! now if you go to your Order Station, you can see the limb",
	#Wait for input
	"To attach the limb, all you have to do is drag it onto the corresponding joint on the torso",
	"Be careful though, sometimes you have to wiggle the limb in and out of the joint for it to fully attach",
	"This was definitely an intentional design choice and not a bug the developer couldn't be bothered to fix though",
	#Wait for input
	"Perfect! The last few things you need to know is that you are able to dispose of limbs",
	"To do so, just hover the desired limb and right click",
	#Wait for input
	"On your top right, you'll see a reputation counter.", 
	"The faster you finish up these orders, the more reputation you'll receive. Lets see how high you can you get",
	"If your rep ever goes into the negatives, however, you will be fired. So DONT lets this happen",
	"Finally, be careful. IF you attempt to send me any wrong order, you WILL get an infraction",
	"Once you collect 5 of these, you will be terminated. So Dont.",
	"Welp! besides that, you should know the basics, lets start off with some basic orders shall we?",
	"If you do not see a limb on the piece of paper, then do not attach one, and vice versa!",
	"Once you finish an order, go ahead and click that bell to send off the order and receive the next one",
	"Good luck and don't stand still too much!",
	#Needles intro
	"Hey, so bad news. These basic combinations are not cutting it.",
	"Remember those needles I spoke of before? Well we're gonna need to start using them if we want a chance at stopping this.",
	"If you go to your work bench real quick...",
	"At the bottom of your screen, you will see an assortment of needles.",
	"Right now, we're gonna start using the growing serum. This is the blue one.",
	"This will enlarge the limb and make it stronger",
	"All you have to do is click and drag a needle from the shelf below onto a limb for the limb to get the effect",
	"Go ahead and attach this new limb to the right arm like the order paper I sent shows you",
	"Ok. Hopefully this new limb effect can make a strong enough zombie. Its not looking too good out there",
	#metal intro 41
	"BAD NEWS KID.",
	"These zombies are not cutting it.",
	"Ima start sending you orders for a new limb type.",
	"This new limb type is the metal effect.",
	"Hopefully these make the zombies stand up more against attacks.",
	"The grey needle contains the serum for this effect",
	"Go ahead and try it out and send me over the order I sent",
	"Good work so far kid, but get ready for some big challenges coming up",
	#duplicate intro 49
	"AAAAAAAAAAAAAAAAAAAAAAH",
	"*ahem* sorry kid, but these zombies are not even budging with these artificial zombies were making",
	"I'm going to start testing out a very experimental serum",
	"In the purple needle, there is a duplication serum",
	"This serum will multiply the amount of parts the limbs have",
	"Hopefully this will make it harder to kill our zombie clones",
	"Go ahead and fufill the practice order I sent you and get back to work",
	#animal intro 56
	"Ok kid. We're starting to get somewhere but we need that final blow",
	"There is a 4th and final serum I am going to test.",
	"It doesn't even have a name yet but it is in that orange needle",
	"It makes the limb... I don't even know",
	"it looks like the developer was too lazy to make a 4th texture but whatever",
	"This is the strongest of the 4th serum, go ahead and fufill this practice order with it and get back to work.",
	#exit
	"AMAZING WORK KID",
	"I knew I hired the right kid",
	"Thanks to your help I was able to find the right zombie to contain the contamination with.",
	"However, our work here is never done. If you would like, you can keep preparing bodies for the love of the game.",
	"Your reputation has no bounds. Just go ahead and press that bell and start endless mode."
]

var dialoguePositions = [
	#Introduction
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	#Initial Tutorial
	Vector2(14, 17),
	Vector2(289, 25),
	Vector2(491, 311),
	Vector2(491, 311),
	Vector2(64, 54),
	Vector2(-535, 21),
	Vector2(-878, 51),
	Vector2(-878, 51),
	Vector2(-878, 51),
	Vector2(-878, 51),
	Vector2(-878, 51),
	Vector2(-878, 51),
	Vector2(-453, 150),
	Vector2(-453, 150),
	Vector2(439, 23),
	Vector2(439, 23),
	Vector2(439, 23),
	Vector2(439, 23),
	Vector2(439, 23),
	Vector2(292, 94),
	Vector2(292, 94),
	Vector2(515, 476),
	Vector2(515, 476),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(-788, 300),
	Vector2(-788, 300),
	Vector2(-588, 21),
	Vector2(-588, 21),
	Vector2(-588, 21),
	Vector2(14, 17),
	
	
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
	Vector2(14, 17),
]


signal runOrderVisuals


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func createNewOrder():
	if orderNumber != 5 && orderNumber != 9 && orderNumber != 13 && orderNumber != 17 && orderNumber != 24:
		for i in 5:
			currentOrder[limbs[i - 1]] = unlockedEffects[randi_range(0, len(unlockedEffects)) - 1]
	else:
		pass
		#for i in 5:
			#currentOrder[limbs[i - 1]] = "null"
			
	
	if orderNumber == 5:
		unlockedEffects.append("grow")
	if orderNumber == 9:
		unlockedEffects.append("metal")
	if orderNumber == 13:
		unlockedEffects.append("duplicate")
	if orderNumber == 17:
		unlockedEffects.append("animal")
		
	
	runOrderVisuals.emit()


	



#Introduction
#Learn basics with no effects (empty and not empty limbs) [Orders 1-8]
#Unlock first effect (big) + introduction to how needles work [Orders 9-12]
#Unlock 2nd effect (metal) [Orders 13-16]
#Unlock 3rd effect (duplicate) [Orders 17-20]
#Unlock 4th effect (derp) [Orders 21-24]
#End of Story
#Start Infinite
