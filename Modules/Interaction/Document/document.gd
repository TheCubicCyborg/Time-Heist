@tool
extends Node3D

class_name Document

@export var document_info: DocumentInfo
@export var texture: Texture2D = null:
	set(value):
		$Sprite3D.texture = value
		texture = value

func interact():
	globals.ui_manager.document_viewer.display_document(document_info.document_id)
	globals.emit_signal("added_doc", document_info)
