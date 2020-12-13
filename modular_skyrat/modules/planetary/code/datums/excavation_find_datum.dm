GLOBAL_LIST_INIT(excavation_finds_weight, InitExcavFinds())

/proc/InitExcavFinds()
	var/list/returned = list()
	for(var/path in subtypesof(/datum/excavation_find))
		var/datum/excavation_find/EF = path
		returned[path] = initial(EF.weight)
	return returned

/datum/excavation_find
	var/clearance
	var/type_to_spawn
	var/weight = 10

/datum/excavation_find/New()
	clearance = rand(1,3)

/datum/excavation_find/fossil
	type_to_spawn = /obj/item/fossil
	weight = 30

/datum/excavation_find/anomalous_crystal
	type_to_spawn = /obj/item/anomalous_sliver/crystal
	weight = 15

/datum/excavation_find/excavation_junk
	type_to_spawn = /obj/item/excavation_junk
	weight = 15

/datum/excavation_find/strange_seed
	type_to_spawn = /obj/item/seeds/random
	weight = 5
