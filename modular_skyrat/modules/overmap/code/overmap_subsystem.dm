SUBSYSTEM_DEF(overmap)
	name = "Overmap"
	init_order = INIT_ORDER_MAPPING + 1 //Always before mapping
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 0.5 SECONDS
	var/list/sun_systems = list()
	var/datum/overmap_sun_system/main_system

/datum/controller/subsystem/overmap/Initialize()
	return ..()

/datum/controller/subsystem/overmap/proc/MappingInit()
	//Initialize sun systems
	var/datum/overmap_sun_system/first_system = new /datum/overmap_sun_system()
	main_system = first_system
	sun_systems += first_system

/datum/controller/subsystem/overmap/proc/get_main_sun_system()
	return main_system

/datum/controller/subsystem/overmap/fire(resumed = FALSE)
	return
