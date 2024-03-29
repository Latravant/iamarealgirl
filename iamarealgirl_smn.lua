-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Also, you'll need the Shortcuts addon to handle the auto-targetting of the custom pact commands.

--[[
    Custom commands:
    
    gs c petweather
        Automatically casts the storm appropriate for the current avatar, if possible.
    
    gs c siphon
        Automatically run the process to: dismiss the current avatar; cast appropriate
        weather; summon the appropriate spirit; Elemental Siphon; release the spirit;
        and re-summon the avatar.
        
        Will not cast weather you do not have access to.
        Will not re-summon the avatar if one was not out in the first place.
        Will not release the spirit if it was out before the command was issued.
        
    gs c pact [PactType]
        Attempts to use the indicated pact type for the current avatar.
        PactType can be one of:
            cure
            curaga
            buffOffense
            buffDefense
            buffSpecial
            debuff1
            debuff2
            sleep
            nuke2
            nuke4
            bp70
            bp75 (merits and lvl 75-80 pacts)
            astralflow
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff["Avatar's Favor"] = buffactive["Avatar's Favor"] or false
    state.Buff["Astral Conduit"] = buffactive["Astral Conduit"] or false

    spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
    avatars = S{"Carbuncle", "Fenrir", "Diabolos", "Ifrit", "Titan", "Leviathan", "Garuda", "Shiva", "Ramuh", "Odin", "Alexander", "Cait Sith"}

    magicalRagePacts = S{
        'Inferno','Earthen Fury','Tidal Wave','Aerial Blast','Diamond Dust','Judgment Bolt','Searing Light','Howling Moon','Ruinous Omen',
        'Fire II','Stone II','Water II','Aero II','Blizzard II','Thunder II',
        'Fire IV','Stone IV','Water IV','Aero IV','Blizzard IV','Thunder IV',
        'Thunderspark','Burning Strike','Meteorite','Nether Blast','Flaming Crush',
        'Meteor Strike','Heavenly Strike','Wind Blade','Geocrush','Grand Fall','Thunderstorm',
        'Holy Mist','Lunar Bay','Night Terror','Level ? Holy'}


    pacts = {}
    pacts.cure = {['Carbuncle']='Healing Ruby'}
    pacts.curaga = {['Carbuncle']='Healing Ruby II', ['Garuda']='Whispering Wind', ['Leviathan']='Spring Water'}
    pacts.buffoffense = {['Carbuncle']='Glittering Ruby', ['Ifrit']='Crimson Howl', ['Garuda']='Hastega', ['Ramuh']='Rolling Thunder',
        ['Fenrir']='Ecliptic Growl'}
    pacts.buffdefense = {['Carbuncle']='Shining Ruby', ['Shiva']='Frost Armor', ['Garuda']='Aerial Armor', ['Titan']='Earthen Ward',
        ['Ramuh']='Lightning Armor', ['Fenrir']='Ecliptic Howl', ['Diabolos']='Noctoshield', ['Cait Sith']='Reraise II'}
    pacts.buffspecial = {['Ifrit']='Inferno Howl', ['Garuda']='Fleet Wind', ['Titan']='Earthen Armor', ['Diabolos']='Dream Shroud',
        ['Carbuncle']='Soothing Ruby', ['Fenrir']='Heavenward Howl', ['Cait Sith']='Raise II'}
    pacts.debuff1 = {['Shiva']='Diamond Storm', ['Ramuh']='Shock Squall', ['Leviathan']='Tidal Roar', ['Fenrir']='Lunar Cry',
        ['Diabolos']='Pavor Nocturnus', ['Cait Sith']='Eerie Eye'}
    pacts.debuff2 = {['Shiva']='Sleepga', ['Leviathan']='Slowga', ['Fenrir']='Lunar Roar', ['Diabolos']='Somnolence'}
    pacts.sleep = {['Shiva']='Sleepga', ['Diabolos']='Nightmare', ['Cait Sith']='Mewing Lullaby'}
    pacts.nuke2 = {['Ifrit']='Fire II', ['Shiva']='Blizzard II', ['Garuda']='Aero II', ['Titan']='Stone II',
        ['Ramuh']='Thunder II', ['Leviathan']='Water II'}
    pacts.nuke4 = {['Ifrit']='Fire IV', ['Shiva']='Blizzard IV', ['Garuda']='Aero IV', ['Titan']='Stone IV',
        ['Ramuh']='Thunder IV', ['Leviathan']='Water IV'}
    pacts.bp70 = {['Ifrit']='Flaming Crush', ['Shiva']='Rush', ['Garuda']='Predator Claws', ['Titan']='Mountain Buster',
        ['Ramuh']='Chaotic Strike', ['Leviathan']='Spinning Dive', ['Carbuncle']='Meteorite', ['Fenrir']='Eclipse Bite',
        ['Diabolos']='Nether Blast',['Cait Sith']='Regal Scratch'}
    pacts.bp75 = {['Ifrit']='Meteor Strike', ['Shiva']='Heavenly Strike', ['Garuda']='Wind Blade', ['Titan']='Geocrush',
        ['Ramuh']='Thunderstorm', ['Leviathan']='Grand Fall', ['Carbuncle']='Holy Mist', ['Fenrir']='Lunar Bay',
        ['Diabolos']='Night Terror', ['Cait Sith']='Level ? Holy'}
    pacts.astralflow = {['Ifrit']='Inferno', ['Shiva']='Diamond Dust', ['Garuda']='Aerial Blast', ['Titan']='Earthen Fury',
        ['Ramuh']='Judgment Bolt', ['Leviathan']='Tidal Wave', ['Carbuncle']='Searing Light', ['Fenrir']='Howling Moon',
        ['Diabolos']='Ruinous Omen', ['Cait Sith']="Altana's Favor"}

    -- Wards table for creating custom timers   
    wards = {}
    -- Base duration for ward pacts.
    wards.durations = {
        ['Crimson Howl'] = 60, ['Earthen Armor'] = 60, ['Inferno Howl'] = 60, ['Heavenward Howl'] = 60,
        ['Rolling Thunder'] = 120, ['Fleet Wind'] = 120,
        ['Shining Ruby'] = 180, ['Frost Armor'] = 180, ['Lightning Armor'] = 180, ['Ecliptic Growl'] = 180,
        ['Glittering Ruby'] = 180, ['Hastega'] = 180, ['Noctoshield'] = 180, ['Ecliptic Howl'] = 180,
        ['Dream Shroud'] = 180,
        ['Reraise II'] = 3600
    }
    -- Icons to use when creating the custom timer.
    wards.icons = {
        ['Earthen Armor']   = 'spells/00299.png', -- 00299 for Titan
        ['Shining Ruby']    = 'spells/00043.png', -- 00043 for Protect
        ['Dream Shroud']    = 'spells/00304.png', -- 00304 for Diabolos
        ['Noctoshield']     = 'spells/00106.png', -- 00106 for Phalanx
        ['Inferno Howl']    = 'spells/00298.png', -- 00298 for Ifrit
        ['Hastega']         = 'spells/00358.png', -- 00358 for Hastega
        ['Rolling Thunder'] = 'spells/00104.png', -- 00358 for Enthunder
        ['Frost Armor']     = 'spells/00250.png', -- 00250 for Ice Spikes
        ['Lightning Armor'] = 'spells/00251.png', -- 00251 for Shock Spikes
        ['Reraise II']      = 'spells/00135.png', -- 00135 for Reraise
        ['Fleet Wind']      = 'abilities/00074.png', -- 
    }
    -- Flags for code to get around the issue of slow skill updates.
    wards.flag = false
    wards.spell = ''

		state.Moving = M{false, "moving"}		
end

function file_unload ()
	windower.send_command('sta !packets')
end
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')
    state.HybridMode:options('Normal', 'Nirvana')
	
    gear.perp_staff = {name="Gridarvor"}

    state.AutoDeploy = M(true, "Auto Deploy")

		
    state.CP = M(false, "CP") 
    CP_CAPE = "Aptitude Mantle" 

	send_command('wait 2; input /lockstyleset 1')

end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast Sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Astral Flow'] = {head="Glyphic Horn +2"}
    
    sets.precast.JA['Elemental Siphon'] = {
	main="Chatoyant Staff",
    ammo="Esper Stone +1",
    head="Con. Horn +1",
    body="Inyanga Jubbah +2",
    hands="Serpentes Cuffs",
    legs="Gyve Trousers",
    feet="Beckoner's pigaches +1",
    neck="Caller's Pendant",
    waist="Ligeia Sash",
    left_ear="Lodurr Earring",
    right_ear="Smn. Earring",
    left_ring="Zodiac Ring",
    right_ring="Evoker's Ring",
    sub="Vox Grip",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +5','Pet: Enmity+15','Blood Pact Dmg.+2','Blood Pact ab. del. II -1',}}}
        
    sets.precast.JA['Mana Cede'] = {hands="Beckoner's Bracers +1"}

    -- Pact delay reduction gear
    sets.precast.BloodPactWard = {    
	    main={ name="Espiritus", augments={'Enmity-6','Pet: "Mag.Atk.Bns."+30','Pet: Damage taken -4%',}},
    ammo="Sancus Sachet +1",
    head={ name="Glyphic Horn +2", augments={'Enhances "Astral Flow" effect',}},
    body="Con. Doublet +1",
    hands={ name="Glyphic Bracers +2", augments={'Inc. Sp. "Blood Pact" magic burst dmg.',}},
    legs={ name="Glyphic Spats +2", augments={'Increases Sp. "Blood Pact" accuracy',}},
    feet={ name="Glyph. Pigaches +2", augments={'Inc. Sp. "Blood Pact" magic crit. dmg.',}},
    left_ear="Caller's Earring",
    sub="Vox Grip",
    right_ear="Evans Earring",
    back="Samanisi Cape",
		}

    sets.precast.BloodPactRage = sets.precast.BloodPactWard

    -- Fast cast sets for spells
    
    sets.precast.FC = {
	    main="Mafic Cudgel",
    ammo="Impatiens",
    head="Nahtirah Hat",
    body="Inyanga Jubbah +2",
	hands="Carbuncle's cuffs",
    legs={ name="Lengo Pants", augments={'INT+7','Mag. Acc.+7','"Mag.Atk.Bns."+3','"Refresh"+1',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+29','Mag. crit. hit dmg. +8%','INT+4','Mag. Acc.+12',}},
    neck="Voltsurge torque",
	waist="Embla Sash",
    left_ear="Loquac. Earring",
    right_ear="Halasz Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
    sub="Culminus",
    back="Swith Cape",}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})	

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
    ammo="Quartz Tathlum +1",
    head="Inyanga Tiara +2",
    body="Inyanga Jubbah +2",
    hands="Inyan. Dastanas +2",
    legs="Inyanga Shalwar +2",
    feet="Inyan. Crackows +2",
    neck="Fotia Gorget",
    waist="Acuity Belt",
    left_ear="Ishvara Earring",
    right_ear="Flashward Earring",
    left_ring="Freke Ring",
    right_ring="Karieyh Ring",
    back="Aurist's Cape",}

	sets.precast.WS['Spirit Taker'] = {
	set_combine(sets.precast.WS, {neck="imbodla necklace"
	})}
	
	sets.precast.WS['Garland of Bliss'] = {
    ammo="Quartz Tathlum +1",
    head="Inyanga Tiara +2",
    body="Inyanga Jubbah +2",
    hands="Inyan. Dastanas +2",
    legs="Inyanga Shalwar +2",
    feet="Inyan. Crackows +2",
    neck="Imbodla Necklace",
    waist="Salire Belt",
    left_ear="Ishvara Earring",
    right_ear="Flashward Earring",
    left_ring="Stikini Ring +1",
    right_ring="Karieyh Ring",
    back="Tuilha Cape",}
	
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Myrkr'] = {
        head="Nahtirah Hat",ear1="Gifted Earring",ear2="Loquacious Earring",
        body="Convoker's Doublet +2",hands="beckoner's bracers +1",ring1="Evoker's Ring",ring2="Sangoma Ring",
        back="Pahtli Cape",waist="Fucho-no-Obi",legs="Nares Trews",feet="Chelona Boots +1"}

    
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = set_combine(sets.precast.FC, {hands="tali'ah gages +2"}
	)

    sets.midcast.Cure = {    main="Tamaxchi",
    ammo="Quartz Tathlum +1",
    legs="Gyve Trousers",
    feet="Skaoi Boots",
    neck="Imbodla Necklace",
    waist="Salire Belt",
    left_ear="Lifestorm Earring",
    right_ear="Mendi. Earring",
    left_ring="Naji's Loop",
    sub="Culminus",
    back="Solemnity Cape",}

    sets.midcast.Stoneskin = {waist="Siegel Sash"}

    sets.midcast['Elemental Magic'] = {main="Lehbrailg +2",sub="Wizzan Grip",
        head="Hagondes Hat",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="inyanga jubbah +2",hands="Yaoyotl Gloves",ring1="Icesoul Ring",ring2="Acumen Ring",
        back="Toro Cape",waist=gear.ElementalBelt,legs="Hagondes Pants",feet="Hagondes Sabots"}

    sets.midcast['Dark Magic'] = {main="Lehbrailg +2",sub="Wizzan Grip",
        head="Nahtirah Hat",neck="Aesir Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Excelsis Ring",ring2="Sangoma Ring",
        waist="Fuchi-no-Obi",legs="Bokwus Slops",feet="Bokwus Boots"}


    -- Avatar pact sets.  All pacts are Ability type.
    
    sets.midcast.Pet.BloodPactWard = {
    main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
    head="Con. Horn +2",
    body="Beck. Doublet +1",
    hands={ name="Glyphic Bracers +2", augments={'Inc. Sp. "Blood Pact" magic burst dmg.',}},
    legs="Beck. Spats +1",
    neck="Caller's Pendant",
    waist="Lucidity Sash",
    left_ear="Smn. Earring",
    right_ear="Lodurr Earring",
    left_ring="Stikini Ring +1",
    sub="Vox Grip",
    right_ring="Evoker's Ring",
    back={ name="Conveyance Cape", augments={'Summoning magic skill +5','Pet: Enmity+15','Blood Pact Dmg.+2','Blood Pact ab. del. II -1',}},}

    
    sets.midcast.Pet.PhysicalBloodPactRage = {
	    main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
    ammo="Sancus Sachet +1",
    head={ name="Apogee Crown +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
    body="Con. Doublet +2",
    hands={ name="Apogee Mitts +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
    legs={ name="Apogee Slacks +1", augments={'Pet: STR+20','Blood Pact Dmg.+14','Pet: "Dbl. Atk."+4',}},
    feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
    neck="Shulmanu Collar",
    waist="Regal Belt",
    left_ear="Gelos Earring",
    right_ear="Lugalbanda Earring",
    left_ring="Varar Ring +1",
    sub="Elan Strap +1",
    right_ring="Varar Ring +1",
    back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+5 Pet: Rng.Atk.+5','Pet: Haste+10','Pet: Damage taken -2%',}},}

    sets.midcast.Pet.PhysicalBloodPactRage.Acc = sets.midcast.Pet.PhysicalBloodPactRage

    sets.midcast.Pet.MagicalBloodPactRage = {
	main="Grioavolr",
    ammo="Epitaph",
    head="C. Palug Crown",
    neck="Smn. Collar +2",
    ear1="Lugalbanda Earring",
    ear2="Beck. Earring +1",
    body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
    hands={ name="Apogee Mitts +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
    ring1="Varar Ring +1",
    sub="Elan Strap +1",
    ring2="Varar Ring +1",
    back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: Haste+10',}},
    waist="Regal Belt",
    legs="Enticer's Pants",
    feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},}

    sets.midcast.Pet.MagicalBloodPactRage.Acc = sets.midcast.Pet.MagicalBloodPactRage


    -- Spirits cast magic spells, which can be identified in standard ways.
    
    sets.midcast.Pet.WhiteMagic = {legs="glyphic spats +2"}
    
    sets.midcast.Pet['Elemental Magic'] = set_combine(sets.midcast.Pet.BloodPactRage, {legs="glyphic spats +2"})

    sets.midcast.Pet['Elemental Magic'].Resistant = {}
    

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
    
    -- Resting sets
    sets.resting = {
	    main="Chatoyant Staff",
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body={ name="Merlinic Jubbah", augments={'AGI+9','"Dbl.Atk."+1','"Refresh"+2','Accuracy+6 Attack+6','Mag. Acc.+11 "Mag.Atk.Bns."+11',}},
    hands="Serpentes Cuffs",
    legs="Menhit Slacks",
	feet="serpentes sabots",
    neck="Eidolon Pendant +1",
    waist="Austerity Belt",
    right_ear={ name="Moonshade Earring", augments={'MP+25','Latent effect: "Refresh"+1',}},
    left_ring="Stikini Ring +1",
    sub="Elan Strap +1",
    right_ring="Stikini Ring +1",}
    
    -- Idle sets
    sets.idle = {
	    main="Mafic Cudgel",
    sub="Genmei Shield",
    ammo="staunch tathlum +1",
    head="Inyanga Tiara +2",
    body="Udug Jacket",
    hands="Inyan. Dastanas +2",
    legs="Tali'ah seraweels +2",
    feet="crier's gaiters",
    neck="Twilight Torque",
    waist="Regal Belt",
    left_ear="Ethereal Earring",
    right_ear="Etiolation Earring",
    left_ring="Sheltered Ring",
    right_ring="Defending Ring",
    back="Solemnity Cape",}

    sets.idle.PDT = {main=gear.Staff.PDT,sub="Achaq Grip",ammo="sancus sachet +1",
        head="Convoker's Horn +2",neck="Twilight Torque",ear1="Gifted Earring",ear2="Loquacious Earring",
        body="inyanga jubbah +2",hands="Yaoyotl Gloves",ring1="Defending Ring",ring2="Sangoma Ring",
        back="Umbra Cape",waist="Fucho-no-Obi",legs="Hagondes Pants",feet="crier's Gaiters"}

	sets.idle.town = {feet="crier's gaiters"}
    -- perp costs:
    -- spirits: 7
    -- carby: 11 (5 with mitts)
    -- fenrir: 13
    -- others: 15
    -- avatar's favor: -4/tick
    
    -- Max useful -perp gear is 1 less than the perp cost (can't be reduced below 1)
    -- Aim for -14 perp, and refresh in other slots.
    
    -- -perp gear:
    -- Gridarvor: -5
    -- Glyphic Horn: -4
    -- Caller's Doublet +2/Glyphic Doublet +1: -4
    -- Evoker's Ring: -1
    -- Convoker's Pigaches +1: -4
    -- total: -18
    
    -- Can make due without either the head or the body, and use +refresh items in those slots.
    
    sets.idle.Avatar = {
		main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
		ammo="Sancus Sachet +1",
		head="Beckoner's Horn +1",
		body="Beck. Doublet +1",
		hands="Beck. Bracers +1",
		legs={ name="Lengo Pants", augments={'INT+7','Mag. Acc.+7','"Mag.Atk.Bns."+3','"Refresh"+1',}},
		feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
		neck="Caller's Pendant",
		waist="Fucho-no-Obi",
		left_ear="Evans Earring",
		right_ear={ name="Moonshade Earring", augments={'MP+25','Latent effect: "Refresh"+1',}},
		left_ring="Evoker's Ring",
		right_ring="Stikini Ring +1",
		sub="Elan Strap +1",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+13 Pet: R.Acc.+13 Pet: Atk.+13 Pet: R.Atk.+13','Accuracy+20 Attack+20','Pet: Haste+10',}},}

    sets.idle.PDT.Avatar = {
		main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
		ammo="Sancus Sachet +1",
		head={ name="Apogee Crown", augments={'Pet: Accuracy+20','"Avatar perpetuation cost"+5','Pet: Damage taken -3%',}},
		body={ name="Apogee Dalmatica", augments={'Summoning magic skill +15','Enmity-5','Pet: Damage taken -3%',}},
		hands={ name="Artsieq Cuffs", augments={'MP+30','Pet: Attack+20','Pet: Accuracy+20',}},
		legs="Tali'ah Sera. +2",
		feet={ name="Telchine Pigaches", augments={'Pet: Attack+20 Pet: Rng.Atk.+20','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		neck="Caller's Pendant",
		waist="Regal Belt",
		left_ear="Enmerkar Earring",
		right_ear="Hypaspist Earring",
		left_ring="Stikini Ring +1",
		sub="Vox Grip",
		right_ring="Stikini Ring +1",
		back={ name="Campestres's Cape", augments={'Pet: "Regen"+3',}},}

    sets.idle.Spirit = {
	    main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
    ammo="Sancus Sachet +1",
    head={ name="Glyphic Horn +2", augments={'Enhances "Astral Flow" effect',}},
    body="Beck. Doublet +1",
    hands="Beck. Bracers +1",
    legs={ name="Glyphic Spats +2", augments={'Increases Sp. "Blood Pact" accuracy',}},
    feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
    neck="Caller's Pendant",
    waist="Lucidity Sash",
    left_ear="Evans Earring",
    right_ear={ name="Moonshade Earring", augments={'MP+25','Latent effect: "Refresh"+1',}},
    left_ring="Evoker's Ring",
    right_ring="Stikini Ring +1",
    back={ name="Campestres's Cape", augments={'Pet: "Regen"+3',}},
    sub="Vox Grip",}


    -- Favor uses Caller's Horn instead of Convoker's Horn +1 for refresh
    sets.idle.Avatar.Favor = {head="beckoner's horn +1"}
    sets.idle.Avatar.Melee = {
	    main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
    ammo="Sancus Sachet +1",
    head="Convoker's Horn +2",
    body={ name="Glyphic Doublet +2", augments={'Reduces Sp. "Blood Pact" MP cost',}},
    hands={ name="Glyphic Bracers +2", augments={'Inc. Sp. "Blood Pact" magic burst dmg.',}},
    legs="Convo. Spats +2",
    feet={ name="Telchine Pigaches", augments={'Pet: Attack+20 Pet: Rng.Atk.+20','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Domes. Earring",
    right_ear="Rimeice Earring",
    left_ring="Varar Ring +1",
    sub="Vox Grip",
    right_ring="Varar Ring +1",
    back={ name="Campestres's Cape", augments={'Pet: Acc.+13 Pet: R.Acc.+13 Pet: Atk.+13 Pet: R.Atk.+13','Accuracy+20 Attack+20','Pet: Haste+10',}},}
        
    sets.perp = {
	main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
    ammo="Sancus Sachet +1",
    head="Beckoner's Horn +1",
    body="Udug Jacket",
    hands="Convo. Bracers +2",
    legs={ name="Lengo Pants", augments={'INT+7','Mag. Acc.+7','"Mag.Atk.Bns."+3','"Refresh"+1',}},
    feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
    neck="Twilight Torque",
    waist="Fucho-no-Obi",
    left_ear={ name="Moonshade Earring", augments={'MP+25','Latent effect: "Refresh"+1',}},
    right_ear="Evans Earring",
    left_ring="Stikini Ring +1",
    right_ring="Evoker's Ring",
    back="Solemnity Cape",    
	sub="Vox Grip",}
    -- Caller's Bracer's halve the perp cost after other costs are accounted for.
    -- Using -10 (Gridavor, ring, Conv.feet), standard avatars would then cost 5, halved to 2.
    -- We can then use inyanga jubbah +2 and end up with the same net MP cost, but significantly better defense.
    -- Weather is the same, but we can also use the latent on the pendant to negate the last point lost.
    sets.perp.Day = {hands="beckoner's bracers +1"}
    sets.perp.Weather = {neck="Caller's Pendant", hands="beckoner's bracers +1"}
    -- Carby: Mitts+Conv.feet = 1/tick perp.  Everything else should be +refresh
    sets.perp.Carbuncle = set_combine(sets.perp, {{main="Bolelabunga",sub="Genmei Shield",
        hands="Asteria mitts +1"}})
    -- Diabolos's Rope doesn't gain us anything at this time
    --sets.perp.Diabolos = {waist="Diabolos's Rope"}
    sets.perp.Alexander = sets.midcast.Pet.BloodPactWard

    sets.perp.staff_and_grip = {main=gear.perp_staff,sub="Achaq Grip"}
    
    -- Defense sets
    sets.defense.PDT = {main=gear.Staff.PDT,
        head="Hagondes Hat",neck="Twilight Torque",ear1="Gifted Earring",ear2="Loquacious Earring",
        body="inyanga jubbah +2",hands="Yaoyotl Gloves",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Umbra Cape",waist="Fucho-no-Obi",legs="Hagondes Pants",feet="Hagondes Sabots"}

    sets.defense.MDT = {
        head="Hagondes Hat",neck="Twilight Torque",ear1="Gifted Earring",ear2="Loquacious Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Umbra Cape",waist="Fucho-no-Obi",legs="Bokwus Slops",feet="Hagondes Sabots"}

    sets.Kiting = {feet="crier's Gaiters"}
	sets.MoveSpeed = {feet="crier's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}
    

    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
    -- Normal melee group
    sets.engaged = {
			ammo="Sancus Sachet +1",
		right_ring="Chirich Ring",
		head="Inyanga Tiara +2",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +1",
		legs="Tali'ah Sera. +2",
		feet="Tali'ah Crackows +2",
		neck="Asperity Necklace",
		waist="Cetl Belt",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring",
		back="Kayapa Cape",}

	
	sets.nirvana = {}
	
	sets.engaged.nirvana = {main={ name="Nirvana", augments={'DMG:+11',}},
		sub="Sword Strap",
		ammo="Sancus Sachet +1",
		right_ring="Chirich Ring",
		head="Inyanga Tiara +2",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +1",
		legs="Tali'ah Sera. +2",
		feet="Tali'ah Crackows +2",
		neck="Asperity Necklace",
		waist="Cetl Belt",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring",
		back="Kayapa Cape",}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
windower.register_event('Zone change', 
function(new, old)
	status_change(player.status)
	send_command('gs c reset OffenseMode')
	send_command('gs c reset IdleMode')
	windower.add_to_chat(10,' *** Zoning Reset Mode *** ')
	send_command('input /macro book 15; wait 1;input /macro set 1')
	send_command('gs c update user')
    send_command('wait 5;input /lockstyleset 1')

end)

function job_precast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

-- Runs when pet completes an action.
function job_pet_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.type == 'BloodPactWard' and spellMap ~= 'DebuffBloodPactWard' then
        wards.flag = true
        wards.spell = spell.english
        send_command('wait 4; gs c reset_ward_flag')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    elseif storms:contains(buff) then
        handle_equipping_gear(player.status)
    end
end


-- Called when the player's pet's status changes.
-- This is also called after pet_change after a pet is released.  Check for pet validity.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if pet.isvalid and not midaction() and not pet_midaction() and (newStatus == 'Engaged' or oldStatus == 'Engaged') then
        handle_equipping_gear(player.status, newStatus)
    end
end


-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    classes.CustomIdleGroups:clear()
    if gain then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    end
	
    if gain then
        if pet.name=="Diabolos" then
            send_command('input /macro book 15; wait .1; input /macro set 2')
        elseif pet.name=="Ifrit" then
			send_command('input /macro book 15; wait .1; input /macro set 3')
        elseif pet.name=="Shiva" then
            send_command('input /macro book 15; wait .1; input /macro set 4')
        elseif pet.name=="Garuda" then
            send_command('input /macro book 15; wait .1; input /macro set 5')
        elseif pet.name=="Titan" then
            send_command('input /macro book 15; wait .1; input /macro set 6')
        elseif pet.name=="Ramuh" then
			send_command('input /macro book 15; wait .1; input /macro set 7')
        elseif pet.name=="Leviathan" then
            send_command('input /macro book 15; wait .1; input /macro set 8')
        elseif pet.name=="Fenrir" then
            send_command('input /macro book 15; wait .1; input /macro set 9')
        elseif pet.name=="Carbuncle" then
			send_command('input /macro book 15; wait .1; input /macro set 10')
        elseif pet.name=="Cait Sith" then
			send_command('input /macro book 16; wait .1; input /macro set 10')
        elseif pet.name=="Siren" then
			send_command('input /macro book 16; wait .1; input /macro set 9')			
        end
    else
        send_command('input /macro book 15; wait .1; input /macro set 1')
    end

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell)
    if spell.type == 'BloodPactRage' then
        if magicalRagePacts:contains(spell.english) then
            return 'MagicalBloodPactRage'
        else
            return 'PhysicalBloodPactRage'
        end
    elseif spell.type == 'BloodPactWard' and spell.target.type == 'MONSTER' then
        return 'DebuffBloodPactWard'
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if pet.isvalid then
        if pet.element == world.day_element then
            idleSet = set_combine(idleSet, sets.perp.Day)
        end
        if pet.element == world.weather_element then
            idleSet = set_combine(idleSet, sets.perp.Weather)
        end
        if sets.perp[pet.name] then
            idleSet = set_combine(idleSet, sets.perp[pet.name])
        end
        gear.perp_staff.name = elements.perpetuance_staff_of[pet.element]
        if gear.perp_staff.name and (player.inventory[gear.perp_staff.name] or player.wardrobe[gear.perp_staff.name]) then
            idleSet = set_combine(idleSet, sets.perp.staff_and_grip)
        end
        if state.Buff["Avatar's Favor"] and avatars:contains(pet.name) then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Favor)
        end
        if pet.status == 'Engaged' then
            idleSet = set_combine(sets.nirvana, sets.idle.Avatar.Melee)
		else
			idleSet = set_combine(sets.perp[pet.name], sets.idle.town)
        end
    end
    
    if player.mpp < 91 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

function job_status_change(new, old)
    if new == "Engaged" then
        Player_State = const_stateEngaged
        
        --If we have AutoDeploy turned on and our pet is out then we will auto deploy
        if state.AutoDeploy.value == true and pet.isvalid then
            
            --Gets the current target we have focus on and make sure it isn't null
            --We are also keeping track of the current monster just in case we auto switch
            if windower.ffxi.get_mob_by_target('t').id then
                currentTargetedMonster = windower.ffxi.get_mob_by_target('t').id
            end
				windower.add_to_chat('Auto Deploying Pet')
            send_command('wait 1; input /pet "Assault" <t>')
        end
	end
        --Items we want to check every second
    if pet.isvalid and player.hpp > 0 then
              --Double check current Pet Status and Player Status
                --In some cases Mote's doesn't recognize a pet's status change
        Pet_State = pet.status
        Player_State = player.status

                --If we are in auto deploy and engaged we are going check if we have changed targets
        if Player_State == const_stateEngaged and state.AutoDeploy.value == true then
                    --Save the currentTarget as a previous
            previousTargetedMonster = currentTargetedMonster

                    --Get the new current target
			if windower.ffxi.get_mob_by_target('t') then
				currentTargetedMonster = windower.ffxi.get_mob_by_target('t').id
			end

                    --If the monster ID's are not equal then we changed monsters
			if previousTargetedMonster ~= currentTargetedMonster then
						windower.add_to_chat('Auto Deploying Pet')
					send_command('wait 1;input /pet "Assault" <t>')
			end
		end
                --Now we check if we need to lock our back for CP
        if Player_State == const_stateEngaged and state.CP.value == true then 
                monsterToCheck = windower.ffxi.get_mob_by_target('t') 
            if monsterToCheck then -- Sanity Check 
 
                if monsterToCheck.hpp < 25 then --Check mobs HP Percentage if below 25 then equip CP cape 
                    equip({ back = CP_CAPE }) 
                    disable("back") --Lock back till we disengage
                else 
                    enable("back") --Else make sure the back is enabled
                end 
            end 
        end 
    end

	if  player.hp == 0 then
    send_command('@input /macro book 15;wait 1.1;input /macro set 1')
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'petweather' then
        handle_petweather()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'siphon' then
        handle_siphoning()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'pact' then
        handle_pacts(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1] == 'reset_ward_flag' then
        wards.flag = false
        wards.spell = ''
        eventArgs.handled = true
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

moving = false
windower.raw_register_event('prerender',function()
    mov.counter = mov.counter + 1;
    if mov.counter>15 then
        local pl = windower.ffxi.get_mob_by_index(player.index)
        if pl and pl.x and mov.x then
            dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
            if dist > 1 and not moving then
                state.Moving.value = true
				send_command('gs c update')
                send_command('gs equip sets.MoveSpeed')
                moving = true
				
            elseif dist < 1 and moving then
                state.Moving.value = false
                send_command('gs c update')
                moving = false
            end
        end
        if pl and pl.x then
            mov.x = pl.x
            mov.y = pl.y
            mov.z = pl.z
        end
        mov.counter = 0
    end
end)

-- Cast the appopriate storm for the currently summoned avatar, if possible.
function handle_petweather()
    if player.sub_job ~= 'SCH' then
        add_to_chat(122, "You can not cast storm spells")
        return
    end
        
    if not pet.isvalid then
        add_to_chat(122, "You do not have an active avatar.")
        return
    end
    
    local element = pet.element
    if element == 'Thunder' then
        element = 'Lightning'
    end
    
    if S{'Light','Dark','Lightning'}:contains(element) then
        add_to_chat(122, 'You do not have access to '..elements.storm_of[element]..'.')
        return
    end 
    
    local storm = elements.storm_of[element]
    
    if storm then
        send_command('@input /ma "'..elements.storm_of[element]..'" <me>')
    else
        add_to_chat(123, 'Error: Unknown element ('..tostring(element)..')')
    end
end


-- Custom uber-handling of Elemental Siphon
function handle_siphoning()
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'Cannot use Elemental Siphon in a city area.')
        return
    end

    local siphonElement
    local stormElementToUse
    local releasedAvatar
    local dontRelease
    
    -- If we already have a spirit out, just use that.
    if pet.isvalid and spirits:contains(pet.name) then
        siphonElement = pet.element
        dontRelease = true
        -- If current weather doesn't match the spirit, but the spirit matches the day, try to cast the storm.
        if player.sub_job == 'SCH' and pet.element == world.day_element and pet.element ~= world.weather_element then
            if not S{'Light','Dark','Lightning'}:contains(pet.element) then
                stormElementToUse = pet.element
            end
        end
    -- If we're subbing /sch, there are some conditions where we want to make sure specific weather is up.
    -- If current (single) weather is opposed by the current day, we want to change the weather to match
    -- the current day, if possible.
    elseif player.sub_job == 'SCH' and world.weather_element ~= 'None' then
        -- We can override single-intensity weather; leave double weather alone, since even if
        -- it's partially countered by the day, it's not worth changing.
        if get_weather_intensity() == 1 then
            -- If current weather is weak to the current day, it cancels the benefits for
            -- siphon.  Change it to the day's weather if possible (+0 to +20%), or any non-weak
            -- weather if not.
            -- If the current weather matches the current avatar's element (being used to reduce
            -- perpetuation), don't change it; just accept the penalty on Siphon.
            if world.weather_element == elements.weak_to[world.day_element] and
                (not pet.isvalid or world.weather_element ~= pet.element) then
                -- We can't cast lightning/dark/light weather, so use a neutral element
                if S{'Light','Dark','Lightning'}:contains(world.day_element) then
                    stormElementToUse = 'Wind'
                else
                    stormElementToUse = world.day_element
                end
            end
        end
    end
    
    -- If we decided to use a storm, set that as the spirit element to cast.
    if stormElementToUse then
        siphonElement = stormElementToUse
    elseif world.weather_element ~= 'None' and (get_weather_intensity() == 2 or world.weather_element ~= elements.weak_to[world.day_element]) then
        siphonElement = world.weather_element
    else
        siphonElement = world.day_element
    end
    
    local command = ''
    local releaseWait = 0
    
    if pet.isvalid and avatars:contains(pet.name) then
        command = command..'input /pet "Release" <me>;wait 1.1;'
        releasedAvatar = pet.name
        releaseWait = 10
    end
    
    if stormElementToUse then
        command = command..'input /ma "'..elements.storm_of[stormElementToUse]..'" <me>;wait 4;'
        releaseWait = releaseWait - 4
    end
    
    if not (pet.isvalid and spirits:contains(pet.name)) then
        command = command..'input /ma "'..elements.spirit_of[siphonElement]..'" <me>;wait 4;'
        releaseWait = releaseWait - 4
    end
    
    command = command..'input /ja "Elemental Siphon" <me>;'
    releaseWait = releaseWait - 1
    releaseWait = releaseWait + 0.1
    
    if not dontRelease then
        if releaseWait > 0 then
            command = command..'wait '..tostring(releaseWait)..';'
        else
            command = command..'wait 1.1;'
        end
        
        command = command..'input /pet "Release" <me>;'
    end
    
    if releasedAvatar then
        command = command..'wait 1.1;input /ma "'..releasedAvatar..'" <me>'
    end
    
    send_command(command)
end


-- Handles executing blood pacts in a generic, avatar-agnostic way.
-- cmdParams is the split of the self-command.
-- gs c [pact] [pacttype]
function handle_pacts(cmdParams)
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'You cannot use pacts in town.')
        return
    end

    if not pet.isvalid then
        add_to_chat(122,'No avatar currently available. Returning to default macro set.')
        select_default_macro_book(1,15)
        return
    end

    if spirits:contains(pet.name) then
        add_to_chat(122,'Cannot use pacts with spirits.')
        return
    end

    if not cmdParams[2] then
        add_to_chat(123,'No pact type given.')
        return
    end
    
    local pact = cmdParams[2]:lower()
    
    if not pacts[pact] then
        add_to_chat(123,'Unknown pact type: '..tostring(pact))
        return
    end
    
    if pacts[pact][pet.name] then
        if pact == 'astralflow' and not buffactive['astral flow'] then
            add_to_chat(122,'Cannot use Astral Flow pacts at this time.')
            return
        end
        
        -- Leave out target; let Shortcuts auto-determine it.
        send_command('@input /pet "'..pacts[pact][pet.name]..'"')
    else
        add_to_chat(122,pet.name..' does not have a pact of type ['..pact..'].')
    end
end


-- Event handler for updates to player skill, since we can't rely on skill being
-- correct at pet_aftercast for the creation of custom timers.
windower.raw_register_event('incoming chunk',
    function (id)
        if id == 0x62 then
            if wards.flag then
                create_pact_timer(wards.spell)
                wards.flag = false
                wards.spell = ''
            end
        end
    end)

-- Function to create custom timers using the Timers addon.  Calculates ward duration
-- based on player skill and base pact duration (defined in job_setup).
function create_pact_timer(spell_name)
    -- Create custom timers for ward pacts.
    if wards.durations[spell_name] then
        local ward_duration = wards.durations[spell_name]
        if ward_duration < 181 then
            local skill = player.skills.summoning_magic
            if skill > 300 then
                skill = skill - 300
                if skill > 200 then skill = 200 end
                ward_duration = ward_duration + skill
            end
        end
        
        local timer_cmd = 'timers c "'..spell_name..'" '..tostring(ward_duration)..' down'
        
        if wards.icons[spell_name] then
            timer_cmd = timer_cmd..' '..wards.icons[spell_name]
        end

        send_command(timer_cmd)
    end
end

function customize_melee_set(meleeSet)
    if state.HybridMode.current == 'Nirvana' then
        meleeSet = set_combine(sets.engaged, sets.engaged.nirvana)
    end
    return meleeSet
end
