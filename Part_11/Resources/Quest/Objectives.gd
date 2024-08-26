### Objectives.gd

extends Resource

class_name Objectives

@export var id: String
@export var description: String
@export var is_completed: bool = false
@export var target_id: String 
@export var target_type: String
@export var required_quantity: int = 1  # optional if collection
@export var collected_quantity: int = 0  # optional if collection
@export var objective_dialog: String = "" # optional if talk_to
