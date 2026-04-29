@tool
extends Node2D

@export var radius : float = 350
@export var width : float = 180
@export var gap_width : float = 10
@export var angle : float = 160
var angle_start_rad
var angle_end_rad
@export_range(2,100,1) var num_of_items : int = 3
@export_tool_button("Redraw","CanvasItem") var redraw = queue_redraw

func _ready() -> void:
	get_viewport().size_changed.connect(queue_redraw)
	queue_redraw()

func _draw() -> void:
	var arcs = calc_arcs()
	var center = Vector2(-450,-200)
	#for angle in arcs:
		#draw_arc(Vector2.ZERO,radius,angle[0], angle[1],100,Color(0.043, 0.376, 0.71, 0.659),width,true)
	
	draw_arc(center, radius, angle_start_rad,angle_end_rad,100,Color(0.23, 0.377, 0.82, 0.694),width,true)
	var step = angle/num_of_items

	for i in range(num_of_items+1):
		print(step)
		var rads = deg_to_rad(rad_to_deg(angle_start_rad) + (i * step))
		var point = Vector2.from_angle(rads)
		draw_line(
			point * (radius - width/2) + center,
			point * (radius + width/2) + center,
			Color(0.997, 0.812, 0.892, 1.0),
			gap_width,
			true
		)
		
func calc_arcs():
	angle_start_rad = - TAU/4 - deg_to_rad(angle/2)
	angle_end_rad = - TAU/4 + deg_to_rad(angle/2)
	print(angle_start_rad)
	print(rad_to_deg(angle_end_rad))
	var current_angle = angle_start_rad
	
	var arcs : Array[Vector2]
	var new_angle = angle - ((num_of_items-1)*gap_width)
	var step_rad = deg_to_rad(new_angle/num_of_items)
	print("STEP ", step_rad)
	for i in range(num_of_items):
		arcs.append(Vector2(current_angle,current_angle+step_rad))
		current_angle += (step_rad + deg_to_rad(gap_width))
	print(arcs)
	return arcs
	

func _process(_delta: float) -> void:
	pass
