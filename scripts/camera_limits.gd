#CameraLimits sætter grænserne for, hvor langt op, ned og til siden, kameraet må bevæge sig i et level
#Zoom-export variablen gør også, at vi kan ændre mængden af zoom fra level tl level
#Dette script findes for at loade previewet af zoomet (altså den blå firkant)

# @tool fortæller editoren, at dette script primært findes som værktøj til os developers
@tool
extends ReferenceRect

enum cameraMode { # Dikterer, hvordan kameraet opfører sig
	following_player, ##Kameraet følger spilleren
	non_moving ## Kameraet bliver, hvor det er
}

@export var camera_mode: cameraMode = cameraMode.following_player ## Bestemmer om kameraet følger spilleren eller bliver ét sted

@export var zoom: float = 1.0: ## Hvor meget kameraet er zoomet ind. 2 betyder, at ting er dobbelt så store, etc.
	set(value): # Denne kode kører, hver gang, man ændrer værdien af zoom
		zoom = value
		queue_redraw()
			

@export_group("Boundary Preview") ## Indstillinger for den røde firkant, der viser boundaries i editoren.

@export var enable_boundary_preview: bool = true: ## Hvis sat til [param false] vil den røde firkant forsvinde, når den ikke er valgt
	set(value):
		if value:
			border_width = 0
		else:
			border_width = boundary_width
		enable_boundary_preview = value
		queue_redraw()

## Rent kosmetisk. Ændrer intet gameplay-mæssigt. Er det samme som [param border_width] lidt længere nede. Ik pil ved den, kun pil ved denne her.
@export var boundary_width: float = 1:
	set(value):
		border_width = value
		boundary_width = value
		queue_redraw()

## Rent kosmetisk. Ændrer intet gameplay-mæssigt. Er det samme som [param border_color] længere nede. Nix pille ved den, fy skamme.
@export var boundary_color: Color = Color.RED:
	set(value):
		border_color = value
		boundary_color = value
		queue_redraw()

@export_group("Preview Preview") ## Indstillinger for den blå firkant, der viser "størrelsen" af kameraet i editoren

@export var enable_preview: bool = true: ## Hvis sat til [param false], kan man ikke se den blå rektangel.
	set(value):
		enable_preview = value
		queue_redraw()

@export var preview_width: float = 3: ## Tykkelsen af preview-firkanten
	set(value):
		preview_width = value
		queue_redraw()

@export var preview_color: Color = Color.BLUE: ## Farven af preview-firkanten
	set(value):
		queue_redraw()
		preview_color = value



@export_category("Following Player")

@export var enable_boundaries: bool = true: ## Hvis sat til false, kan kameraet gå hen hvorend det vil. Hvis denne er sat til true, kan kameraet ikke gå ud over den røde firkant.
	set(value):
		if value && camera_mode == cameraMode.following_player:
			border_width = boundary_width
		else:
			border_width = 0
		enable_boundaries = value
		queue_redraw()

@export_category("Non Moving")
## Denne benyttes af kameraet i selve spillet, hvis [param camera_mode] er sat til [param Non Moving].
## Ændrer uanset hvad positionen på den blå rektangel i editoren, så man ved, hvad man laver
@export var offset: Vector2 = Vector2.ZERO:
	set(value):
		offset = value
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint(): # Kører kun koden, hvis vi er i editoren (der skal ikke være en blå zoom-firkant i spillet)
		var playerPos: Vector2 = get_parent().get_node("Player").position
		
		if enable_preview:
			draw_rect(Rect2(offset.x + playerPos.x - position.x - 640 / 2 / zoom, offset.y + playerPos.y - position.y - 360 / 2 / zoom, 640/zoom, 360/zoom), preview_color, false, preview_width) # Tegner den blå rektangel
