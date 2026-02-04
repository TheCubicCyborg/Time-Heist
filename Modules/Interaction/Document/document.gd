@tool
extends Node3D

class_name Document

const APPLE = preload("uid://2u7ypb7xpscs")

@export var document_info: DocumentInfo
@export var texture: Texture2D = null:
	set(value):
		$Sprite3D.texture = value
		texture = value

func interact():
	globals.ui_manager.document_viewer.display_document(document_info.document_id)
	globals.collect(document_info)
	#JUST TESTING:
	globals.emit_signal("collect_item", APPLE)
