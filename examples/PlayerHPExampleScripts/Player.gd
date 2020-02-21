extends Area2D

export var HP = 30

func _ready():
	# Listen for restore HP broadcast
	Broadcast.listen("restore_hp", self, "_on_restore_hp")
	
	# Send a message with the current player's HP
	Broadcast.send("player_hp_change", {"player_hp":HP})


func _on_Player_area_entered(area):
	# Detect a collision with an enemy
	if area.get_groups().has("Enemy"):
		# Reduce the HP by 10
		HP -= 10
		
		# Send a broadcast with the HP left
		Broadcast.send("player_hp_change", {"player_hp":HP})
		
		# Destroy the player if its HP is 0 or less
		if HP <= 0:
			Broadcast.send("defeat")
			queue_free()

# Called on broadcast from "restore_hp"
func _on_restore_hp(params):
	# Change the HP
	HP += params["restore"]
	
	# Broadcast the HP change
	Broadcast.send("player_hp_change", {"player_hp":HP})
