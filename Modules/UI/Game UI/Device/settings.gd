extends MenuTabPanel

@onready var animation_player := $AnimationPlayer
@onready var settings := $HBoxContainer/SettingsVerticality

func _ready() -> void:
	settings.hide()

func _on_settings_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("settings_open")
	if not toggled_on:
		animation_player.play("settings_close")
		
func _on_resolution_options_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1600,900))
		1:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		2:
			DisplayServer.window_set_size(Vector2i(2560,1440))
		3:
			DisplayServer.window_set_size(Vector2i(3840,2160))
	pass # Replace with function body.
	
func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if not toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
