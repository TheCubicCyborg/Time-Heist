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

var default_state: OutlineState = OutlineState.DEFAULT
 
func set_outline_state(state: OutlineState) -> void:
	mesh.set_layer_mask_value(2, state == OutlineState.DEFAULT)
	# Layer 3 = bit 4 (1 << 2)
	mesh.set_layer_mask_value(3, state == OutlineState.TARGETED)
	# Layer 4 = bit 8 (1 << 3)
	mesh.set_layer_mask_value(4, state == OutlineState.DISABLED)

func _ready() -> void:
	if mesh is Sprite3D:
		call_deferred("_setup_sprite3d_outline")
	elif mesh:
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
	mesh.add_child(quad)
	mesh = quad
	set_outline_state(default_state)

func targetted():
	#print("targetted")
	is_targetted = true
	if mesh and not playing_invalid_animation:
		highlight()

func untargetted():
	#print("untargetted")
	is_targetted = false
	if mesh and not playing_invalid_animation:
		remove_highlight()

func highlight():
	set_outline_state(OutlineState.TARGETED)

func remove_highlight():
	set_outline_state(OutlineState.DEFAULT)

func interact(person:Node = null):
	interacted_by.emit(person)
	anon_interacted.emit()
