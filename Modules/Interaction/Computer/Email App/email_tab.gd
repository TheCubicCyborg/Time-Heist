extends TabContent

@export var emails : Array[DocumentInfo]
@onready var email_buttons: VBoxContainer = $HBoxContainer/EmailButtons
@onready var email_resizer: Control = $HBoxContainer/ScrollContainer/EmailResizer
@onready var email_viewer: TextureRect = $HBoxContainer/ScrollContainer/EmailResizer/EmailViewer
@onready var scroll_container: ScrollContainer = $HBoxContainer/ScrollContainer

const EmailButtonScene = preload("res://Modules/Interaction/Computer/Email App/email_button.tscn")

func _ready() -> void:
	for document in emails:
		var button_instance = EmailButtonScene.instantiate()
		email_buttons.add_child(button_instance)
		button_instance.set_email_info(document)
		button_instance.focus_entered.connect(view_panel.bind(document))
	print(email_buttons.get_child(0))
	default_focus = email_buttons.get_child(0)

func view_panel(document: DocumentInfo):
	print("veiwing: ", document.title)
	email_viewer.texture = document.document_image
	scroll_container.scroll_vertical = 0
