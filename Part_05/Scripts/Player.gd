### Player.gd

extends CharacterBody2D

# Scene-Tree Node references
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var amount = $HUD/Coins/Amount
@onready var quest_tracker = $HUD/QuestTracker
@onready var title = $HUD/QuestTracker/Details/Title
@onready var objectives = $HUD/QuestTracker/Details/Objectives

# Variables
@export var speed = 100
var can_move = true

func _ready():
	Global.player = self
	quest_tracker.visible = false
	
# Input for movement
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
	# Turn raycast towards movement direction
	if velocity != Vector2.ZERO:
		ray_cast_2d.target_position = velocity.normalized() * 50

# Movement & Animation
func _physics_process(delta):
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
					print("I'm talking to an NPC!")
					# todo: set can_move to false
					target.start_dialog()
				elif target.is_in_group("Item"):
					print("I'm interacting with an item!")
					# todo: check if item is needed for quest
					# todo: remove item
					target.start_interact()	
					
						
	
	
	
	
	
	
