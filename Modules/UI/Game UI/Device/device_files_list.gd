extends ScrollContainer
class_name DeviceFilesList

@onready var files: VBoxContainer = $Files

var tag: String
var documents: Array[DocumentInfo]

func set_tag(_tag: String) -> void:
	tag = _tag
	pass
	
func add_doc(doc: DocumentInfo) -> Button:
	#Add button
	var doc_button = Button.new()
	files.add_child(doc_button)
	
	doc_button.text = doc.title
	documents.append(doc)
	
	return doc_button
	
