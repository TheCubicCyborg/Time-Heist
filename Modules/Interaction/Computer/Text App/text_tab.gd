extends TabContent

@export var convos : Array[TextConvo]
enum person {person0, person1}
@export var which_person : Array[person]

@onready var people: VBoxContainer = $HBoxContainer/People
@onready var chatlog: VBoxContainer = $HBoxContainer/ScrollContainer/Chatlog

var left_bubble := preload("res://Modules/Interaction/Computer/Text App/text_bubble_left.tscn")
var right_bubble := preload("res://Modules/Interaction/Computer/Text App/text_bubble_right.tscn")

func _ready() -> void:
	for convo in convos:
		var button_instance = Button.new()
		people.add_child(button_instance)
		button_instance.custom_minimum_size.y = 50
		var index = convos.find(convo)
		button_instance.text = convo.person0 if which_person[index] == 1 else convo.person1 # sets the person correctly
		button_instance.focus_entered.connect(view_panel.bind(convo))
	default_focus = people.get_child(0)

func view_panel(convo : TextConvo):
	for child in chatlog.get_children():
		child.queue_free()
	print("veiwing convo between ", convo.person0, " and ", convo.person1)
	var lines := convo.conversation.split("\n", false)
	for line in lines:
		if line.is_empty():
			continue
		var speaker_id := int(line[0])
		var message := line.substr(1).strip_edges()
		var index = convos.find(convo)
		var bubble = left_bubble if speaker_id != which_person[index] else right_bubble
		var bubble_instance = bubble.instantiate()
		chatlog.add_child(bubble_instance)
		bubble_instance.text(message)
