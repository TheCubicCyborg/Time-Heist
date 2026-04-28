@tool
extends Control

@export var radius : float = 350
@export var width : float = 180
@export var angle : float = 160:
	set(value):
		angle = value
		angle_start_rad = deg_to_rad(angle/2) - TAU/4
		angle_end_rad = deg_to_rad(-angle/2) - TAU/4
var angle_start_rad
var angle_end_rad
var angle_rad := deg_to_rad(angle)
@export_range(2,100,1) var num_of_items : int = 3
@export var redraw : bool:
	set(value):
		queue_redraw()
		redraw = false

func _draw() -> void:
	angle_rad = deg_to_rad(angle)
	draw_arc(Vector2.ZERO,radius,angle_start_rad, angle_end_rad,100,Color(0.042, 0.37, 0.708, 1.0),width,true)
	
	var step = angle_rad/num_of_items
	for i in range(num_of_items):
		var rads = (i * step) + angle_start_rad
		var point = Vector2.from_angle(rads)
		draw_line(
			point * (radius - width/2),
			point * (radius + width/2),
			Color(0.997, 0.812, 0.892, 1.0),
			10,
			true
		)
	
func _process(_delta: float) -> void:
	queue_redraw()
