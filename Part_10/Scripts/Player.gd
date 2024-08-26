### Player.gd

extends CharacterBody2D

# Scene-Tree Node references
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var amount = $HUD/Coins/Amount
@onready var quest_tracker = $HUD/QuestTracker
@onready var title = $HUD/QuestTracker/Details/Title
@onready var objectives = $HUD/QuestTracker/Details/Objectives
@onready var quest_manager = $QuestManager

# Variables
@export var speed = 100
var can_move = true

# Dialog & Quest vars
var selected_quest: Quest = null
var coin_amount  = 0

func _ready():
	Global.player = self
	quest_tracker.visible = false
	update_coins()
	
	# Signal connections
	quest_manager.quest_updated.connect(_on_quest_updated)
	quest_manager.objective_updated.connect(_on_objective_updated)
	
# Input for movement
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
	# Turn raycast towards movement direction
	if velocity != Vector2.ZERO:
		ray_cast_2d.target_position = velocity.normalized() * 50

# Movement & Animation
func _physics_process(delta):
	if can_move:
		get_input()
		move_and_slide()
		update_animation()
	
# Animation
func update_animation():
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite.play("walk_right")
			else:
				animated_sprite.play("walk_left")
		else:
			if velocity.y > 0:
				animated_sprite.play("walk_down")  
			else:
				animated_sprite.play("walk_up")

func _input(event):
	#Interact with NPC/ Quest Item
	if can_move:
		if event.is_action_pressed("ui_interact"):
			var target = ray_cast_2d.get_collider()
			if target != null:
				if target.is_in_group("NPC"):
					can_move = false
					target.start_dialog()
					check_quest_objectives(target.npc_id, "talk_to")
				elif target.is_in_group("Item"):
					if is_item_needed(target.item_id):
						check_quest_objectives(target.item_id, "collection", target.item_quantity)
						target.queue_free()
					else: 
						print("Item not needed for any active quest.")
	# Open/close quest log
		if event.is_action_pressed("ui_quest_menu"):
			quest_manager.show_hide_log()
					
# Check if quest item is needed
func is_item_needed(item_id: String) -> bool:
	if selected_quest != null:
		for objective in selected_quest.objectives:
			if objective.target_id == item_id and objective.target_type == "collection" and not objective.is_completed:
				return true				
	return false
	
func check_quest_objectives(target_id: String, target_type: String, quantity: int = 1):
	if selected_quest == null:
		return
	
	# Update objectives
	var objective_updated = false
	for objective in selected_quest.objectives:
		if objective.target_id == target_id and objective.target_type == target_type and not objective.is_completed:
			print("Completing objective for quest: ", selected_quest.quest_name)
			selected_quest.complete_objective(objective.id, quantity)
			objective_updated = true
			break
	
	# Provide rewards
	if objective_updated:
		if selected_quest.is_completed():
			handle_quest_completion(selected_quest)
	
		# Update UI
		update_quest_tracker(selected_quest)
	
# Player rewards
func handle_quest_completion(quest: Quest):
	for reward in quest.rewards:
		if reward.reward_type == "coins":
			coin_amount += reward.reward_amount
			update_coins()
	update_quest_tracker(quest)
	quest_manager.update_quest(quest.quest_id, "completed")
	
# Update coin UI
func update_coins():
	amount.text = str(coin_amount)
	
# Update tracker UI
func update_quest_tracker(quest: Quest):
	# if we have an active quest, populate tracker
	if quest:
		quest_tracker.visible = true
		title.text = quest.quest_name	
		
		for child in objectives.get_children():
			objectives.remove_child(child)
			
		for objective in quest.objectives:
			var label = Label.new()
			label.text = objective.description
			
			if objective.is_completed:
				label.add_theme_color_override("font_color", Color(0, 1, 0))
			else:
				label.add_theme_color_override("font_color", Color(1,0, 0))
				
			objectives.add_child(label)
	# no active quest, hide tracker		
	else:
		quest_tracker.visible = false

# Update tracker if quest is complete
func _on_quest_updated(quest_id: String):
	var quest = quest_manager.get_quest(quest_id)
	if quest == selected_quest:
		update_quest_tracker(quest)
	selected_quest = null
	
# Update tracker if objective is complete
func _on_objective_updated(quest_id: String, objective_id: String):
	if selected_quest and selected_quest.quest_id == quest_id:
		update_quest_tracker(selected_quest)
	selected_quest = null
	
	
	
	
	
	
	
