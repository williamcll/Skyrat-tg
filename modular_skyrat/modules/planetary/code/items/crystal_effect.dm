/proc/anomaly_crystal_effect(turf/T, anom_type, anom_pow)
	message_admins("Anomalous crystal effect was activated! [ADMIN_JMP(src)]")
	switch(anom_type)
		if(ANOM_CRYSTAL_FIRE)
			var/gas_power = anom_pow/5
			T.atmos_spawn_air("o2=[gas_power];plasma=[gas_power];TEMP=600")
		if(ANOM_CRYSTAL_EMP)
			var/heavy = round((anom_pow-20)/40)
			var/light = round(anom_pow+20/20)
			empulse(src, light, heavy)
		if(ANOM_CRYSTAL_ELECTRIC)
			var/power = anom_pow*70
			do_sparks(3, TRUE, T)
			tesla_zap(T, 4, power, ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN)
		if(ANOM_CRYSTAL_RADIATION)
			playsound(T, 'sound/effects/empulse.ogg', 50, TRUE)
			radiation_pulse(T, anom_pow)
		if(ANOM_CRYSTAL_EXPLOSIVE)
			var/power = anom_pow/8
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(power, T, 0, 0)
			e.start()
		if(ANOM_CRYSTAL_GRAVITATIONAL)
			var/boing = FALSE
			if(anom_pow > 40)
				boing = TRUE
			for(var/obj/O in orange(4, T))
				if(!O.anchored)
					step_towards(O,T)
			for(var/mob/living/M in range(0, T))
				if(boing && !M.stat)
					M.Paralyze(40)
					var/atom/target = get_edge_target_turf(M, get_dir(T, get_step_away(M, T)))
					M.throw_at(target, 5, 1)
			for(var/mob/living/M in orange(4, T))
				if(!M.mob_negates_gravity())
					step_towards(M,T)
			for(var/obj/O in range(0,T))
				if(!O.anchored)
					if(T.intact && HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
						continue
					var/mob/living/target = locate() in view(4,src)
					if(target && !target.stat)
						O.throw_at(target, 5, 10)
		if(ANOM_CRYSTAL_RESIN_FOAM)
			var/obj/effect/resin_container/RC = new(T)
			RC.Smoke()
		if(ANOM_CRYSTAL_NITROUS_OXIDE)
			var/gas_power = anom_pow/2
			T.atmos_spawn_air("n2o=[gas_power];TEMP=290")
		if(ANOM_CRYSTAL_MEDICAL_FOAM)
			var/foam_range = anom_pow/5
			var/reagents_amount = anom_pow/5
			var/datum/reagents/R = new/datum/reagents(300)
			R.add_reagent(/datum/reagent/medicine/regen_jelly, reagents_amount)
			var/datum/effect_system/foam_spread/foam = new
			foam.set_up(foam_range, T, R)
			foam.start()
		if(ANOM_CRYSTAL_TOXIN_FOAM)
			var/foam_range = anom_pow/5
			var/reagents_amount = anom_pow/5
			var/datum/reagents/R = new/datum/reagents(300)
			R.add_reagent(/datum/reagent/toxin, reagents_amount)
			var/datum/effect_system/foam_spread/foam = new
			foam.set_up(foam_range, T, R)
			foam.start()
		if(ANOM_CRYSTAL_FROST_VAPOUR)
			var/gas_power = anom_pow*1.5
			T.atmos_spawn_air("water_vapor=[gas_power];TEMP=3")
