@tool
extends Node3D

class_name Document

@export var document_id: int = 0
@export var texture: Texture2D = null:
	set(value):
		$Sprite3D.texture = value
		texture = value

func interact():
	globals.ui_manager.document_viewer.display_document(document_id)
