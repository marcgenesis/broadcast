extends Label



func _ready():
	# Listen to broadcast for player damage
	Broadcast.listen("player_hp_change", self, "_on_player_hp_change")

# Function called when broadcast sends a message concerning player damage
func _on_player_hp_change(params):
	text = str("Player's health: ", params["player_hp"])
	
	# Call victory on HP = 0
	if params["player_hp"] <= 0:
		Broadcast.send("victory")
