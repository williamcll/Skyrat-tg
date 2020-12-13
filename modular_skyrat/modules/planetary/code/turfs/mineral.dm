/turf/closed/mineral/Initialize()
	. = ..()
	if(prob(3))
		AddComponent(/datum/component/turf_excavation)

/turf/open/floor/plating/dirt/jungle/wasteland/Initialize()
	. = ..()
	if(prob(5))
		AddComponent(/datum/component/turf_excavation)
