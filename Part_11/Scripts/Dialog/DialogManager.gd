extends Node2D

@onready var dialog_ui = $DialogUI
var npc: Node = null

func show_dialog(npc):
	check_and_advance_branch()

	var quest_dialog = npc.get_quest_dialog()
	if quest_dialog["text"] != "":
		dialog_ui.show_dialog(npc.npc_name, quest_dialog["text"], quest_dialog["options"])
	else:
		var dialog = npc.get_current_dialog()
		if dialog:
			dialog_ui.show_dialog(npc.npc_name, dialog["text"], dialog["options"])

func hide_dialog():
	dialog_ui.hide_dialog()

func handle_dialog_choice(option):
	var current_dialog = npc.get_current_dialog()
	if not current_dialog:
		return

	var next_state = current_dialog["options"].get(option, "start")
	npc.set_dialog_state(next_state)

	if next_state == "end":
		if all_quests_completed_for_branch(npc.current_branch_index):
			advance_to_next_branch()
		else:
			dialog_ui.show_dialog(npc.npc_name, "Goodbye for now.", {"Okay": "exit"})
	elif next_state == "exit":
		npc.set_dialog_state("start")
		hide_dialog()
	elif next_state == "give_quests":
		offer_quests(npc.dialog_resource.get_npc_dialog(npc.npc_id)[npc.current_branch_index]["branch_id"])
		show_dialog(npc)
	else:
		show_dialog(npc)

func all_quests_completed_for_branch(branch_index):
	var branch_id = npc.dialog_resource.get_npc_dialog(npc.npc_id)[branch_index]["branch_id"]
	for quest in npc.quests:
		if quest.unlock_id == branch_id and quest.state != "completed":
			return false
	return true

func offer_quests(branch_id: String):
	for quest in npc.quests:
		if quest.unlock_id == branch_id and quest.state == "not_started":
			npc.offer_quest(quest.quest_id)

func offer_remaining_quests():
	for quest in npc.quests:
		if quest.state == "not_started":
			npc.offer_quest(quest.quest_id)

func check_and_advance_branch():
	if all_quests_completed_for_branch(npc.current_branch_index) and npc.current_branch_index < npc.dialog_resource.get_npc_dialog(npc.npc_id).size() - 1:
		advance_to_next_branch()

func advance_to_next_branch():
	npc.set_dialog_branch(npc.current_branch_index + 1)
	npc.set_dialog_state("start")
	show_dialog(npc)
