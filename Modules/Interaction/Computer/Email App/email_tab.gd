extends Control

@export var emails : Array[DocumentInfo]
@onready var email_buttons: VBoxContainer = $HBoxContainer/EmailButtons
@onready var email_resizer: Control = $HBoxContainer/ScrollContainer/EmailResizer
@onready var email_viewer: TextureRect = $HBoxContainer/ScrollContainer/EmailResizer/EmailViewer

const EmailButtonScene = preload("res://Modules/Interaction/Computer/Email App/email_button.tscn")

#const email_format = "[font_size=16][b]%s[/b]\nFrom: %s[/font_size]\n%s"

func _ready() -> void:
	for document in emails:
		var button_instance = EmailButtonScene.instantiate()
		email_buttons.add_child(button_instance)
		button_instance.set_email_info(document)
		button_instance.focus_entered.connect(view_panel.bind(document))

func view_panel(document: DocumentInfo):
	print("veiwing: ", document.title)
	email_viewer.texture = document.document_image
	#email_resizer.custom_minimum_size.y = email_viewer.texture.get_size().y
	#print(email_viewer.texture.get_size().y)
	#print(email_resizer.custom_minimum_size.y)
