extends TabContent

@export var file : DocumentInfo
@onready var file_viewer: TextureRect = $FileViewer

func _ready() -> void:
	file_viewer.texture = file.document_image

func open_process():
	super.open_process()
	globals.emit_signal("added_doc",file)
