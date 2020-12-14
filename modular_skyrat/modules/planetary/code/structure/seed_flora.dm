//Mostly a copy of the lavaland floras, but with some differences, done this way to avoid any conflicts
/obj/structure/flora/seed
	gender = PLURAL
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	icon = 'icons/obj/lavaland/ash_flora.dmi'
	icon_state = "l_mushroom"
	name = "large mushrooms"
	desc = "A number of large mushrooms, covered in a faint layer of ash and what can only be spores."
	var/harvested_name = "shortened mushrooms"
	var/harvested_desc = "Some quickly regrowing mushrooms, formerly known to be quite large."
	var/needs_sharp_harvest = FALSE
	var/harvest_amount_low = 1
	var/harvest_amount_high = 3
	var/harvest_time = 3 SECONDS
	var/harvest_message_low = "You pick a mushroom, but fail to collect many shavings from its cap."
	var/harvest_message_med = "You pick a mushroom, carefully collecting the shavings from its cap."
	var/harvest_message_high = "You harvest and collect shavings from several mushroom caps."
	var/harvested = FALSE
	var/base_icon
	var/regrowth_time_low = 8 MINUTES
	var/regrowth_time_high = 16 MINUTES

	var/obj/item/seeds/myseed
	var/seedtype = /obj/item/seeds/lavaland/polypore

	var/structure_traits = NONE

/obj/structure/flora/seed/proc/InitSeed()
	myseed = new seedtype()

/obj/structure/flora/seed/Initialize()
	. = ..()
	icon_state = base_icon
	InitSeed()

/obj/structure/flora/seed/proc/harvest(user)
	if(harvested)
		return FALSE

	var/rand_harvested = rand(harvest_amount_low, harvest_amount_high)
	if(rand_harvested)
		if(user)
			var/msg = harvest_message_med
			if(rand_harvested == harvest_amount_low)
				msg = harvest_message_low
			else if(rand_harvested == harvest_amount_high)
				msg = harvest_message_high
			to_chat(user, "<span class='notice'>[msg]</span>")
		for(var/i in 1 to rand_harvested)
			var/obj/item/produce = new myseed.product(get_turf(src), myseed)
			if(myseed.plantname != initial(myseed.plantname))
				produce.name = lowertext(myseed.plantname)
			if(myseed.productdesc)
				produce.desc = myseed.productdesc

	icon_state = "[base_icon]p"
	name = harvested_name
	desc = harvested_desc
	harvested = TRUE
	addtimer(CALLBACK(src, .proc/regrow), rand(regrowth_time_low, regrowth_time_high))
	return TRUE

/obj/structure/flora/seed/proc/regrow()
	icon_state = base_icon
	name = initial(name)
	desc = initial(desc)
	harvested = FALSE

/obj/structure/flora/seed/attackby(obj/item/W, mob/user, params)
	if (istype(W, /obj/item/plant_analyzer))
		var/obj/item/plant_analyzer/P_analyzer = W
		if(P_analyzer.scan_mode == PLANT_SCANMODE_STATS)
			to_chat(user, "*** <B>[myseed.plantname]</B> ***" )
			var/list/text_string = myseed.get_analyzer_text()
			if(text_string)
				to_chat(user, text_string)
				to_chat(user, "*---------*")
		if(myseed.reagents_add && P_analyzer.scan_mode == PLANT_SCANMODE_CHEMICALS)
			to_chat(user, "- <B>Plant Reagents</B> -")
			to_chat(user, "*---------*")
			for(var/datum/plant_gene/reagent/G in myseed.genes)
				to_chat(user, "<span class='notice'>- [G.get_name()] -</span>")
			to_chat(user, "*---------*")
		return
	if(!harvested && needs_sharp_harvest && W.get_sharpness())
		user.visible_message("<span class='notice'>[user] starts to harvest from [src] with [W].</span>","<span class='notice'>You begin to harvest from [src] with [W].</span>")
		if(do_after(user, harvest_time, target = src))
			harvest(user)
	else
		return ..()

/obj/structure/flora/seed/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!harvested && !needs_sharp_harvest)
		user.visible_message("<span class='notice'>[user] starts to harvest from [src].</span>","<span class='notice'>You begin to harvest from [src].</span>")
		if(do_after(user, harvest_time, target = src))
			harvest(user)

/obj/structure/flora/seed/xenoflora
	var/xenoflora_type
	var/datum/research_info/xenoflora/xenoflora_ref

/obj/structure/flora/seed/xenoflora/InitSeed()
	var/datum/research_info/xenoflora/XF = GLOB.all_research_infos[xenoflora_type]
	structure_traits = XF.structure_traits
