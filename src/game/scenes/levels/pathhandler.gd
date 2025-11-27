extends Node2D

##Handles drawing a visible path using a navigationMesh's NavPolygons

@export var nav_polygon: NavigationPolygon
@export var polygon_z_index: int = 0

@export var path_color: Color

func _ready() -> void:
	#path visuals is included in background asset, no need to draw again
	#draw_path()
	pass

func draw_path() -> void:
	if nav_polygon == null: #if no polygons, don't continue
		return

	#draws the outline using the provided nav_polygon
	var outline_count = nav_polygon.get_outline_count() #how many points
	for i in range(outline_count): #loop through for each point
		var outline = nav_polygon.get_outline(i)
		if outline.size() == 0:
			continue
		var poly = Polygon2D.new() #create a new Polygon2D
		poly.polygon = outline.duplicate() #apply the previously drawn outline
		poly.z_index = polygon_z_index
		poly.color = path_color #add path color
		add_child(poly)
