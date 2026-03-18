extends Area3D
class_name Interactable

@export var mesh: GeometryInstance3D = null
@export var interact_object: Node = null

var playing_invalid_animation: bool = false
var invalid_animation_info: Array = [0.2,0,3,0,false] #blink duration, blink timer, number of blinks, cur_blink, is highlighted

var is_targetted: bool = false

signal interacted_by(interactor)
signal anon_interacted

func _ready():
	mesh.set_layer_mask_value(2, true)


func targetted():
	is_targetted = true
	if mesh and not playing_invalid_animation:
		highlight()

func untargetted():
	is_targetted = false
	if mesh and not playing_invalid_animation:
		remove_highlight()

func highlight():
	#mesh.material_overlay = highlight_material
	pass

func remove_highlight():
	#mesh.material_overlay = outline_material
	pass

func interact(person:Node = null):
	interacted_by.emit(person)
	anon_interacted.emit()

#func _process(delta):
	#if playing_invalid_animation:
		#_process_invalid_interaction(delta)

#func _process_invalid_interaction(delta):
	#if invalid_animation_info[3] == invalid_animation_info[2]: #Done blinking
		#playing_invalid_animation = false
		#invalid_animation_info[1] = 0
		#invalid_animation_info[3] = 0
		#if is_targetted:
			#highlight()
		#else:
			#remove_highlight()
	#elif invalid_animation_info[1] >= invalid_animation_info[0]: #timer is up, change state
		#if invalid_animation_info[4]: #currently highlighted
			#invalid_animation_info[4] = false
			#invalid_animation_info[1] = 0
			#invalid_animation_info[3] += 1
			#mesh.material_overlay = null
		#else: #currently not highlighted
			#invalid_animation_info[4] = true
			#invalid_animation_info[1] = 0
			#mesh.material_overlay = invalid_outline_material
	#else:
		#invalid_animation_info[1] += delta
