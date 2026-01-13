extends Resource
class_name DocumentInfo

@export var document_id : int

@export var title : String
@export var document_image : Texture

@export var relevant_tags : Array[String] #Person, Place, etc.

func _print():
	print("_____________________")
	print("Document ", document_id)
	print(title)
	print("Relevant Tags: ")
	for tag in relevant_tags:
		print(tag)
	print("_____________________")
