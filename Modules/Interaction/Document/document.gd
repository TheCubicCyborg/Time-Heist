extends Node3D

class_name Document

var document_id: int = 0

func interact():
	globals.ui_manager.document_viewer.display_document(document_id)
