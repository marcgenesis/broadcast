extends Button

func _on_RestoreHP_pressed():
	Broadcast.send("restore_hp", {"restore":7})
