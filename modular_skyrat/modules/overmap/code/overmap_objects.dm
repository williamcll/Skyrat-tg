/obj/effect/abstract/overmap
	glide_size = 3
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

	var/interact_flags = NONE
	var/property_flags = NONE

	var/datum/overmap_lock/main_lock


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

/datum/overmap_object/proc/relaymove(mob/living/user, direction)
	return

/datum/overmap_object/proc/update_visual_position()
	if(my_visual)
		my_visual.x = x
		my_visual.y = y

/datum/overmap_object/process(delta_time)
	return

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

	interact_flags = OMI_LOCKABLE

/datum/overmap_object/lavaland
	name = "Lavaland planet"
	icon = 'modular_skyrat/modules/overmap/icons/64x64.dmi'
	icon_state = "lavaland"
	visual_y_offset = -16
	visual_x_offset = -16

	interact_flags = OMI_LOCKABLE
