### Player.gd

extends CharacterBody2D

# Scene-Tree Node references
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D

# Variables
@export var speed = 100

func _ready():
	Global.player = self
	
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
