GLOBAL_LIST_INIT(all_research_infos, InitResearchInfos())

/proc/InitResearchInfos()
	var/list/returned = list()
	for(var/path in subtypesof(/datum/research_info))
		var/datum/research_info/RI = path
		if(initial(RI.name)) //To prevent parent types from instantiating
			RI = new path()
			returned[path] = RI
	return returned

/datum/research_info
	var/name
	var/desc
	var/research_points = 1000

/datum/research_info/xenofauna

/datum/research_info/xenoflora
	var/seed_type
	var/obj/item/seeds/seed_ref
	var/structure_traits

/datum/research_info/xenoflora/New()
	InitSeed()

/datum/research_info/xenoflora/proc/InitSeed()
	seed_ref = new seed_type()
