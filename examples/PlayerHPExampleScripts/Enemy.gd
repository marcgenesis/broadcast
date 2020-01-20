extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction : bool = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Enemy listens to victory, but only once.
	Broadcast.listen_once("defeat", self, "_on_defeat")
	
	# Create the enemy movement
	$Tween.repeat = true
	$Tween.interpolate_property(self, "position:x", 100, 500, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "position:x", 500, 100, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
	$Tween.start()


# Function that will get called upon victory.
func _on_defeat(params):
	scale = Vector2(5, 5)