extends MarginContainer

signal _input_button
signal _input_motion
signal _spawn_create
signal _spawn_cancel

var mouse_over_gui = false

func _ready():
	set_over_gui_text()
	set_translation_options()

func _input(event):
	if event is InputEventMouseButton && !mouse_over_gui:
		emit_signal('_input_button', event)
	elif event is InputEventMouseMotion:
		emit_signal('_input_motion', event)
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_spawn_select_type(spawn_type):
	emit_signal('_spawn_create', spawn_type)
	set_selected_spawn_text(spawn_type)

func _on_spawn_cancel():
	emit_signal('_spawn_cancel')
	set_selected_spawn_text(null)

func _on_gui_mouse_entered():
	mouse_over_gui = true
	set_over_gui_text()

func _on_gui_mouse_exited():
	mouse_over_gui = false
	set_over_gui_text()
	
# ------------------------------------ #
# REMOVE ALL THESE FUNCTION IN THE END #
# ------------------------------------ #

func set_selected_spawn_text(spawn_type):
	if spawn_type:
		$VBoxContainer/Spawner/SpawnLabel.text = spawn_type
	else:
		$VBoxContainer/Spawner/SpawnLabel.text = ''
	
func set_over_gui_text():
	$VBoxContainer/HBoxContainer/HBoxContainer/OverGUILabel.text = 'Mouse over GUI: ' + str(mouse_over_gui)

func set_translation_options():
	$VBoxContainer/HBoxContainer/LocalizationOptionButton.add_item('en')
	$VBoxContainer/HBoxContainer/LocalizationOptionButton.add_item('es')
	$VBoxContainer/HBoxContainer/LocalizationOptionButton.add_item('ja')
	
	_set_localization()

func _set_localization(idx=0):
	var localization = $VBoxContainer/HBoxContainer/LocalizationOptionButton.get_item_text(idx)
	TranslationServer.set_locale(localization)
	
	$VBoxContainer/HBoxContainer/VBoxContainer/GreetLabel.set_text(tr('GREET'))
	$VBoxContainer/HBoxContainer/VBoxContainer/AskLabel.set_text(tr('ASK'))
