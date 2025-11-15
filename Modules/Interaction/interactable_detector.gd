extends Area3D

@export var detection_range: float = 1
@export var rotation_body: Node3D = null #The raycast will rotate with this body
@export var collider_size: Vector3 = Vector3(1,1,1)

@export var targetted:Interactable = null

func _physics_process(_delta):
	if PlayerInput.is_action_just_pressed("player_interact") and targetted:
		targetted.interact()


func update_targeted():
	var in_range_areas = get_overlapping_areas()
	var closest_area:Interactable = null
	var closest_distance = collider_size.z + 0.3
	for area in in_range_areas:
		var distance_from_player = area.position.distance_to(get_parent_node_3d().position)
		if distance_from_player < closest_distance:
			closest_distance = distance_from_player
			closest_area = area
	if targetted:
		targetted.untargetted()
	targetted = closest_area
	if targetted:
		targetted.targetted()


func _on_area_entered(_area):
	update_targeted()
func _on_area_exited(_area):
	update_targeted()
