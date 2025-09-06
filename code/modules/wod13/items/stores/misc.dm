/obj/machinery/mineral/equipment_vendor/fastfood/illegal	// PSEUDO_M make this restricted and only available for Axes
	prize_list = list(
		new /datum/data/mining_equipment("lighter",		/obj/item/lighter/greyscale,	10),
		new /datum/data/mining_equipment("zippo lighter",	/obj/item/lighter,	20),
		new /datum/data/mining_equipment("Bailer", /obj/item/bailer, 20),
		new /datum/data/mining_equipment("Weed Seed", /obj/item/weedseed, 20),
		new /datum/data/mining_equipment("cannabis puff",		/obj/item/clothing/mask/cigarette/rollie/cannabis,	40),
		new /datum/data/mining_equipment("bong",	/obj/item/bong,		50),
		new /datum/data/mining_equipment("lockpick",	/obj/item/vamp/keys/hack, 50),
		new /datum/data/mining_equipment("LSD pill bottle",		/obj/item/storage/pill_bottle/lsd,	50),
		new /datum/data/mining_equipment("knife",	/obj/item/melee/vampirearms/knife,	85),
		new /datum/data/mining_equipment("switchblade",	/obj/item/melee/vampirearms/knife/switchblade, 85),
		new /datum/data/mining_equipment("stake",	/obj/item/vampire_stake,	100),
		new /datum/data/mining_equipment("pliers",	/obj/item/wirecutters/pliers/bad_pliers,	200),
		new /datum/data/mining_equipment("Surgery dufflebag", /obj/item/storage/backpack/duffelbag/med/surgery, 100),
		new /datum/data/mining_equipment("Handcuffs", /obj/item/restraints/handcuffs, 50),
		new /datum/data/mining_equipment("Black bag", /obj/item/clothing/head/vampire/blackbag, 50),
		new /datum/data/mining_equipment("snub-nose revolver",	/obj/item/gun/ballistic/vampire/revolver/snub,	100),
		new /datum/data/mining_equipment("cannabis package",		/obj/item/weedpack,	700),
		new /datum/data/mining_equipment("morphine syringe",	/obj/item/reagent_containers/syringe/contraband/morphine,	800),
		new	/datum/data/mining_equipment("meth package",	/obj/item/reagent_containers/food/drinks/meth,	800),
		new	/datum/data/mining_equipment("cocaine package",	/obj/item/reagent_containers/food/drinks/meth/cocaine,	800)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/pharmacy
	prize_list = list(
		new /datum/data/mining_equipment("bruise pack", /obj/item/stack/medical/bruise_pack, 100),
		new /datum/data/mining_equipment("burn ointment", /obj/item/stack/medical/ointment, 100),
		new /datum/data/mining_equipment("potassium iodide pill bottle", /obj/item/storage/pill_bottle/potassiodide, 100),
		new /datum/data/mining_equipment("latex gloves", /obj/item/clothing/gloves/vampire/latex, 150),
		new /datum/data/mining_equipment("iron pill bottle", /obj/item/storage/pill_bottle/iron, 150),
		new /datum/data/mining_equipment("ephedrine pill bottle", /obj/item/storage/pill_bottle/ephedrine, 200),
		new /datum/data/mining_equipment("box of syringes", /obj/item/storage/box/syringes, 300),
		new /datum/data/mining_equipment("straight jacket", /obj/item/clothing/suit/straight_jacket, 200)
	)


/obj/machinery/mineral/equipment_vendor/fastfood/smoking
	prize_list = list(new /datum/data/mining_equipment("malboro",	/obj/item/storage/fancy/cigarettes/cigpack_robust,	50),
		new /datum/data/mining_equipment("newport",		/obj/item/storage/fancy/cigarettes/cigpack_xeno,	30),
		new /datum/data/mining_equipment("camel",	/obj/item/storage/fancy/cigarettes/dromedaryco,	30),
		new /datum/data/mining_equipment("carp classic",	/obj/item/storage/fancy/cigarettes/cigpack_carp,	30),
		new /datum/data/mining_equipment("zippo lighter",	/obj/item/lighter,	20),
		new /datum/data/mining_equipment("lighter",		/obj/item/lighter/greyscale,	10),
		new /datum/data/mining_equipment("robust gold", /obj/item/storage/fancy/cigarettes/cigpack_robustgold, 100),
		new /datum/data/mining_equipment("cigar ", /obj/item/storage/fancy/cigarettes/cigars, 100),
		new /datum/data/mining_equipment("havana cigar", /obj/item/storage/fancy/cigarettes/cigars/havana, 100),
		new /datum/data/mining_equipment("cohiba cigar", /obj/item/storage/fancy/cigarettes/cigars/cohiba, 100)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/gas
	prize_list = list(new /datum/data/mining_equipment("full gas can",	/obj/item/gas_can/full,	250),
		new /datum/data/mining_equipment("tire iron",		/obj/item/melee/vampirearms/tire,	50),
		new /datum/data/mining_equipment("Spray Paint",		/obj/item/toy/crayon/spraycan,		25),
		new /datum/data/mining_equipment("Hair Spray",		/obj/item/dyespray,		10),
	)

/obj/machinery/mineral/equipment_vendor/fastfood/library

	prize_list = list(
		new /datum/data/mining_equipment("Bible",	/obj/item/storage/book/bible,  20),
		new /datum/data/mining_equipment("Quran",	/obj/item/vampirebook/quran,  20),
		new /datum/data/mining_equipment("black pen",	/obj/item/pen,  5),
		new /datum/data/mining_equipment("four-color pen",	/obj/item/pen/fourcolor,  10),
		new /datum/data/mining_equipment("fountain pen",	/obj/item/pen/fountain,  15),
		new /datum/data/mining_equipment("folder",	/obj/item/folder,  5),
		new /datum/data/mining_equipment("paper bin", /obj/item/paper_bin, 20)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/antique
	prize_list = list(
		new /datum/data/mining_equipment("katana", /obj/item/melee/vampirearms/katana, 1000),
		new /datum/data/mining_equipment("rapier", /obj/item/melee/vampirearms/rapier, 1200),
		new /datum/data/mining_equipment("sabre", /obj/item/melee/vampirearms/sabre, 1400),
		new /datum/data/mining_equipment("longsword", /obj/item/melee/vampirearms/longsword, 1600)
	)
