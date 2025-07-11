/obj/item/organ/tongue
	name = "tongue"
	desc = "A fleshy muscle mostly used for lying."
	icon_state = "tonguenormal"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb_continuous = list("licks", "slobbers", "slaps", "frenches", "tongues")
	attack_verb_simple = list("lick", "slobber", "slap", "french", "tongue")
	var/list/languages_possible
	var/say_mod = null

	/// Whether the owner of this tongue can taste anything. Being set to FALSE will mean no taste feedback will be provided.
	var/sense_of_taste = TRUE

	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = FALSE
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/english,
		/datum/language/espanol,
		/datum/language/mandarin,
		/datum/language/beachbum,
		/datum/language/russian,
		/datum/language/italian,
		/datum/language/latin,
		/datum/language/hebrew,
		/datum/language/french,
		/datum/language/arabic,
		/datum/language/german,
		/datum/language/hebrew,
		/datum/language/japanese,
		/datum/language/cantonese,
		/datum/language/greek,
		/datum/language/garou_tongue,
		/datum/language/primal_tongue
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_base
	AddComponent(/datum/component/selling/organ, 100, "organ", TRUE, -1, 0)

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args)

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = 0)
	..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = say_mod
	if (modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.UnregisterSignal(M, COMSIG_MOB_SAY)

	/* This could be slightly simpler, by making the removal of the
	* NO_TONGUE_TRAIT conditional on the tongue's `sense_of_taste`, but
	* then you can distinguish between ageusia from no tongue, and
	* ageusia from having a non-tasting tongue.
	*/
	REMOVE_TRAIT(M, TRAIT_AGEUSIA, NO_TONGUE_TRAIT)
	if(!sense_of_taste)
		ADD_TRAIT(M, TRAIT_AGEUSIA, ORGAN_TRAIT)

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = 0)
	..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = initial(M.dna.species.say_mod)
	UnregisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.RegisterSignal(M, COMSIG_MOB_SAY, TYPE_PROC_REF(/mob/living/carbon, handle_tongueless_speech))
	REMOVE_TRAIT(M, TRAIT_AGEUSIA, ORGAN_TRAIT)
	// Carbons by default start with NO_TONGUE_TRAIT caused TRAIT_AGEUSIA
	ADD_TRAIT(M, TRAIT_AGEUSIA, NO_TONGUE_TRAIT)

/obj/item/organ/tongue/could_speak_language(language)
	return is_type_in_typecache(language, languages_possible)

/obj/item/organ/tongue/lizard
	name = "forked tongue"
	desc = "A thin and long muscle typically found in reptilian races, apparently moonlights as a nose."
	icon_state = "tonguelizard"
	say_mod = "hisses"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
	modifies_speech = TRUE

/obj/item/organ/tongue/lizard/handle_speech(datum/source, list/speech_args)
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/static/regex/lizard_kss = new(@"(\w)x", "g")
	var/static/regex/lizard_kSS = new(@"(\w)X", "g")
	var/static/regex/lizard_ecks = new(@"\bx([\-|r|R]|\b)", "g")
	var/static/regex/lizard_eckS = new(@"\bX([\-|r|R]|\b)", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "SSS")
		message = lizard_kss.Replace(message, "$1kss")
		message = lizard_kSS.Replace(message, "$1KSS")
		message = lizard_ecks.Replace(message, "ecks$1")
		message = lizard_eckS.Replace(message, "ECKS$1")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/fly
	name = "proboscis"
	desc = "A freakish looking meat tube that apparently can take in liquids."
	icon_state = "tonguefly"
	say_mod = "buzzes"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	modifies_speech = TRUE
	var/static/list/languages_possible_fly = typecacheof(list(
		/datum/language/english,
		/datum/language/espanol,
		/datum/language/mandarin,
		/datum/language/beachbum,
		/datum/language/russian,
		/datum/language/italian,
		/datum/language/latin,
		/datum/language/hebrew,
		/datum/language/french,
		/datum/language/arabic,
		/datum/language/german,
		/datum/language/hebrew,
		/datum/language/japanese,
		/datum/language/cantonese,
		/datum/language/greek
	))

/obj/item/organ/tongue/fly/handle_speech(datum/source, list/speech_args)
	var/static/regex/fly_buzz = new("z+", "g")
	var/static/regex/fly_buZZ = new("Z+", "g")
	var/static/regex/fly_buss = new("s+", "g")
	var/static/regex/fly_buSS = new("S+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace(message, "zzz")
		message = fly_buZZ.Replace(message, "ZZZ")
		message = fly_buss.Replace(message, "z")
		message = fly_buSS.Replace(message, "Z")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/fly/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_fly

/obj/item/organ/tongue/abductor
	name = "superlingual matrix"
	desc = "A mysterious structure that allows for instant communication between users. Pretty impressive until you need to eat something."
	icon_state = "tongueayylmao"
	say_mod = "gibbers"
	sense_of_taste = FALSE
	modifies_speech = TRUE
	var/mothership

/obj/item/organ/tongue/abductor/attack_self(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(!istype(T))
		return

	if(T.mothership == mothership)
		to_chat(H, "<span class='notice'>[src] is already attuned to the same channel as your own.</span>")

	H.visible_message("<span class='notice'>[H] holds [src] in their hands, and concentrates for a moment.</span>", "<span class='notice'>You attempt to modify the attenuation of [src].</span>")
	if(do_after(H, delay=15, target=src))
		to_chat(H, "<span class='notice'>You attune [src] to your own channel.</span>")
		mothership = T.mothership

/obj/item/organ/tongue/abductor/examine(mob/M)
	. = ..()
	if(HAS_TRAIT(M, TRAIT_ABDUCTOR_TRAINING) || HAS_TRAIT(M.mind, TRAIT_ABDUCTOR_TRAINING) || isobserver(M))
		if(!mothership)
			. += "<span class='notice'>It is not attuned to a specific mothership.</span>"
		else
			. += "<span class='notice'>It is attuned to [mothership].</span>"

/obj/item/organ/tongue/abductor/handle_speech(datum/source, list/speech_args)
	//Hacks
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/user = source
	var/rendered = "<span class='abductor'><b>[user.real_name]:</b> [message]</span>"
	user.log_talk(message, LOG_SAY, tag="abductor")
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/abductor/T = H.getorganslot(ORGAN_SLOT_TONGUE)
		if(!istype(T))
			continue
		if(mothership == T.mothership)
			to_chat(H, rendered)

	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")

	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/tongue/zombie
	name = "rotting tongue"
	desc = "Between the decay and the fact that it's just lying there you doubt a tongue has ever seemed less sexy."
	icon_state = "tonguezombie"
	say_mod = "moans"
	modifies_speech = TRUE
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/handle_speech(datum/source, list/speech_args)
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, -3) == "..."))//3 == length("...")
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("BRAINS", "Brains", "Braaaiinnnsss", "BRAAAIIINNSSS")]...")

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

/obj/item/organ/tongue/alien
	name = "alien tongue"
	desc = "According to leading xenobiologists the evolutionary benefit of having a second mouth in your mouth is \"that it looks badass\"."
	icon_state = "tonguexeno"
	say_mod = "hisses"
	taste_sensitivity = 10 // LIZARDS ARE ALIENS CONFIRMED
	modifies_speech = TRUE // not really, they just hiss
	var/static/list/languages_possible_alien = typecacheof(list(
		/datum/language/english,
		/datum/language/mandarin))

/obj/item/organ/tongue/alien/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_alien

/obj/item/organ/tongue/alien/handle_speech(datum/source, list/speech_args)
	playsound(owner, "hiss", 25, TRUE, TRUE)

/obj/item/organ/tongue/bone
	name = "bone \"tongue\""
	desc = "Apparently skeletons alter the sounds they produce through oscillation of their teeth, hence their characteristic rattling."
	icon_state = "tonguebone"
	say_mod = "rattles"
	attack_verb_continuous = list("bites", "chatters", "chomps", "enamelles", "bones")
	attack_verb_simple = list("bite", "chatter", "chomp", "enamel", "bone")
	sense_of_taste = FALSE
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")
	var/static/list/languages_possible_skeleton = typecacheof(list(
		/datum/language/english,
		/datum/language/espanol,
		/datum/language/mandarin,
		/datum/language/beachbum,
		/datum/language/russian,
		/datum/language/italian,
		/datum/language/latin,
		/datum/language/hebrew,
		/datum/language/french,
		/datum/language/arabic,
		/datum/language/german,
		/datum/language/hebrew,
		/datum/language/japanese,
		/datum/language/cantonese,
		/datum/language/greek
	))

/obj/item/organ/tongue/bone/Initialize()
	. = ..()
	phomeme_type = pick(phomeme_types)
	languages_possible = languages_possible_skeleton

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/tongue/bone/plasmaman
	name = "plasma bone \"tongue\""
	desc = "Like animated skeletons, Plasmamen vibrate their teeth in order to produce speech."
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/tongue/robot
	name = "robotic voicebox"
	desc = "A voice synthesizer that can interface with organic lifeforms."
	status = ORGAN_ROBOTIC
	organ_flags = NONE
	icon_state = "tonguerobot"
	say_mod = "states"
	attack_verb_continuous = list("beeps", "boops")
	attack_verb_simple = list("beep", "boop")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue

/obj/item/organ/tongue/robot/can_speak_language(language)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/tongue/robot/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/snail
	name = "radula"
	color = "#96DB00" // TODO proper sprite, rather than recoloured pink tongue
	desc = "A minutely toothed, chitious ribbon, which as a side effect, makes all snails talk IINNCCRREEDDIIBBLLYY SSLLOOWWLLYY."
	modifies_speech = TRUE

/obj/item/organ/tongue/snail/handle_speech(datum/source, list/speech_args)
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	for(var/i in 1 to length(message))
		if(findtext("ABCDEFGHIJKLMNOPWRSTUVWXYZabcdefghijklmnopqrstuvwxyz", message[i])) //Im open to suggestions
			new_message += message[i] + message[i] + message[i] //aaalllsssooo ooopppeeennn tttooo sssuuuggggggeeessstttiiiooonsss
		else
			new_message += message[i]
	speech_args[SPEECH_MESSAGE] = new_message

/obj/item/organ/tongue/ethereal
	name = "electric discharger"
	desc = "A sophisticated ethereal organ, capable of synthesising speech via electrical discharge."
	icon_state = "electrotongue"
	say_mod = "crackles"
	attack_verb_continuous = list("shocks", "jolts", "zaps")
	attack_verb_simple = list("shock", "jolt", "zap")
	sense_of_taste = FALSE
	var/static/list/languages_possible_ethereal = typecacheof(list(
		/datum/language/english,
		/datum/language/espanol,
		/datum/language/mandarin,
		/datum/language/beachbum,
		/datum/language/russian,
		/datum/language/italian,
		/datum/language/latin,
		/datum/language/hebrew,
		/datum/language/french,
		/datum/language/arabic,
		/datum/language/german,
		/datum/language/hebrew,
		/datum/language/japanese,
		/datum/language/cantonese,
		/datum/language/greek
	))

/obj/item/organ/tongue/ethereal/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_ethereal

//Sign Language Tongue - yep, that's how you speak sign language.
/obj/item/organ/tongue/tied
	name = "tied tongue"
	desc = "If only one had a sword so we may finally untie this knot. If you're seeing this, then it's coded wrong."
	say_mod = "signs"
	icon_state = "tonguetied"
	modifies_speech = TRUE
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/tongue/tied/Insert(mob/living/carbon/M)
	. = ..()
	M.verb_ask = "signs"
	M.verb_exclaim = "signs"
	M.verb_whisper = "subtly signs"
	M.verb_sing = "rythmically signs"
	M.verb_yell = "emphatically signs"
	ADD_TRAIT(M, TRAIT_SIGN_LANG, "tongue")
	REMOVE_TRAIT(M, TRAIT_MUTE, "tongue")

/obj/item/organ/tongue/tied/Remove(mob/living/carbon/M, special = 0)
	..()
	M.verb_ask = initial(verb_ask)
	M.verb_exclaim = initial(verb_exclaim)
	M.verb_whisper = initial(verb_whisper)
	M.verb_sing = initial(verb_sing)
	M.verb_yell = initial(verb_yell)
	REMOVE_TRAIT(M, TRAIT_SIGN_LANG, "tongue") //People who are Ahealed get "cured" of their sign language-having ways. If I knew how to make the tied tongue persist through aheals, I'd do that.

//Thank you Jwapplephobia for helping me with the literal hellcode below

/obj/item/organ/tongue/tied/handle_speech(datum/source, list/speech_args)
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	var/exclamation_found = findtext(message, "!")
	var/question_found = findtext(message, "?")
	var/mob/living/carbon/M = owner
	new_message = message
	if(exclamation_found)
		new_message = replacetext(new_message, "!", ".")
	if(question_found)
		new_message = replacetext(new_message, "?", ".")
	speech_args[SPEECH_MESSAGE] = new_message

	if(exclamation_found && question_found)
		M.visible_message("<span class='notice'>[M] lowers one of [M.p_their()] eyebrows, raising the other.</span>")
	else if(exclamation_found)
		M.visible_message("<span class='notice'>[M] raises [M.p_their()] eyebrows.</span>")
	else if(question_found)
		M.visible_message("<span class='notice'>[M] lowers [M.p_their()] eyebrows.</span>")
