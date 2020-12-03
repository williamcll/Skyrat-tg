/datum/planet_dictionary
	///Name of the planet
	var/name
	///Description of the planet
	var/desc
	///List of possible xenofloras, and their weight //FOR BASIC FLORA - use the map generator
	var/list/xenoflora_weight
	///List of possible fossils, and their weight
	var/list/fossil_weight
	///Type of the planet generator we're using for the planet
	var/datum/datum/map_generator/planet_gen
	///Whether our planet uses a day/night system.
	var/day_night_system = FALSE
	///List of possible ores, and their weight. Planetary ore node spawners care about this (Also, here's an idea: make it based off of biomes, somehow, later)
	var/list/ore_weight
	var/ore_density = 10
	var/ore_variety = 10
	var/possible_ore_nodes = 8
	var/spawned_ore_nodes = 0 //Counter for already spawned ore nodes, dont change this


/datum/planet_dictionary/New()
	SeedXenoflora()
	SeedFossils()
	SeedOre()

/datum/planet_dictionary/proc/SeedXenoflora()
	return

/datum/planet_dictionary/proc/SeedFossils()
	return

/datum/planet_dictionary/proc/SeedOre()
	return
