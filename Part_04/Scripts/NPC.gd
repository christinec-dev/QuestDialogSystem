### NPC.gd

extends CharacterBody2D

@export var npc_id: String
@export var npc_name: String

func start_dialog():
	print("Hello player!")
