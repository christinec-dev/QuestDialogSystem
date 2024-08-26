### Quests.gd

extends Resource

class_name Quest

@export var quest_id: String
@export var quest_name: String
@export var quest_description: String
@export var state: String = "not_started"
@export var unlock_id: String
@export var objectives: Array[Objectives] = []
@export var rewards: Array[Rewards] = []

# Checks objectives state
func is_completed() -> bool:
	for objective in objectives:
		if not objective.is_completed:
			return false			
	return true

# Updates quest state
func complete_objective(objective_id: String, quantity: int = 1):
	for objective in objectives:
		if objective.id == objective_id:
			# collection objective
			if objective.target_type == "collection":
				objective.collected_quantity += quantity
				if objective.collected_quantity >= objective.required_quantity:
					objective.is_completed = true
			# talk to objective.
			elif objective.target_type == "talk_to":
				objective.is_completed = true
			break
	
	# If all objectives complete, mark quest as complete
	if is_completed():
		state = "completed"
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
