extends Control

class_name DocumentViewer

@onready var doc_texture = $DocTexture
var doc_table:Array[Texture2D] = preload("res://Modules/UI/Game UI/DocumentViewer/DocumentTable.tres").doc_table
var is_displaying: bool = false

func display_document(doc_id: int):
	is_displaying = true
	doc_texture.texture = doc_table[doc_id]
	doc_texture.process_mode = Node.PROCESS_MODE_INHERIT

func hide_document():
	is_displaying = false
	doc_texture.texture = null
	doc_texture.process_mode = Node.PROCESS_MODE_DISABLED
