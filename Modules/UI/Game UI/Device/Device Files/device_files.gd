extends MenuTabPanel
class_name DeviceFiles

#var documents : Array = [preload("res://Assets/UI/Time Travel Menu/Files_Test/person2.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person3.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person4.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person_1.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/place1.jpg")]
@onready var folder_buttons: VBoxContainer = $"MarginContainer/HBoxContainer/FoldersMargin/Folder Buttons"
@onready var folders: Control = $"MarginContainer/HBoxContainer/MidPanel/Folders"
var device_files_list : PackedScene = preload("res://Modules/UI/Game UI/Device/Device Files/device_files_list.tscn")

@onready var document_viewer := $MarginContainer/HBoxContainer/RightPanel/SubViewport/DeviceDocumentViewer

func _ready() -> void:
	#Add already owned documents
	for doc in global_inventory.documents:
		check_for_new_tags(doc)
		add_new_doc(doc)
	globals.added_doc.connect(update_doc_list)
		
	if folder_buttons.get_child_count() != 0:
		folder_buttons.get_child(0).grab_focus()
	
	#$MarginContainer/HBoxContainer/SubViewportContainer/SubViewport.size = $MarginContainer/HBoxContainer/SubViewportContainer.size
	
func view_panel(panel_to_view:DeviceFilesList):
	for folder in folders.get_children():
		folder.hide()
	
	panel_to_view.show()
	
func view_doc(doc_to_view:int):
	document_viewer.set_document_texture(doc_to_view)

func update_doc_list(doc : DocumentInfo):
	check_for_new_tags(doc)
	add_new_doc(doc)
	
#region populating documents
func add_new_doc(doc: DocumentInfo):
	for doc_tag in doc.relevant_tags:
		for folder in folders.get_children():
			if folder.tag == doc_tag:
				var doc_button = folder.add_doc(doc)
				doc_button.focus_entered.connect(view_doc.bind(doc.document_id))

func check_for_new_tags(doc: DocumentInfo):
	
	for tag in doc.relevant_tags:
		var found = false
		for button in folder_buttons.get_children():
			if button.text == tag:
				found = true
		if not found:
			add_new_folder(tag)
			
func add_new_folder(folder_name : String):
	#Edge case for when there are no folders
	if folders.get_child_count() == 0:
		$MarginContainer/HBoxContainer/MidPanel/NoDocuments.queue_free()
	
	#New folder button
	var new_folder_button = Button.new()
	folder_buttons.add_child(new_folder_button)
	new_folder_button.text = folder_name
	
	#New folder
	var new_folder = device_files_list.instantiate()
	new_folder.set_tag(folder_name)
	folders.add_child(new_folder)
	new_folder.name = folder_name + "Container"
	
	#Connect button
	new_folder_button.focus_entered.connect(view_panel.bind(new_folder))
	
	#Make the top one the first focused button
	main_focus = folder_buttons.get_child(0)
	
	return new_folder
	
#endregion
