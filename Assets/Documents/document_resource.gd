extends Resource
class_name DocumentInfo

@export var document_id : int

@export var title : String
@export var document_image : Texture

@export var relevant_tags : Array[String] = ["Uncategorized"]: #Person, Place, etc.
	set(value):
		relevant_tags = value if not value.is_empty() else ["Uncategorized"]

func _notification(what):
	if what == NOTIFICATION_POSTINITIALIZE:
		if relevant_tags.is_empty():
			relevant_tags.append("Uncategorized")

func _print():
	print("_____________________")
	print("Document ", document_id)
	print(title)
	print("Relevant Tags: ")
	for tag in relevant_tags:
		print(tag)
	print("_____________________")
