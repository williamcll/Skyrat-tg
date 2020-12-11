/datum/planet_dictionary
	///Name of the planet
	var/name = "planet name"
	///Description of the planet
	var/desc = "planet desc"
	///List of possible xenofloras, and their weight //FOR BASIC FLORA - use the map generator
	var/list/xenoflora_weight = list()
	///List of possible fossils, and their weight
	var/list/fossil_weight = list()
	///Type of the planet generator we're using for the planet
	var/datum/map_generator/planet_gen
	///Whether our planet uses a day/night system.
	var/day_night_system = FALSE
	///List of possible ores, and their weight. Planetary ore node spawners care about this (Also, here's an idea: make it based off of biomes, somehow, later)
	var/list/ore_weight = list(/obj/item/stack/ore/uranium = 5, /obj/item/stack/ore/diamond = 2, /obj/item/stack/ore/gold = 10,
		/obj/item/stack/ore/silver = 12, /obj/item/stack/ore/plasma = 20, /obj/item/stack/ore/iron = 40, /obj/item/stack/ore/titanium = 11,
		/obj/item/stack/ore/bluespace_crystal = 2)
	///Multiplier of ores
	var/ore_density = 5
	///How many ore types are gonna be picked for an ore node, this doesnt make it so less ore spawns
	var/ore_variety = 5
	var/possible_ore_nodes = 10
	var/spawned_ore_nodes = 0 //Counter for already spawned ore nodes, dont change this
	var/default_traits = list(ZTRAIT_BASETURF = /turf/open/floor/plating/grass/jungle)
	var/area/my_area //Will be granted upon generation
	var/amber_fossils = FALSE

/datum/planet_dictionary/New()
	SeedXenoflora()
	SeedFossils()
	SeedOre()

/datum/planet_dictionary/proc/SeedXenoflora()
	return

/datum/planet_dictionary/proc/SeedFossils()
	for(var/i in 1 to 4)
		var/datum/fossil/F = new /datum/fossil/fauna(src)
		fossil_weight[F] = F.rarity
	for(var/i in 1 to 3)
		var/datum/fossil/F = new /datum/fossil/flora(src)
		fossil_weight[F] = F.rarity

/datum/planet_dictionary/proc/SeedOre()
	return

/datum/planet_dictionary/proc/MarkZLevel(z_level)
	GLOB.planet_dict_by_z_level["[z_level]"] = src

/datum/planet_dictionary/proc/random_fossil_ref()
	if(!length(fossil_weight))
		return
	return pickweight(fossil_weight)
