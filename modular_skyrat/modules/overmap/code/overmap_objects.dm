/datum/overmap_sun_system
	var/name = "Sun system alpha"
	var/x = 0
	var/y = 0
	var/list/overmap_objects = list()

/datum/overmap_object
	var/name = "Overmap object"
	var/x = 0
	var/y = 0
	var/datum/overmap_sun_system/current_system

/datum/overmap_object/New(datum/overmap_sun_system/passed_system, x_coord, y_coord)
	x = x_coord
	y = y_coord
	current_system = passed_system
	current_system.overmap_objects += src

/datum/overmap_object/New/Destroy()
	current_system.overmap_objects -= src
	return ..()

/datum/overmap_object/z_level_holder
	var/list/related_levels = list()
