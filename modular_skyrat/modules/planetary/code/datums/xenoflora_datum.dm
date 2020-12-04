//One should be able to create a flora structure, or seed packs just from this datum
/datum/xenoflora
	///Name of the xeno flora
	var/name
	///Description of the xenoflora
	var/desc
	///Which planet is it from
	var/origin
	///How many research points we get from this
	var/research_points
	///Unique ID for easy checking with RnD consoles
	var/xenoflora_id
	///The lower the rarity the more rare it is
	var/rarity = 1
	/*****PHYSICALITIES********/
	///Path to the physical structure, which may be handling looks or some behaviours differently
	var/structure_type
	///Extra traits that the flora structure will have, like being prickly itself
	var/structure_traits
	/*****SEED STATISTICS*****/
	///Reference to a seed xenoflora should generate. The structures generated from this datum will also point to this, and produce will be generated off of this
	var/obj/item/seeds/seed_ref

