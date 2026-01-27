extends UI
class_name DesktopTab

@onready var panel: Panel = $VBoxContainer/Panel
@onready var bar: ColorRect = $VBoxContainer/Bar

@export var content : Control #make a tabcontent class

var dragging : bool = false
var offset : Vector2

func _ready() -> void:
	hide()
	content.reparent(panel)
	pass

#region dragging
func _physics_process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - offset

func _on_drag_pressed():
	dragging = true
	offset = get_global_mouse_position() - global_position

func _on_drag_button_up() -> void:
	dragging = false
#endregion

func _on_close_pressed() -> void:
	hide()
