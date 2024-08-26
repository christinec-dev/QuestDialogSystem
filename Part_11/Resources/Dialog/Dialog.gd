## Dialog.gd

extends Resource

class_name Dialog

# Vars
@export var dialogs = {}

# Loads Dialog Data
func load_from_json(file_path):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		dialogs = parsed_data
	else:
		print("Failed to parse JSON: ", parsed_data)

# Returns individual NPC dialogs
func get_npc_dialog(npc_id):
	if npc_id in dialogs:
		return dialogs[npc_id]["trees"]
	else:
		return []
