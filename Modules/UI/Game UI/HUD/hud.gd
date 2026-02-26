extends Control
class_name HUD

@onready var time_juice: TextureProgressBar = $TimeJuice
@onready var new_notif_texture: TextureRect = $TimeJuice/NewNotif
@onready var time_label: Label = $Time
var notif_on_tab : Array[bool] = [false,false,false]

func _ready() -> void:
	globals.new_in_device.connect(new_notif)
	pass

func _process(_delta: float) -> void:
	time_juice.value = globals.time_juice
	if globals.time_manager:
		var cur_time: int = int(globals.time_manager.cur_time)
		time_label.text = "%02d:%02d" % [cur_time/60,int(cur_time)%60]
	pass

func new_notif(value : bool, tab : globals.Device_Tabs):
	var show : bool = false
	notif_on_tab[tab] = value
	print("checking ", notif_on_tab)
	for notif_tab in notif_on_tab:
		if notif_tab:
			show = true
	new_notif_texture.show() if show else new_notif_texture.hide()
