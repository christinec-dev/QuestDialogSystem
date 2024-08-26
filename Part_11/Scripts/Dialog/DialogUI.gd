### DialogUI.gd

extends Control

# Node Refs
@onready var panel = $CanvasLayer/Panel
@onready var dialog_speaker = $CanvasLayer/Panel/DialogBox/DialogSpeaker
@onready var dialog_text = $CanvasLayer/Panel/DialogBox/DialogText
@onready var dialog_options = $CanvasLayer/Panel/DialogBox/DialogOptions

func _ready():
	panel.visible = false

# Shows Dialog
func show_dialog(speaker, text, options):
	panel.visible = true
	dialog_speaker.text = speaker
	dialog_text.text = text
	
	for child in dialog_options.get_children():
		dialog_options.remove_child(child)
	
	for option in options.keys():
		var button = Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 20)
		button.pressed.connect(_on_option_selected.bind(option))
		dialog_options.add_child(button)

# Hides Dialog
func hide_dialog():
	Global.player.can_move = true
	panel.visible = false

# Handle option selection
func _on_option_selected(option):
	get_parent().handle_dialog_choice(option)

# Handle close button press
func _on_close_button_pressed():
	hide_dialog()
