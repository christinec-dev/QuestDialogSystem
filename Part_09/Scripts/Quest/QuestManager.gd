### QuestManager.gd

extends Node2D

@onready var quest_ui = $QuestUI

# Signals
signal quest_updated(quest_id: String)
signal objective_updated(quest_id: String, objective_id: String)
signal quest_list_updated()

var quests = {}

# Add quests
func add_quest(quest: Quest):
	quests[quest.quest_id] = quest
	quest_updated.emit(quest.quest_id)

# Remove quests
func remove_quest(quest_id: String):
	quests.erase(quest_id)
	quest_list_updated.emit()
	
# Get quest
func get_quest(quest_id: String) -> Quest:
	return quests.get(quest_id, null)
	
# Update quest
func update_quest(quest_id: String, state: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.state = state
		quest_updated.emit(quest_id)
		if state == "completed":
			remove_quest(quest_id)
		
# Get selected quest
func get_active_quests() -> Array:
	var active_quests = []
	for quest in quests.values():
		if quest.state == "in_progress":
			active_quests.append(quest)
	return active_quests
	
# Complete objective
func complete_objective(quest_id: String, objective_id: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.complete_objective(objective_id)
		objective_updated.emit(quest_id, objective_id)		
		
# Show/hide quest log
func show_hide_log():
	quest_ui.show_hide_log()
		
		
		
		
		
			
	
	
