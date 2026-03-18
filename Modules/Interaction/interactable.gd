extends Area3D
class_name Interactable

@export var mesh: GeometryInstance3D = null
@export var interact_object: Node = null

var playing_invalid_animation: bool = false
var invalid_animation_info: Array = [0.2,0,3,0,false] #blink duration, blink timer, number of blinks, cur_blink, is highlighted

var is_targetted: bool = false

signal interacted_by(interactor)
signal anon_interacted

enum OutlineState { DEFAULT, TARGETED, DISABLED }

@export var default_state: OutlineState
 
func set_outline_state(state: OutlineState) -> void:
	mesh.set_layer_mask_value(2, state == OutlineState.DEFAULT)
	# Layer 3 = bit 4 (1 << 2)
	mesh.set_layer_mask_value(3, state == OutlineState.TARGETED)
	# Layer 4 = bit 8 (1 << 3)
	mesh.set_layer_mask_value(4, state == OutlineState.DISABLED)


var _sprite_outline_mesh: MeshInstance3D

func _ready() -> void:
	if mesh is Sprite3D:
		call_deferred("_setup_sprite3d_outline")
	else:
		set_outline_state(default_state)

func _setup_sprite3d_outline() -> void:
	var sprite := mesh as Sprite3D
	if not sprite.texture:
		return
	
	var quad := MeshInstance3D.new()
	var quad_mesh := QuadMesh.new()
	quad_mesh.size = sprite.pixel_size * Vector2(
		sprite.texture.get_width(),
		sprite.texture.get_height()
	)
	
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://Modules/Interaction/Outlines/sprite_outline_mask.gdshader")
	mat.set_shader_parameter("texture_albedo", sprite.texture)
	mat.set_shader_parameter("alpha_threshold", 0.1)
	quad.material_override = mat
	
	quad.mesh = quad_mesh
	quad.rotation_degrees.y = 180.0
	quad.set_layer_mask_value(1, false)
	quad.set_layer_mask_value(2, true)
	mesh.add_child(quad)
	_sprite_outline_mesh = quad

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
