extends Control
class_name HUD

@onready var time_juice: TextureProgressBar = $TimeJuice
@onready var new_notif_texture: TextureRect = $TimeJuice/NewNotif
var notif_on_tab : Array[bool] = [false,false,false]

func _ready() -> void:
	globals.new_in_device.connect(new_notif)
	pass

func _process(delta: float) -> void:
	time_juice.value = globals.time_juice
	pass

func new_notif(value : bool, tab : globals.Device_Tabs):
	var show : bool = false
	notif_on_tab[tab] = value
	print("checking ", notif_on_tab)
	for notif_tab in notif_on_tab:
		if notif_tab:
			show = true
	new_notif_texture.show() if show else new_notif_texture.hide()
