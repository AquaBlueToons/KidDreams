extends Node

const SAVE_PATH = "user://savegame.bin"

func saveGame():
	var file
	file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"points": Game.points
	}
	var jstr =JSON.stringify(data)
	file.store_line(jstr)
	
func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
