/obj/effect/abstract/overmap
	var/datum/overmap_object/my_overmap_object

/datum/overmap_sun_system
	var/name = "Alpha"
	var/x = 0
	var/y = 0
	var/list/overmap_objects = list()
	var/datum/space_level/my_space_level
	var/z_level = 0 //Easier lookup

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

	var/list/related_levels = list()

/datum/overmap_object/shuttle
	name = "Shuttle"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "plushie_lizard"
	var/obj/docking_port/mobile/my_shuttle = null

/datum/overmap_object/ruins
	name = "Cluster of ruins"

/datum/overmap_object/station
	name = "Frontier station"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "hburger"

/datum/overmap_object/lavaland
	name = "Lavaland planet"
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "Goliath"

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

/datum/overmap_object/Destroy()
	current_system.overmap_objects -= src
	if(my_visual)
		my_visual.my_overmap_object = null
		qdel(my_visual)
	return ..()
