extends Control
class_name EmailButton

@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var from: Label = $MarginContainer/VBoxContainer/From
@onready var desc: Label = $MarginContainer/VBoxContainer/Desc
@onready var new_mail: TextureRect = $NewMail

var viewed : bool = false:
	set(value):
		if value:
			viewed = value
			new_mail.hide()
			
			
var email_info : DocumentInfo

func set_email_info(doc : DocumentInfo):
	if not doc.is_email:
		push_error("Non email doc %d: %s in email app", [doc.document_id, doc.title])
	
	email_info = doc
	title.text = doc.email_heading
	from.text = "From: " + doc.email_from
	desc.text = doc.email_desc
	
func _on_focus_entered() -> void:
	if not viewed:
		viewed = true;
		globals.emit_signal("added_doc", email_info)
	#color_rect.color.a = 255
	pass # Replace with function body.
