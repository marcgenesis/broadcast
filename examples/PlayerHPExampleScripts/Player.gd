extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var HP = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	# Send a message with the current player's HP
	Broadcast.send("player_hp_change", {"player_hp":HP})

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_area_entered(area):
	# Detect a collision with an enemy
	if area.get_groups().has("Enemy"):
		# Reduce the HP by 10
		HP -= 10
		
		# Send a broadcast with the HP left
		Broadcast.send("player_hp_change", {"player_hp":HP})
		
		# Destroy the player if its HP is 0 or less
		if HP <= 0:
			queue_free()
