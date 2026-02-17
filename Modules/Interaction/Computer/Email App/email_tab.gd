extends TabContent

@export var emails : Array[DocumentInfo]
var email_button_instances : Array[EmailButton] : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"email_button_instances",email_button_instances,value)
		email_button_instances = value
@onready var email_buttons: VBoxContainer = $HBoxContainer/EmailButtons
@onready var email_resizer: Control = $HBoxContainer/ScrollContainer/EmailResizer
@onready var email_viewer: TextureRect = $HBoxContainer/ScrollContainer/EmailResizer/EmailViewer
@onready var scroll_container: ScrollContainer = $HBoxContainer/ScrollContainer

const EmailButtonScene = preload("res://Modules/Interaction/Computer/Email App/email_button.tscn")
var time_manager : TimeManager
var next_document_to_add : int : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"next_document_to_add",next_document_to_add,value)
		next_document_to_add = value
var next_time : float : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"next_time",next_time,value)
		next_time = value
var first_time : bool = true
var finished : bool = false

func _ready() -> void:
	if emails.size() == 0:
		push_error("No emails in this email tab!")
		assert(false)
	emails.sort_custom(custom_email_sort) #sorts them based on time
	add_emails()
	next_document_to_add = 0
	next_time = emails[0].email_time
	print(emails)
	print(next_time)
	
	time_manager = globals.time_manager
	
func _process(delta: float) -> void:
	print("next: ", next_time, " current: ", time_manager.cur_time)
	if next_time <= time_manager.cur_time and not finished: #also checks to see if we are in the last email
		emails[next_document_to_add].sent = true
		update_emails()

func view_panel(document: DocumentInfo):
	print("viewing: ", document.title)
	email_viewer.texture = document.document_image
	scroll_container.scroll_vertical = 0
	
func add_emails():
	print("adding emails for ready")
	for email in emails:
		var button_instance = EmailButtonScene.instantiate()
		email_buttons.add_child(button_instance)
		email_buttons.move_child(button_instance, 0) # moves to the top
		print(button_instance)
		button_instance.set_email_info(email)
		button_instance.focus_entered.connect(view_panel.bind(email))
		button_instance.hide()
		email_button_instances.push_front(button_instance)

func update_emails():
	for i in_range:
		if email.email_time <= time_manager.cur_time:
			email_button_instances[].sent = true
			email_button_instances = email_button_instances
			#checks if finished
			if i == emails.size()-1:
				finished = true
		else:
			next_document_to_add = i
			next_time = emails[i].email_time
			
		
	#email_button_instances[next_document_to_add].show()
	#emails[next_document_to_add].sent = true
	#email_button_instances = email_button_instances
	#next_document_to_add += 1
	#if next_document_to_add == emails.size(): #last one
		#finished = true
		#return
	#next_time = emails[next_document_to_add].email_time
	#for i in range(next_document_to_add, emails.size()):
		#if emails[i].email_time <= time_manager.cur_time: #kinda a redundent check
			#print("adding ", emails[i])
			#if first_time:
				#set_defaults()
				#first_time = false
			#var button_instance = EmailButtonScene.instantiate()
			#email_buttons.add_child(button_instance)
			#email_buttons.move_child(button_instance, 0) # moves to the top
			#button_instance.set_email_info(emails[i])
			#button_instance.focus_entered.connect(view_panel.bind(emails[i]))
			#
			##checks if finished
			#if i == emails.size()-1:
				#finished = true
		#else: #the first time it doesnt pass
			#next_document_to_add = i
			#next_time = emails[i].email_time
	pass

func custom_email_sort(a : DocumentInfo, b : DocumentInfo):
	if not a.email_time:
		a.email_time = 0.0
	if not b.email_time:
		b.email_time = 0.0
	return a.email_time < b.email_time
	
func set_defaults():
	print(email_buttons.get_child(0))
	default_focus = email_buttons.get_child(0)
