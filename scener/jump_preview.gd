extends Line2D

const stopline = true # Til potentiel fremtidig ændring. Lige nu bliver den dog som den er.

@onready var playercolmask = get_parent().collision_mask
@export_custom(PROPERTY_HINT_LAYERS_2D_PHYSICS, "") var collision_mask = PROPERTY_HINT_LAYERS_2D_PHYSICS

var grav = ProjectSettings.get_setting("physics/2d/default_gravity")

var dotGap = 0.1 # Hvor mange sekunders rejse der er mellem hver prik

var space_state

var globalpos

func make_points() -> void:
	var yvel = get_parent().chargedJumpPower
	var xvel = get_parent().chargedDirectionPower
	clear_points()
	for i in range(0, 40):
		add_point(Vector2(i * dotGap * xvel, 0.5*grav*(i*dotGap)*(i*dotGap) - yvel * (i * dotGap)))
		if (i < 2):
			pass
		elif stopline:
			var query = PhysicsRayQueryParameters2D.create(get_point_position(i - 1) + globalpos, get_point_position(i) + globalpos, collision_mask)
			if space_state.intersect_ray(query):
				remove_point(i)
				add_point(space_state.intersect_ray(query).position - globalpos) # Debugging point
				# print(get_point_count()) # Debug statement
				break
	queue_redraw()
func _draw() -> void:
	for i in range(get_point_count()):
		draw_circle(get_point_position(i), 2, Color.WHITE)
		if stopline and i == get_point_count() -1:
			draw_circle(get_point_position(i), 4, Color.GREEN)
		#if i == get_point_count() - 1:
			#draw_line(get_point_position(i - 1), get_point_position(i), Color.WHITE, 2) # Debug linje

func _physics_process(delta: float) -> void:
	globalpos = get_global_position()
	space_state = get_world_2d().direct_space_state
	if get_parent().charging and Globals.easyMode:
		make_points()
	else:
		clear_points()
		queue_redraw()
