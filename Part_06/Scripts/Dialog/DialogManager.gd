### DialogManager.gd

extends Node2D

@onready var dialog_ui = $DialogUI

var npc: Node = null

# Show dialog with data
func show_dialog(npc, text = "", options = {}):
	if text != "":
		# Show empty box
		dialog_ui.show_dialog(npc.npc_name, text, options)
	else:
		# Show populated data
		var dialog = npc.get_current_dialog()
		if dialog == null:
			return
		dialog_ui.show_dialog(npc.npc_name, dialog["text"], dialog["options"])

# Hide dialog
func hide_dialog():
	dialog_ui.hide_dialog()
	
# Dialog state management
func handle_dialog_choice(option):
	# Get current dialog branch
	var current_dialog = npc.get_current_dialog()
	if current_dialog == null:
		return
		
	# Update state
	var next_state = current_dialog["options"].get(option, "start")
	npc.set_dialog_state(next_state)
	
	# Handle state transitions
	if next_state == "end":
		if npc.current_branch_index < npc.dialog_resource.get_npc_dialog(npc.npc_id).size() - 1:
			npc.set_dialog_tree(npc.current_branch_index + 1)
		hide_dialog()
	elif next_state == "exit":
		npc.set_dialog_state("start")
		hide_dialog()
	elif next_state == "give_quests":
		pass
	else:
		show_dialog(npc)
	
	
	
	
	
	
	
	
