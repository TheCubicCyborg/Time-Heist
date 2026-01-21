extends UI

@onready var desktop: TextureRect = $Desktop
@onready var icons: Control = $Icons
@export var desktop_image : Texture
@onready var tabs: Control = $Tabs
var computer_tab: PackedScene = preload("res://Modules/Interaction/Computer/computer_tab.tscn")


const MOUSE_SPEED := 450.0

func _ready() -> void:
	Input.set_custom_mouse_cursor(globals.normal_cursor,Input.CURSOR_ARROW)
	
	desktop.texture = desktop_image
	pass

func _physics_process(delta: float) -> void:
	var cursor_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#get_viewport().warp_mouse(get_global_mouse_position() + cursor_input*MOUSE_SPEED*delta)
