extends UI
class_name DocumentViewer

@onready var doc_texture : TextureRect = $DocTexture

func display_document(doc_id: int):
	doc_texture.texture = document_database.get_document(doc_id).document_image
	open()
