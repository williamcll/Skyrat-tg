/datum/plant_gene/trait/proc/on_flora_agitated(obj/structure/flora/botany/BF, atom/target)
	return

//Jungle glows down below
/datum/plant_gene/trait/glow/teal
	name = "Teal Bioluminescence"
	glow_color = "#00FFEE"

/datum/plant_gene/trait/glow/vivid_green
	name = "Vivid Green Bioluminescence"
	glow_color = "#6AFF00"

/datum/plant_gene/trait/glow/vivid_yellow
	name = "Vivid Yellow Bioluminescence"
	glow_color = "#D9FF00"

/datum/plant_gene/trait/glow/amber
	name = "Amber Bioluminescence"
	glow_color = "#FFC800"

/datum/plant_gene/trait/foam
	// Makes plant spill a foam that carries reagents when squashed.
	name = "Expansive Decomposition"

/datum/plant_gene/trait/foam/on_squash(obj/item/food/grown/G, atom/target)
	var/datum/effect_system/foam_spread/S = new
	var/splat_location = get_turf(G)
	if(isturf(splat_location))
		var/foam_amount = round(sqrt(G.seed.potency * 0.1), 1)
		S.set_up(foam_amount, splat_location, G.reagents)
		S.start()
		G.reagents.clear_reagents()

/obj/effect/particle_effect/smoke/chem/spore
	icon = 'modular_skyrat/modules/planetary/icons/effects/96x96.dmi'
	icon_state = "spore"
	opaque = 0

/datum/effect_system/smoke_spread/chem/spore
	effect_type = /obj/effect/particle_effect/smoke/chem/spore

/datum/plant_gene/trait/spore_emission
	// Makes the plant create smoke-like spore gas that carry reagents every now and then (not produce)
	name = "Spore Emission"

/datum/plant_gene/trait/spore_emission/proc/do_emission(obj/item/seeds/S, loc)
	var/datum/reagents/R = new/datum/reagents(1000)
	for(var/rid in S.reagents_add)
		var/amount = 1 + round(S.potency * S.reagents_add[rid], 1)

		var/list/data = null
		if(rid == "blood") // Hack to make blood in plants always O-
			data = list("blood_type" = "O-")

		R.add_reagent(rid, amount, data)

	var/datum/effect_system/smoke_spread/chem/spore/Spore = new
	var/smoke_amount = round(sqrt(S.potency * 0.1), 1)
	Spore.attach(loc)
	Spore.set_up(R, smoke_amount, loc, 0)
	Spore.start()
	qdel(R)

/datum/plant_gene/trait/spore_emission/on_flora_agitated(obj/structure/flora/seed/BF, atom/target)
	var/turf/T = get_turf(BF)
	var/obj/item/seeds/S = BF.myseed
	if(S && T)
		do_emission(S, T)

/datum/plant_gene/trait/spore_emission/on_grow(obj/machinery/hydroponics/H)
	var/turf/T = get_turf(H)
	var/obj/item/seeds/S = H.myseed
	if(S && T)
		do_emission(S, T)

/****Some extra modifiers to already existing traits****/

/datum/plant_gene/trait/cell_charge/on_slip(obj/item/food/grown/G, mob/living/carbon/C)
	. = ..()
	do_sparks(3, FALSE, G)
	playsound(src, "sparks", 50, 1)

/datum/plant_gene/trait/cell_charge/on_squash(obj/item/food/grown/G, atom/target)
	. = ..()
	do_sparks(3, FALSE, G)
	playsound(src, "sparks", 50, 1)

/datum/plant_gene/trait/cell_charge/on_flora_agitated(obj/structure/flora/seed/BF, atom/target)
	do_sparks(3, FALSE, BF)
	playsound(src, "sparks", 50, 1)
	if(BF.myseed.potency > 25)
		playsound(BF, 'sound/magic/lightningshock.ogg', 100, 1, extrarange = 5)
		tesla_zap(BF, 4, (BF.myseed.potency * 200), ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN)
