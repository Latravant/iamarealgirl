function user_job_setup() 
	-- Options: Override default values
    state.OffenseMode:options('Normal','Acc')
	state.HybridMode:options('Normal','DT')
    state.WeaponskillMode:options('Match','Normal','Acc')
    state.CastingMode:options('Normal','SIRD','Resistant','FullMacc','Proc')
    state.IdleMode:options('Normal','PDT')
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	state.ResistDefenseMode:options('MEVA')
	state.Weapons:options('Tizalmace','Naegmace','Iris2','AlmaceSeq','MeleeClubs','HybridWeapons','Naegbron','Tizbron','None')

    state.ExtraMeleeMode = M{['description']='Extra Melee Mode','None','MP','SuppaBrutal','DWEarrings','DWMax'}

	gear.da_jse_back = {name="Rosmerta's Cape",augments={'DEX+20','Accuracy+20 Attack+20','Dex+1','"Dbl.Atk."+10',}} -- Dex+20, ACC+20
	gear.stp_jse_back = {name="Rosmerta's Cape",augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
	gear.wsd_jse_back = {name="Rosmerta's Cape",augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	gear.nuke_jse_back = {name="Rosmerta's Cape",augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}}

	autows = 'Expiacion'

	-- Additional local binds
	send_command('bind @f10 gs c toggle LearningMode')

		state.Moving = M{false, "moving"}
		
	select_default_macro_book()
	send_command('gs c enable all')	
	send_command('wait 2; input /lockstyleset 2')			
	send_command('wait 1; gs org')
end

function init_gear_sets()

	--------------------------------------
	-- Start defining the sets
	--------------------------------------

	sets.buff['Burst Affinity'] = {legs="Assim. Shalwar +3",feet="Hashi. Basmak +1"}
	sets.buff['Chain Affinity'] = {feet="Assim. Charuqs +3"}
	sets.buff.Convergence = {head="Luh. Keffiyeh +3"}
	sets.buff.Diffusion = {feet="Luhlaza Charuqs +3"}
	sets.buff.Enchainment = {}
	sets.buff.Efflux = {back=gear.da_jse_back,legs="Hashishin Tayt +1"}
	sets.buff.Doom = set_combine(sets.buff.Doom, {})

	-- Precast Sets

	-- Precast sets to enhance JAs
	sets.precast.JA['Azure Lore'] = {hands="Luh. Bazubands +3"}

	-- Fast cast sets for spells

	sets.precast.FC = {main="Colada", sub="Colada", ammo="Sapience Orb", 
		head="Carmine Mask +1", body="Luhlaza Jubbah +3", hands="Leyline Gloves", legs="Aya. Cosciales +2",
		feet="Carmine Greaves +1", neck="Loricate Torque +1", waist="Witful Belt", left_ear="Etiolation Earring",
		right_ear="Loquac. Earring", left_ring="Prolix Ring", right_ring="Kishar Ring", back="Swith Cape",}

	sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})


	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {ammo="Ginsen",
		head="Hashishin Kavuk +2", body=gear.adhemar_B_body, hands="Jhakri Cuffs +2",
		legs="Luh. Shalwar +3", feet="Carmine Greaves +1", neck="Fotia Gorget",
		waist="Fotia Belt", left_ear="Telos Earring", right_ear="Brutal Earring",
		left_ring="Epona's Ring", right_ring="Petrov Ring", back=gear.wsd_jse_back}

	sets.precast.WS.DT = {ammo="Ginsen",
		head="Malignance Chapeau", body="Malignance Tabard", hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2", feet="Aya. Gambieras +2", neck="Loricate Torque +1",
		waist="Fotia Belt", left_ear="Telos Earring", right_ear="Brutal Earring",
		left_ring="Defending Ring", right_ring="Ilabrat Ring", back="Agema Cape",}
	
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {head="Jhakri Coronal +2",ear1="Lifestorm earring",body="Jhakri Robe +2",ring2="Metamorph Ring +1",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.precast.WS['Requiescat'].DT = set_combine(sets.precast.WS.DT, {})

	sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS, {head="Jhakri Coronal +2",ear1="Lifestorm earring",body="Jhakri Robe +2",ring2="Metamorph Ring +1",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.precast.WS['Realmrazer'].DT = set_combine(sets.precast.WS.DT, {})

	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {ammo="Falcon Eye",head=gear.adhemar_B_head,neck="Mirage Stole +2",ear1="Moonshade Earring",ear2="Odr Earring",body="Assimilator's jubbah +3",hands=gear.adhemar_B_hands,ring2="Hetairoi Ring",back=gear.crit_jse_back,feet="Ayanmo gambieras +2"})
	sets.precast.WS['Chant du Cygne'].DT = set_combine(sets.precast.WS.DT, {back=gear.crit_jse_back})

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {neck="Mirage Stole +2",ear1="Moonshade Earring",ear1="Ishvara Earring",body="Assim. Jubbah +3",hands="Jhakri Cuffs +2",ring1="Metamorph Ring +1",back=gear.wsd_jse_back,waist="Sailfi Belt +1",legs="Luh. Shalwar +3",feet=gear.herculean_wsd_feet})
	sets.precast.WS['Savage Blade'].DT = set_combine(sets.precast.WS.DT, {back=gear.wsd_jse_back})

	sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
	sets.precast.WS['Vorpal Blade'].DT = sets.precast.WS['Chant du Cygne'].DT

	sets.precast.WS['Expiacion'] = set_combine(sets.precast.WS, {head=gear.adhemar_B_head,neck="Mirage Stole +2",ear1="Moonshade Earring",ear2="Ishvara Earring",body="Assim. Jubbah +3",hands="Jhakri Cuffs +2",ring1="Metamorph Ring +1",back=gear.wsd_jse_back,waist="Sailfi Belt +1",legs="Luh. Shalwar +3",feet=gear.herculean_wsd_feet})
	sets.precast.WS['Expiacion'].DT = set_combine(sets.precast.WS.DT, {back=gear.wsd_jse_back})


	sets.precast.WS['Flash Nova'] = {ammo="Ghastly Tathlum +1",
			         head="Jhakri Coronal +2",neck="Baetyl Pendant",ear1="Regal Earring",ear2="Friomisi Earring",
		             body="Amalric Doublet +1",hands="Jhakri Cuffs +2",ring1="Metamor. Ring +1",ring2="Shiva Ring +1",
			         back=gear.nuke_jse_back,waist="Yamabuki-no-Obi",legs="Luh. Shalwar +3",feet="Amalric Nails +1"}
					 

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Cessance Earring",ear2="Brutal Earring"}
	sets.AccMaxTP = {ear1="Regal Earring",ear2="Telos Earring"}

	-- Midcast Sets
	sets.midcast.FastRecast = {main="Colada",sub="Colada",ammo="Hasty Pinion +1",
		head="Carmine Mask +1",ear1="Etiolation earring",ear2="Loquac. Earring",
		body="Luhlaza Jubbah +3",hands="Leyline Gloves",ring1="Kishar Ring",ring2="Prolix Ring",
		back="Swith Cape",waist="Witful Belt",legs="Ayanmo cosciales +2",feet="Carmine Greaves +1"}

	sets.midcast['Blue Magic'] = {}

	-- Physical Spells --

	sets.midcast['Blue Magic'].Physical = {main="Naegling", sub="Iris", ammo="Ginsen",
		head="Assim. Keffiyeh +3", body="Assim. Jubbah +3", hands="Assim. Bazu. +3",
		legs="Assim. Shalwar +3", feet="Assim. Charuqs +3", neck="Caro Necklace",
		waist="Caudata Belt", left_ear="Telos Earring", right_ear="Ethereal Earring",
		left_ring="Dagaz Ring", right_ring="Ilabrat Ring",	back="Buquwik Cape",}

	sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical, {})

	sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {})

	sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical, {})

	sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {})

	sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {})

	sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {})

	sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {})

	sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical, {})

	-- Magical Spells --

	sets.midcast['Blue Magic'].Magical = {main="Maxentius", sub="Kaja Rod", ammo="Ghastly Tathlum +1",
		head="Jhakri Coronal +2", body="Amalric Doublet +1", hands="Amalric Gages +1", 
		legs="Luh. Shalwar +3", feet="Amalric Nails +1", neck="Eddy Necklace",
		waist="Hachirin-no-Obi", left_ear="Novio Earring", right_ear="Friomisi Earring",	
		left_ring="Metamor. Ring +1", right_ring="Shiva Ring +1", back="Cornflower Cape"}
		 
	sets.midcast['Blue Magic'].Magical.SIRD = set_combine(sets.midcast['Blue Magic'].Magical, {ammo="Staunch Tathlum +1",
		 neck="Loricate Torque +1", ring1="Defending Ring",ring2="Metamor. Ring +1", waist="Emphatikos Rope",
		 legs="Carmine Cuisses +1"})
		 
	sets.midcast['Blue Magic'].Subduction = set_combine(sets.midcast['Blue Magic'].Magical, {
		 legs="Luh. Shalwar +3"})
					 
	sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {ring2="Stikini Ring +1"})
	sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {})
	sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})
	sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {})

	sets.midcast['Blue Magic'].MagicAccuracy = {main="Maxentius", sub="Kaja Rod", ammo="Pemphredo Tathlum",
		head="Assim. Keffiyeh +3", body="Malignance Tabard", hands="Aya. Manopolas +2",
		legs="Assim. Shalwar +3", feet="Luhlaza Charuqs +3", neck="Mirage Stole +2",
		waist="Acuity Belt +1", left_ear="Gwati Earring", right_ear="Njordr Earring",
		left_ring="Stikini Ring +1", right_ring="Stikini Ring +1", back="Cornflower Cape"}
		
	sets.element.Dark = {head="Pixie Hairpin +1",ring2="Archon Ring"}
	sets.element.Light = {} --ring2="Weatherspoon Ring"

	-- Breath Spells --

	sets.midcast['Blue Magic'].Breath = {main="Iris", sub="Iris", ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +3", body="Assim. Jubbah +3", hands="Luh. Bazubands +3",
		legs="Assim. Shalwar +3", feet="Assim. Charuqs +3", neck="Ardor Pendant +1",
		waist="Glassblower's Belt", left_ear="Etiolation Earring", right_ear="Njordr Earring",
		left_ring="K'ayres Ring", right_ring="Ilabrat Ring", back="Reiki Cloak",}

	-- Physical Added Effect Spells most notably "Stun" spells --

	sets.midcast['Blue Magic'].Stun = {main="Naegling", sub="Maxentius", ammo="Pemphredo Tathlum",
		head="Malignance Chapeau", body="Malignance Tabard", hands="Aya. Manopolas +2",
		legs="Assim. Shalwar +3", feet="Jhakri Pigaches +2", neck="Mirage Stole +2",
		waist="Acuity Belt +1", left_ear="Hermetic Earring", right_ear="Gwati Earring",
		left_ring="Metamor. Ring +1", right_ring="Stikini Ring +1", back="Aurist's Cape +1"}

	-- Other Specific Spells --

	sets.midcast['Blue Magic'].AoEHealing = {main="Tamaxchi", sub="Culminus", ammo="Charitoni Sling",
		head="Telchine Cap", body="Telchine Chas.", hands="Telchine Gloves",
		legs="Telchine Braconi", feet="Telchine Pigaches", neck="Unmoving Collar +1",
		waist="Glassblower's Belt", left_ear="Etiolation Earring", right_ear="Upsurge Earring",
		left_ring="K'ayres Ring", right_ring="Ilabrat Ring", back="Agema Cape",}

	sets.midcast['Blue Magic'].Healing = {main="Maxentius", sub="Tamaxchi", ammo="Quartz Tathlum +1",
		head="Assim. Keffiyeh +3", body="Telchine Chas.", hands="Telchine Gloves", 
		legs="Gyve Trousers", feet="Skaoi Boots", neck="Imbodla Necklace", 
		waist="Rumination Sash", left_ear="Mendi. Earring", right_ear="Lifestorm Earring",
		left_ring="Stikini Ring +1", right_ring="Metamor. Ring +1", back="Solemnity Cape",}
		
	sets.midcast['Blue Magic'].SkillBasedBuff = {main="Iris", sub="Iris", ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +3", body="Assim. Jubbah +3", legs="Hashishin Tayt +1",
		feet="Luhlaza Charuqs +3", neck="Mirage Stole +2", waist="Witful Belt", 
		left_ear="Calamitous Earring", right_ear="Njordr Earring", 
		left_ring="Stikini Ring +1", right_ring="Stikini Ring +1", back="Cornflower Cape",}

	sets.midcast['Blue Magic'].Buff = {main="Vampirism",sub="Vampirism",ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +3",neck="Incanter's Torque",ear1="Gifted Earring",ear2="Loquac. Earring",
		body="Assim. Jubbah +3",hands="Hashi. Bazu. +1",ring1="Kishar Ring",ring2="Dark Ring",
		back="Aurist's Cape +1",waist="Witful Belt",legs="Lengo Pants",feet="Carmine Greaves +1"}

	sets.midcast['Blue Magic']['Battery Charge'] = set_combine(sets.midcast['Blue Magic'].Buff, {head="Amalric Coif +1",back="Grapevine Cape",waist="Gishdubar Sash"})

	sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {head="Amalric Coif +1",hands="Regal Cuffs",waist="Emphatikos Rope",legs="Shedir Seraweels"})

	-- Sets to return to when not performing an action.

	sets.latent_refresh = {waist="Fucho-no-obi"}
	sets.DayIdle = {}
	sets.NightIdle = {}

	-- Gear for learning spells: +skill and AF hands.
	sets.Learning = {main="Iris", sub="Iris", ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +3", body="Assim. Jubbah +3", hands="Assim. Bazubands +3",
		legs="Hashishin Tayt +1", feet="Luhlaza Charuqs +3", neck="Mirage Stole +2", 
		waist="Witful Belt", left_ear="Calamitous Earring", right_ear="Njordr Earring", 
		left_ring="Stikini Ring +1", right_ring="Stikini Ring +1", back="Cornflower Cape",}
    
	-- Idle sets
	sets.idle = {main="Bolelabunga",sub="Genmei Shield",ammo="Staunch Tathlum +1",
		head="Nyame Helm", body="Shamash Robe", hands="Volte Bracers",
		legs="Volte Hose", feet="Nyame Sollerets", neck="Warder's Charm +1",
		waist="Carrier's Sash", left_ear="Etiolation Earring", right_ear="Hearty Earring",
		left_ring="Defending Ring", right_ring="Vengeful Ring", back="Solemnity Cape",}

	sets.idle.lowmp = {main="Bolelabunga",sub="Genmei Shield",ammo="Staunch Tathlum +1",
		neck="Loricate Torque +1",ear1="Etiolation Earring", ear2="Ethereal Earring",
		body="Jhakri Robe +2",ring1="Stikini Ring +1",
		waist="Flume Belt +1",legs="Lengo Pants",ring2="Stikini Ring +1",}
				  
	sets.idle.PDT = {main="Mafic Cudgel", sub="Genmei Shield", ammo="Staunch Tathlum +1",
		head="Nyame Helm", body="Shamash Robe", hands="Volte Bracers",
		legs="Nyame Flanchard", feet="Nyame Sollerets", neck="Loricate Torque +1",
		waist="Flume Belt +1", left_ear="Etiolation Earring", right_ear="Hearty Earring",
		left_ring="Defending Ring", right_ring="Succor Ring", back="Solemnity Cape",}

	-- Defense sets
	sets.defense.PDT = {main="Mafic Cudgel", sub="Genmei Shield", ammo="Staunch Tathlum +1",
		head="Nyame Helm", body="Shamash Robe", hands="Nyame Gauntlets",
		legs="Nyame Flanchard", feet="Nyame Sollerets", neck="Loricate Torque +1",
		waist="Flume Belt +1", left_ear="Njordr Earring", right_ear="Thureous Earring",
		left_ring="Defending Ring", right_ring="Succor Ring", back="Solemnity Cape",}

	sets.defense.MDT = {main="Bolelabunga",sub="Genmei Shield",ammo="Staunch Tathlum +1",
		head="Nyame Helm", body="Malignance Tabard", hands="Nyame Gauntlets",
		legs="Nyame Flanchard", feet="Nyame Sollerets", neck="Warder's Charm +1",
		waist="Carrier's Sash", ear1="Etiolation Earring", right_ear="Hearty Earring",
		left_ring="Defending Ring", right_ring="Succor Ring", back="Solemnity Cape",}
		
    sets.defense.MEVA = {main="Bolelabunga",sub="Genmei Shield",ammo="Staunch Tathlum +1",
        head="Nyame Helm",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Sanare Earring",
		body="Malignance Tabard",hands="Leyline Gloves",ring1="Vengeful Ring",ring2="Purity Ring",
        back=gear.nuke_jse_back,waist="Carrier's Sash",legs="Telchine Braconi",feet="Malignance Boots"}

	sets.defense.NukeLock = sets.midcast['Blue Magic'].Magical

	sets.Kiting = {legs="Carmine Cuisses +1"}

    -- Extra Melee sets.  Apply these on top of melee sets.
    sets.Knockback = {}
    sets.MP = {waist="Flume Belt +1",ear1="Suppanomimi", ear2="Ethereal Earring"}
    sets.MP_Knockback = {}
	sets.SuppaBrutal = {ear1="Suppanomimi", ear2="Brutal Earring"}
	sets.DWMax = {ear1="Dudgeon Earring",ear2="Heartseeker Earring",body=gear.adhemar_B_body,waist="Reiki Yotai",legs="Carmine Cuisses +1"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {})
	
	-- Weapons sets
	sets.weapons.Tizalmace = {main="Tizona",sub="Almace"}
	sets.weapons.Tizbron = {main="Tizona",sub="Thibron"}
	sets.weapons.MeleeClubs = {main="Maxentius",sub="Kaja Rod"}
	sets.weapons.AlmaceSeq = {main="Almace",sub="Sequence"}
	sets.weapons.Iris2 = {main="Iris", sub="Iris"}
	sets.weapons.Naegbron = {main="Naegling",sub="Thibron"}
	sets.weapons.Naegmace = {main="Naegling",sub="Almace"}
	sets.weapons.HybridWeapons = {main="Vampirism",sub="Vampirism"}

	-- Engaged sets

	sets.engaged = {ammo="Ginsen", 
		head=gear.adhemar_B_head,body=gear.adhemar_B_body,hands=gear.adhemar_B_hands, 
		legs="Carmine Cuisses +1", feet=gear.herculean_wsd_feet, neck="Mirage Stole +2", 
		waist="Reiki Yotai", left_ear="Telos Earring", right_ear="Brutal Earring", 
		left_ring="Petrov Ring", right_ring="Ilabrat Ring", back=gear.da_jse_back,}

	-- AM = Aftermath
	--sets.engaged.AM = {main="Tizona",sub="Almace",ammo="Aurgelmir Orb +1",
--			    head="Dampening Tam",neck="Mirage Stole +2",ear1="Cessance Earring",ear2="Telos Earring",
--			    body=gear.adhemar_B_body,hands="Adhemar Wrist. +1",ring1="Epona's Ring",ring2="Petrov Ring",
			    --back=gear.stp_jse_back,waist="Windbuffet Belt +1",legs="Samnuha Tights",feet="Carmine Greaves +1"}

	sets.engaged.Acc = {main="Tizona",sub="Almace",ammo="Falcon Eye",
				head="Malignance chapeau",neck="Mirage Stole +2",ear1="Cessance Earring",ear2="Telos Earring",
				body="Malignance Tabard",hands=gear.adhemar_B_hands,ring1="Epona's Ring",ring2="Petrov Ring",
				back=gear.da_jse_back,waist="Windbuffet Belt +1",legs="Carmine Cuisses +1",feet="Assimilator's charuqs +3"}

	--sets.engaged.Acc.AM = {main="Tizona",sub="Almace",ammo="Falcon Eye",
--			    head="Dampening Tam",neck="Mirage Stole +2",ear1="Digni. Earring",ear2="Telos Earring",
--			    body="Malignance Tabard",hands="Adhemar Wrist. +1",ring1="Epona's Ring",ring2="Ilabrat Ring",
--			    back=gear.stp_jse_back,waist="Windbuffet Belt +1",legs="Carmine Cuisses +1",feet="Malignance Boots"}

	sets.engaged.DT = {main="Naegling", sub="Almace", ammo="Staunch Tathlum +1",
		head="Nyame Helm", body="Nyame Mail", hands="Nyame Gauntlets",
		legs="Nyame Flanchard", feet="Nyame Sollerets", neck="Loricate Torque +1",
		waist="Windbuffet Belt +1", left_ear="Suppanomimi", right_ear="Brutal Earring",
		left_ring="Defending Ring", right_ring="Petrov Ring", back=gear.da_jse_back,}

	--sets.engaged.DT.AM = {main="Tizona",sub="Almace",ammo="Aurgelmir Orb +1",
--			    head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
--			    body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Petrov Ring",
--			    back=gear.stp_jse_back,waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}

	sets.engaged.Acc.DT = {main="Tizona",sub="Almace",ammo="Falcon Eye",
			    head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Telos Earring",
			    body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Ilabrat Ring",
			    back=gear.da_jse_back,waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}
				
	--sets.engaged.Acc.DT.AM = {main="Tizona",sub="Almace",ammo="Falcon Eye",
--			    head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Digni. Earring",ear2="Telos Earring",
--			    body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Ilabrat Ring",
--			    back=gear.stp_jse_back,waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}

	sets.Self_Healing = {waist="Gishdubar Sash"}
	sets.Cure_Received = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {back="Grapevine Cape",waist="Gishdubar Sash"}
	sets.MagicBurst = {body="Samnuha Coat",hands="Amalric Gages +1",legs="Assim. Shalwar +3",ring1="Mujin Band",ring2="Locus Ring"}

	sets.MoveSpeed = {legs="Carmine Cuisses +1",}
end

function user_job_lockstyle()
	windower.chat.input('/lockstyleset 001')
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(2, 16)
		windower.send_command('wait 3; azureSets set dps')		
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 16)
		windower.send_command('wait 3; azureSets set dps')		
	elseif player.sub_job == 'WAR' then
		set_macro_page(1, 16)
		windower.send_command('wait 3; azureSets set dps')		
	elseif player.sub_job == 'RUN' then
		set_macro_page(4, 16)
	elseif player.sub_job == 'THF' then
		set_macro_page(5, 16)
	elseif player.sub_job == 'RDM' then
		set_macro_page(6, 16)
	elseif player.sub_job == 'BLM' then
		set_macro_page(7, 16)
	else
		set_macro_page(10, 16)
	end
end

autows_list = {['Almace']='Chant Du Cygne',['MeleeClubs']='Realmrazer',
     ['HybridWeapons']='Sanguine Blade',['Naegbron']='Savage Blade',['Naegmace']='Savage Blade',['Tizbron']='Expiacion',['Tizalmace']='Expiacion',}
