### QuestItem.gd
@tool
extends StaticBody2D

# Vars
@export var item_id: String = ""
@export var item_quantity: int = 1
@export var item_icon = Texture2D
@onready var sprite_2d = $Sprite2D

func _ready():
	# Shows texture in game
	if not Engine.is_editor_hint():
		sprite_2d.set_texture(item_icon)
		
func _process(_delta):
	# Shows texture in editor
	if Engine.is_editor_hint():
		sprite_2d.set_texture(item_icon)
