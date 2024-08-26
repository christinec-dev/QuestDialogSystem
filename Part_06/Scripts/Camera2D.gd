### Camera2D

extends Camera2D

var last_mouse_position = null
var dragging = false

func _input(event):
	if event.is_action_pressed("ui_middle_click"):
		dragging = true
		last_mouse_position = get_global_mouse_position()

	if event.is_action_released("ui_middle_click"):
		dragging = false

	if dragging and last_mouse_position:
		var current_mouse_position = get_global_mouse_position()
		var drag_vector = last_mouse_position - current_mouse_position
		position += drag_vector
		last_mouse_position = current_mouse_position
