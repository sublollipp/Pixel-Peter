extends Line2D

@onready var playercolmask = get_parent().collision_mask
@export_custom(PROPERTY_HINT_LAYERS_2D_PHYSICS, "") var collision_mask = PROPERTY_HINT_LAYERS_2D_PHYSICS

var grav = ProjectSettings.get_setting("physics/2d/default_gravity")

var dotGap = 0.1 # Hvor mange sekunders rejse der er mellem hver prik

var space_state

func make_points() -> void:
	var yvel = get_parent().chargedJumpPower
	var xvel = get_parent().chargedDirectionPower
	clear_points()
	for i in range(0, 20):
		add_point(Vector2(i * dotGap * xvel, 0.5*grav*(i*dotGap)*(i*dotGap) - yvel * (i * dotGap)))
	queue_redraw()
func _draw() -> void:
	for i in range(get_point_count()):
		draw_circle(get_point_position(i), 2, Color.WHITE)

func _physics_process(delta: float) -> void:
	if get_parent().charging:
		make_points()
	else:
		clear_points()
		queue_redraw()
