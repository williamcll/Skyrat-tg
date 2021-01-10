/obj/effect/abstract/overmap
	glide_size = 100
	var/datum/overmap_object/my_overmap_object

/obj/effect/abstract/overmap/relaymove(mob/living/user, direction)
	my_overmap_object.relaymove(user, direction)

/datum/overmap_sun_system
	var/name = "Alpha"
	var/x = 0
	var/y = 0
	var/list/overmap_objects = list()
	var/datum/space_level/my_space_level
	var/z_level = 0 //Easier lookup

/datum/overmap_sun_system/proc/GetObjectsInRadius(_x,_y,rad)
	. = list()
	for(var/i in overmap_objects)
		var/datum/overmap_object/OO = i
		if(OO.x <= _x + rad && OO.x >= _x - rad && OO.y <= _y + rad && OO.y >= _y - rad)
			. += OO

/datum/overmap_sun_system/New()
	SSmapping.add_new_zlevel("Sun system [name]", list(ZTRAIT_LINKAGE = UNAFFECTED))
	z_level = world.maxz

/datum/overmap_object
	var/name = "Overmap object"
	var/x = 0
	var/y = 0
	var/datum/overmap_sun_system/current_system
	var/make_visual = TRUE
	var/icon = 'icons/obj/items_and_weapons.dmi'
	var/icon_state = "soap"
	var/obj/effect/abstract/overmap/my_visual
	var/visual_x_offset = 0
	var/visual_y_offset = 0

	var/list/related_levels = list()

/datum/overmap_object/proc/relaymove(mob/living/user, direction)
	return

/datum/overmap_object/proc/update_visual_position()
	if(my_visual)
		my_visual.x = x
		my_visual.y = y

/datum/overmap_object/process(delta_time)
	return

/datum/overmap_object/shuttle
	name = "Shuttle"
	icon = 'modular_skyrat/modules/overmap/icons/shuttle.dmi'
	icon_state = "shuttle"
	var/obj/docking_port/mobile/my_shuttle = null
	var/do_move = FALSE
	var/destination_x = 0
	var/destination_y = 0
	var/angle = 0
	var/engine_speed = 0
	var/last_relayed_direction

	var/partial_x = 0
	var/partial_y = 0

/datum/overmap_object/shuttle/relaymove(mob/living/user, direction)
	return

/datum/overmap_object/shuttle/New()
	..()
	START_PROCESSING(SSfastprocess, src)

/datum/overmap_object/shuttle/process(delta_time)
	//var/datum/point/vector/V = new(x, y, 0, 0, 0, angle)
	if(!do_move)
		return
	if(last_relayed_direction == NORTH)
		engine_speed = min(engine_speed+1, 10)
	else if (last_relayed_direction == SOUTH)
		engine_speed = max(engine_speed-1, 0)
	else if (last_relayed_direction == WEST)
		angle -= 10
	else if (last_relayed_direction == EAST)
		angle += 10
	last_relayed_direction = null
	if(angle > 180)
		angle -= 360
	else if (angle < -180)
		angle += 360

	var/add_partial_x = round(engine_speed * sin(angle))
	var/add_partial_y = round(engine_speed * cos(angle))

	partial_x += add_partial_x
	partial_y += add_partial_y
	if(partial_y > 16)
		partial_y -= 32
		y = min(y+1,world.maxy)
	else if(partial_y < -16)
		partial_y += 32
		y = max(y-1,1)
	if(partial_x > 16)
		partial_x -= 32
		x = min(x+1,world.maxx)
	else if(partial_x < -16)
		partial_x += 32
		x = max(x-1,1)


	/*
	if(x != destination_x)
		if(destination_x > x)
			x++
		else
			x--
	if(y != destination_y)
		if(destination_y > y)
			y++
		else
			y--
	*/
	my_visual.pixel_x = partial_x
	my_visual.pixel_y = partial_y
	var/matrix/M = new
	M.Turn(angle)
	my_visual.transform = M
	update_visual_position()
	//if(y==destination_y && x==destination_x)
	//	StopMove()

/datum/overmap_object/shuttle/proc/CommandMove(dest_x, dest_y)
	destination_y = dest_y
	destination_x = dest_x
	if(!do_move)
		do_move = TRUE

/datum/overmap_object/shuttle/proc/StopMove()
	if(do_move)
		do_move = FALSE

/datum/overmap_object/shuttle/relaymove(mob/living/user, direction)
	do_move = TRUE
	last_relayed_direction = direction

/datum/overmap_object/ruins
	name = "Cluster of ruins"
	icon = 'modular_skyrat/modules/overmap/icons/64x64.dmi'
	icon_state = "ruins"
	visual_y_offset = -16
	visual_x_offset = -16

/datum/overmap_object/ruins/New(datum/overmap_sun_system/passed_system, x_coord, y_coord)
	..()
	my_visual.icon_state = "ruins[rand(1,3)]"

/datum/overmap_object/station
	name = "Frontier station"
	icon = 'modular_skyrat/modules/overmap/icons/64x64.dmi'
	icon_state = "station"
	visual_y_offset = -16
	visual_x_offset = -16

/datum/overmap_object/lavaland
	name = "Lavaland planet"
	icon = 'modular_skyrat/modules/overmap/icons/64x64.dmi'
	icon_state = "lavaland"
	visual_y_offset = -16
	visual_x_offset = -16

/datum/overmap_object/New(datum/overmap_sun_system/passed_system, x_coord, y_coord)
	x = x_coord
	y = y_coord
	current_system = passed_system
	current_system.overmap_objects += src

	if(make_visual)
		my_visual = new(locate(x,y,current_system.z_level))
		my_visual.icon = icon
		my_visual.icon_state = icon_state
		my_visual.name = name
		my_visual.my_overmap_object = src
		var/matrix/M = new
		M.Translate(visual_x_offset, visual_y_offset)
		my_visual.transform = M

/datum/overmap_object/Destroy()
	current_system.overmap_objects -= src
	if(my_visual)
		my_visual.my_overmap_object = null
		qdel(my_visual)
	return ..()
