-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    state.OffenseMode:options('Normal','Acc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Match','Normal', 'Acc','Proc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')
	state.HybridMode:options('Normal','DT')
	state.ExtraMeleeMode = M{['description']='Extra Melee Mode', 'None', 'DWMax'}
	state.Weapons:options('Default','Ranged','Savage','Evisceration','DualWeapons','DualSavageWeapons','DualEvisceration','DualLeadenRanged','DualLeadenMelee','DualAeolian','DualLeadenMeleeAcc','DualRanged','DualProcWeapons','None')
	state.CompensatorMode:options('Always','300','1000','Never')
	state.AutoAmmoMode = M(false,'Auto Ammo Mode')
	
    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Orichalc. Bullet" --For MAB WS, do not put single-use bullets here.
    gear.QDbullet = "Hauksbok Bullet"
    options.ammo_warning_limit = 15
    --Ikenga_vest_bonus = 190  -- It is 190 at R20. Uncomment if you need to manually adjust because you are using below R20

	gear.tp_ranger_jse_back = {name="Camulus's Mantle",augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Mag. Evasion+6',}}
	gear.snapshot_jse_back = {name="Camulus's Mantle",augments={'"Snapshot"+10',}}
	gear.tp_jse_back = {name="Camulus's Mantle",augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
	gear.ranger_wsd_jse_back = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Mag. Evasion+6',}}
	gear.magic_wsd_jse_back = {name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+1','Weapon skill damage +10%','Mag. Evasion+15',}}
	gear.str_wsd_jse_back = {name="Camulus's Mantle",augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}

    -- Additional local binds
	send_command('bind ^` gs c cycle ElementalMode')
	send_command('bind !` gs c elemental quickdraw')
	
	send_command('bind ^backspace input /ja "Double-up" <me>')
	send_command('bind @backspace input /ja "Snake Eye" <me>')
	send_command('bind !backspace input /ja "Fold" <me>')
	send_command('bind ^@!backspace input /ja "Crooked Cards" <me>')
	
	send_command('bind ^\\\\ input /ja "Random Deal" <me>')
    send_command('bind !\\\\ input /ja "Bolter\'s Roll" <me>')
	send_command('bind ^@!\\\\ gs c toggle LuzafRing')
	send_command('bind @f7 gs c toggle RngHelper')

	send_command('bind !r gs c weapons DualSavageWeapons;gs c update')
	send_command('bind ^q gs c weapons DualAeolian;gs c update')
	send_command('bind !q gs c weapons DualLeadenRanged;gs c update')
	send_command('bind @pause roller roll')

		state.Moving = M{false, "moving"}
		
    select_default_macro_book()
	send_command('wait 2; input /lockstyleset 1')			
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Precast sets to enhance JAs

	sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac +1"}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +3"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +2"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +2"}
	sets.precast.JA['Quick Draw'] = {head="Laksa. Tricorne +3", feet="Laksa. Bottes +3"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants +2"}
	
    sets.precast.CorsairRoll = {main="Rostam",range="Compensator",
        head="Lanun Tricorne +3",neck="Regal Necklace",ear1="Etiolation Earring",ear2="Eabani Earring",
        body="Lanun Frac +2",hands="Chasseur's Gants +1",ring1="Defending Ring",ring2="Karieyh ring",
        back=gear.tp_jse_back,waist="Flume Belt +1",legs="Desultor Tassets",feet="Malignance Boots"}

    sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +1"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +1"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
    sets.precast.CorsairShot = {ammo=gear.QDbullet,
        head="Laksa. Tricorne +3", body="Ikenga's Vest", hands="Ikenga's Gloves",
		legs="Ikenga's Trousers", feet="Chass. Bottes +1", neck="Ocachi Gorget",
		waist="Yemaya Belt", left_ear="Telos Earring", right_ear="Enervating Earring",
		left_ring="Petrov Ring", right_ring="Ilabrat Ring", back="Enuma Mantle",}
		
	sets.precast.CorsairShot.Damage = {ammo=gear.QDbullet,
        head="Laksa. Tricorne +3", body={ name="Lanun Frac +2", augments={'Enhances "Loaded Deck" effect',}}, 
		hands={ name="Leyline Gloves", augments={'Accuracy+9','Mag. Acc.+5','"Mag.Atk.Bns."+6','"Fast Cast"+1',}},
		legs="Laksa. Trews +3", feet="Laksa. Bottes +3", neck="Sanctity Necklace", waist="Eschan Stone",
		left_ear="Friomisi Earring", right_ear="Novio Earring", left_ring="Shiva Ring +1", right_ring="Dingir Ring",
		back="Toro Cape",}
	
    sets.precast.CorsairShot.Proc = {ammo=gear.RAbullet,
		head="Wh. Rarab Cap +1", body="Malignance Tabard", hands="Volte Bracers",
		legs="Volte Hose", feet="Laksa. Bottes +3", neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Chaac Belt", left_ear="Etiolation Earring", right_ear="Eabani Earring",
		left_ring="Defending Ring", right_ring="Archon Ring", back="Mollusca Mantle",}
		
    sets.precast.CorsairShot['Light Shot'] = {ammo=gear.QDbullet,
		head="Ikenga's Hat", body="Ikenga's Vest", hands="Ikenga's Gloves",
		legs="Ikenga's Trousers", feet="Ikenga's Clogs", neck="Sanctity Necklace",
		waist="Eschan Stone", left_ear="Hermetic Earring", right_ear="Telos Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}}, right_ring="Stikini Ring +1",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+1','Weapon skill damage +10%','Mag. Evasion+15',}},}

    sets.precast.CorsairShot['Dark Shot'] = set_combine(sets.precast.CorsairShot['Light Shot'], {head="Pixie Hairpin +1", feet="Chass. Bottes +1"})

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Carmine Mask +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Eabani Earring",
        body=gear.herculean_waltz_body,hands=gear.herculean_waltz_hands,ring1="Defending Ring",ring2="Valseur's Ring",
        back="Solemnity Cape",waist="Flume Belt +1",legs="Dashing Subligar",feet=gear.herculean_waltz_feet}
		
	sets.Self_Waltz = {head="Mummu Bonnet +2",body="Passion Jacket",ring1="Asklepian Ring"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
	    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}}, body="Ikenga's Vest",
		hands={ name="Leyline Gloves", augments={'Accuracy+9','Mag. Acc.+5','"Mag.Atk.Bns."+6','"Fast Cast"+1',}},
		legs={ name="Carmine Cuisses", augments={'Accuracy+15','Attack+10','"Dual Wield"+5',}},
		feet={ name="Carmine Greaves", augments={'MP+60','INT+10','MND+10',}}, neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1", left_ear="Etiolation Earring", right_ear="Loquac. Earring",
		left_ring="Kishar Ring", right_ring="Prolix Ring", back="Solemnity Cape",}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {ear2="Mendi. Earring"})

    sets.precast.RA = {ammo=gear.RAbullet,
        head="Chass. Tricorne +1", body="Laksa. Frac +3", hands="Mrigavyadha Gloves",
		legs="Laksa. Trews +3", feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},
		waist="Yemaya Belt",}
		
	sets.precast.RA.Flurry = set_combine(sets.precast.RA, {waist="Yemaya Belt",legs="Adhemar Kecks +1"})
	sets.precast.RA.Flurry2 = set_combine(sets.precast.RA, {waist="Yemaya Belt",legs="Adhemar Kecks +1"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		head="Meghanada Visor +2", body="Laksa. Frac +3", hands="Meg. Gloves +2",
		legs="Meg. Chausses +2", feet={ name="Lanun Bottes +2", augments={'Enhances "Wild Card" effect',}},
		neck="Fotia Gorget", waist="Fotia Belt", left_ear="Telos Earring",
		right_ear="Ishvara Earring", left_ring="Regal Ring", right_ring="Karieyh Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Mag. Evasion+6',}},}
		
    sets.precast.WS.Acc = {
        head="Malignance Chapeau", body="Laksa. Frac +3", hands="Meg. Gloves +2",
		legs="Laksa. Trews +3", feet={ name="Lanun Bottes +2", augments={'Enhances "Wild Card" effect',}},
		neck="Combatant's Torque", waist="Fotia Belt", left_ear="Telos Earring",
		right_ear="Enervating Earring", left_ring="Regal Ring", right_ring="Karieyh Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Mag. Evasion+6',}},}		
		
    sets.precast.WS.Proc = {
        head="Carmine Mask +1",neck="Combatant's Torque",ear1="Digni. Earring",ear2="Mache Earring +1",
        body="Mummu Jacket +2",hands="Floral Gauntlets",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back=gear.tp_jse_back,waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Malignance Boots"}
		
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {    
		head="Laksa. Tricorne +3", right_ear="Brutal earring", left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {    
		head="Mummu Bonnet +2", legs="Mummu Kecks +2", left_ear="Odr Earring", left_ring="Hetairoi Ring",})
		
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS.Acc, {
        head="Mummu Bonnet +2", body="Mummu Jacket +2", hands="Mummu Wrists +2",
		legs="Mummu Kecks +2", feet="Mummu Gamash. +2", ear1="Odr Earring", right_ear="Enervating Earring", ring1="Regal Ring", 
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Mag. Evasion+6',}},})

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {    
		head={ name="Adhemar Bonnet +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		legs={ name="Lanun Trews +3", augments={'Enhances "Snake Eye" effect',}},
		neck="Caro Necklace", waist="Sailfi Belt +1", right_ring="Petrov Ring",})

    sets.precast.WS['Savage Blade'].Acc = sets.precast.WS.Acc
	
    sets.precast.WS['Last Stand'] = set_combine(sets.precast.WS, {ring2="Dingir Ring",})

    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS.Acc, {ring2="Dingir Ring",})
		
    sets.precast.WS['Detonator'] = sets.precast.WS['Last Stand']
    sets.precast.WS['Detonator'].Acc = sets.precast.WS['Last Stand'].Acc
    sets.precast.WS['Slug Shot'] = sets.precast.WS['Last Stand']
    sets.precast.WS['Slug Shot'].Acc = sets.precast.WS['Last Stand'].Acc
    sets.precast.WS['Numbing Shot'] = sets.precast.WS['Last Stand']
    sets.precast.WS['Numbing Shot'].Acc = sets.precast.WS['Last Stand'].Acc
    sets.precast.WS['Sniper Shot'] = sets.precast.WS['Last Stand']
    sets.precast.WS['Sniper Shot'].Acc = sets.precast.WS['Last Stand'].Acc
    sets.precast.WS['Split Shot'] = sets.precast.WS['Last Stand']
    sets.precast.WS['Split Shot'].Acc = sets.precast.WS['Last Stand'].Acc
	
    sets.precast.WS['Leaden Salute'] = {ammo=gear.MAbullet,
        head="Pixie Hairpin +1", body="Laksa. Frac +3",
		hands={ name="Leyline Gloves", augments={'Accuracy+9','Mag. Acc.+5','"Mag.Atk.Bns."+6','"Fast Cast"+1',}},
		legs="Laksa. Trews +3", feet={ name="Lanun Bottes +2", augments={'Enhances "Wild Card" effect',}},
		neck="Sanctity Necklace", waist="Eschan Stone", left_ear="Friomisi Earring",
		right_ear="Choleric Earring", left_ring="Archon Ring", right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+1','Weapon skill damage +10%','Mag. Evasion+15',}},}
		
    sets.precast.WS['Leaden Salute'].Acc = sets.precast.WS['Leaden Salute']

    sets.precast.WS['Aeolian Edge'] = {ammo="Animikii Bullet",
        head=gear.herculean_nuke_head,neck="Sanctity necklace",ear1="Friomisi Earring",ear2="Novio Earring",
        body="Laksa. Frac +3",hands="Leyline Gloves",ring1="Metamor. Ring +1",ring2="Dingir Ring",
        back=gear.magic_wsd_jse_back,waist="Eschan Stone",legs="Laksa. trews +3",feet="Lanun Bottes +2"}

    sets.precast.WS['Wildfire'] = {ammo=gear.MAbullet,
        head=gear.herculean_nuke_head,neck="Sanctity necklace",ear1="Friomisi Earring",ear2="Novio Earring",
		body="Laksa. Frac +3",hands="Leyline Gloves",ring1="Regal Ring",ring2="Dingir Ring",
		back=gear.magic_wsd_jse_back,waist="Eschan Stone",legs="Laksa. trews +3",feet="Lanun Bottes +2"}

    sets.precast.WS['Wildfire'].Acc = {ammo=gear.MAbullet,
        head=gear.herculean_nuke_head,neck="Sanctity necklace",ear1="Friomisi Earring",ear2="Novio Earring",
        body="Laksa. Frac +3",hands="Leyline Gloves",ring1="Metamor. Ring +1",ring2="Dingir Ring",
        back=gear.magic_wsd_jse_back,waist="Eschan Stone",legs="Laksa. trews +3",feet="Lanun Bottes +2"}
		
    sets.precast.WS['Hot Shot'] = sets.precast.WS['Wildfire']
    sets.precast.WS['Hot Shot'].Acc = sets.precast.WS['Wildfire'].Acc
		
		--Because omen skillchains.
    sets.precast.WS['Burning Blade'] = {ammo=gear.RAbullet,
        head="Meghanada Visor +2",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Eabani Earring",
        body="Meg. Cuirie +2",hands="Malignance Gloves",ring1="Defending Ring",ring2="Karieyh ring",
        back="Solemnity Cape",waist="Flume Belt +1",legs="Meg. Chausses +2",feet="Meg. Jam. +2"}

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {}
	sets.AccMaxTP = {}
        
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Carmine Mask +1",neck="Baetyl Pendant",ear1="Enchntr. Earring +1",ear2="Loquac. Earring",
        body="Dread Jupon",hands="Leyline Gloves",ring1="Kishar Ring",ring2="Lebeche Ring",
        back="Solemnity Cape",waist="Flume Belt +1",legs="Rawhide Trousers",feet="Carmine Greaves +1"}
        
    -- Specific spells

	sets.midcast.Cure = {
        head="Carmine Mask +1",neck="Phalaina Locket",ear1="Enchntr. Earring +1",ear2="Mendi. Earring",
        body="Dread Jupon",hands="Leyline Gloves",ring1="Janniston Ring",ring2="Lebeche Ring",
        back="Solemnity Cape",waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Carmine Greaves +1"}
	
	sets.Self_Healing = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}
	
    sets.midcast.Utsusemi = sets.midcast.FastRecast

    -- Ranged gear
    sets.midcast.RA = {ammo=gear.RAbullet,
        head="Malignance Chapeau", body="Malignance Tabard", hands="Ikenga's Gloves",
		legs="Ikenga's Trousers", feet="Ikenga's Clogs", neck="Marked Gorget",
		waist="Yemaya Belt", left_ear="Telos Earring", right_ear="Enervating Earring",
		left_ring="Ilabrat Ring", right_ring="Dingir Ring", back=gear.tp_ranger_jse_back,}

    sets.midcast.RA.Acc = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Iskur Gorget",ear1="Telos Earring",ear2="Enervating Earring",
        body="Laksa. Frac +3",hands="Ikenga's Gloves",ring1="Regal Ring",ring2="Ilabrat Ring",
        back=gear.tp_ranger_jse_back,waist="Yemaya Belt",legs="Laksa. Trews +3",feet="Ikenga's Clogs"}
		
	sets.buff['Triple Shot'] = {body="Chasseur's Frac +1"}
    
    -- Sets to return to when not performing an action.
	
	sets.DayIdle = {}
	sets.NightIdle = {}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {})
    
    -- Resting sets
    sets.resting = {}
	sets.BulletPouch = {waist="Chr. Bul. Pouch"}

    -- Idle sets
    sets.idle = {ammo=gear.RAbullet,
        head="Malignance Chapeau", body="Malignance Tabard", hands="Meg. Gloves +2",
		legs="Mummu Kecks +2", feet={ name="Lanun Bottes +2", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}}, waist="Carrier's Sash", left_ear="Etiolation Earring",
		right_ear="Eabani Earring", left_ring="Defending Ring", right_ring="Karieyh Ring", back="Solemnity Cape",}
		
    sets.idle.PDT = set_combine(sets.idle, {waist="Flume Belt +1",legs="Laksa. trews +3"})
		
    sets.idle.Refresh = {ammo=gear.RAbullet,
        head="Rawhide Mask",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Ethereal Earring",
        body="Mekosu. Harness",hands=gear.herculean_refresh_hands,ring1="Defending Ring",ring2="Karieyh ring",
        back="Solemnity Cape",waist="Flume Belt +1",legs="Rawhide Trousers",feet="Malignance Boots"}
    
    -- Defense sets
    sets.defense.PDT = {ammo=gear.RAbullet,
        head="Nyame Helm",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Tuisto Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Defending Ring",ring2="Warden's Ring",
        back="Shadow Mantle",waist="Flume Belt +1",legs="Laksa. trews +3",feet="Nyame Sollerets"}

    sets.defense.MDT = set_combine(sets.idle, {ammo=gear.RAbullet,
            neck="Warder's Charm +1", waist="Carrier's Sash", right_ring="Archon Ring", back="Reiki Cloak",})
		
    sets.defense.MEVA = {ammo=gear.RAbullet,
        head="Nyame Helm",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Eabani Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Defending Ring",ring2="Shadow Ring",
        back="Solemnity Cape",waist="Carrier's Sash",legs="Laksa. trews +3",feet="Nyame Sollerets"}

    sets.Kiting = {legs="Carmine Cuisses"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {})
	sets.DWMax = {ear1="Suppanomimi",ear2="Eabani Earring",body="Adhemar Jacket +1",waist="Reiki Yotai"}

	-- Weapons sets
	sets.weapons.Default = {main="Naegling",sub="Nusku Shield",range="Fomalhaut"}
	sets.weapons.Ranged = {main="Rostam",sub="Nusku Shield",range="Fomalhaut"}
	sets.weapons.Evisceration = {main="Tauret",sub="Nusku Shield",range="Ataktos"}
	sets.weapons.DualWeapons = {main="Naegling",sub="Blurred Knife +1",range="Fomalhaut"}
	sets.weapons.DualSavageWeapons = {main="Naegling",sub="Blurred Knife +1",range="Ataktos"}
	sets.weapons.DualEvisceration = {main="Tauret",sub="Blurred Knife +1",range="Ataktos"}
	sets.weapons.Savage = {main="Naegling",sub="Nusku Shield",range="Ataktos"}
	sets.weapons.DualLeadenRanged = {main="Rostam",sub="Tauret",range="Fomalhaut"}
	sets.weapons.DualLeadenMelee = {main="Naegling",sub="Atoyac",range="Fomalhaut"}
	sets.weapons.DualAeolian = {main="Rostam",sub="Tauret",range="Ataktos"}
	sets.weapons.DualLeadenMeleeAcc = {main="Naegling",sub="Blurred Knife +1",range="Fomalhaut"}
	sets.weapons.DualRanged = {main="Rostam",sub="Kustawi +1",range="Fomalhaut"}
	
    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {
	    head={ name="Adhemar Bonnet", augments={'STR+10','DEX+10','Attack+15',}},
		body={ name="Adhemar Jacket", augments={'STR+10','DEX+10','Attack+15',}},
		hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
		legs="Meg. Chausses +2", feet="Mummu Gamash. +2", neck="Asperity Necklace",
		waist="Windbuffet Belt +1", left_ear="Telos Earring", right_ear="Brutal Earring",
		left_ring="Petrov Ring", right_ring="Epona's Ring", back="Bleating Mantle",}
    
    sets.engaged.Acc = {
	    head="Malignance Chapeau", body="Malignance Tabard", hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
		legs="Meg. Chausses +2", feet="Mummu Gamash. +2", neck="Combatant's Torque", waist="Reiki Yotai",
		left_ear="Telos Earring", right_ear="Odr Earring", left_ring="Chirich Ring", right_ring="Chirich Ring", back="Enuma Mantle",}
		
    sets.engaged.DT = set_combine(sets.idle, {
	    hands="Meg. Gloves +2", legs="Meg. Chausses +2", feet="Meg. Jam. +2",
		waist="Flume Belt +1", left_ear="Infused Earring", right_ear="Eabani Earring",
		left_ring="Chirich Ring", right_ring="Chirich Ring", back="Reiki Cloak",})
    
    sets.engaged.Acc.DT = set_combine(sets.engaged.acc, sets.engaged.DT)

    sets.engaged.DW = set_combine(sets.DWMax, {
	    head={ name="Adhemar Bonnet", augments={'STR+10','DEX+10','Attack+15',}},
		hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
		legs="Meg. Chausses +2", feet={ name="Carmine Greaves", augments={'Accuracy+10','DEX+10','MND+15',}},
		neck="Asperity Necklace", left_ring="Hetairoi Ring", right_ring="Epona's Ring", back="Bleating Mantle",})
    
    sets.engaged.DW.Acc = set_combine(sets.engaged.DW, sets.engaged.Acc)
		
    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.DT)
    
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.DT)

	sets.MoveSpeed = {legs="Crimson cuisses",}
end

function user_job_lockstyle()
	windower.chat.input('/lockstyleset 001')
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    if player.sub_job == 'NIN' then
        set_macro_page(1, 17)
    elseif player.sub_job == 'DNC' then
		set_macro_page(2, 17)
    elseif player.sub_job == 'RNG' then
        set_macro_page(3, 17)
    else
        set_macro_page(3, 17)
    end
end


autows_list = {['Default']='Savage Blade',['Evisceration']='Evisceration',['Savage']='Savage Blade',['Ranged']='Last Stand',['DualWeapons']='Savage Blade',['DualSavageWeapons']='Savage Blade',['DualEvisceration']='Evisceration',['DualLeadenRanged']='Leaden Salute',['DualLeadenMelee']='Leaden Salute',['DualAeolian']='Aeolian Edge',['DualRanged']='Last Stand'}
