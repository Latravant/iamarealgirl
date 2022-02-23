-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')

end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false
    
    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false

	state.WeaponMode = M{['description']='Weapon Mode', 'DPS', 'SwordMA', 'ClubMA','DWTH'}


    blue_magic_maps = {}
    
    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.
    
    -- Physical Spells --
    
    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{
        'Bilgestorm'
    }

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{
        'Heavy Strike',
    }

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{
        'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Sinker Drill','Spinal Cleave',
        'Uppercut','Vertical Cleave'
    }
        
    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{
        'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone','Disseverment',
        'Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault',
        'Vanity Dive'
    }
        
    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{
        'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'
    }
        
    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{
        'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'
    }

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{
        'Mandibular Bite','Queasyshroom'
    }

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{
        'Ram Charge','Screwdriver','Tourbillion'
    }

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{
        'Bludgeon'
    }

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{
        'Final Sting'
    }

    -- Magical Spells --

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{
        'Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere','Dark Orb','Death Ray',
        'Diffusion Ray','Droning Whirlwind','Embalming Earth','Firespit','Foul Waters',
        'Ice Break','Leafstorm','Maelstrom','Rail Cannon','Regurgitation','Rending Deluge',
        'Retinal Glare','Subduction','Tem. Upheaval','Water Bomb'
    }

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{
        'Acrid Stream','Evryone. Grudge','Magic Hammer','Mind Blast'
    }

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{
        'Eyes On Me','Mysterious Light'
    }

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{
        'Thermal Pulse'
    }

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{
        'Charged Whisker','Gates of Hades'
    }
            
    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{
        '1000 Needles','Absolute Terror','Actinic Burst','Auroral Drape','Awful Eye',
        'Blank Gaze','Blistering Roar','Blood Drain','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest',
        'Dream Flower','Enervation','Feather Tickle','Filamented Hold','Frightful Roar',
        'Geist Wall','Hecatomb Wave','Infrasonics','Jettatura','Light of Penance',
        'Lowing','Mind Blast','Mortal Ray','MP Drainkiss','Osmosis','Reaving Wind',
        'Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast','Stinking Gas',
        'Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'
    }
        
    -- Breath-based spells
    blue_magic_maps.Breath = S{
        'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath',
        'Hecatomb Wave','Magnetite Cloud','Poison Breath','Radiant Breath','Self-Destruct',
        'Thunder Breath','Vapor Spray','Wind Breath'
    }

    -- Stun spells
    blue_magic_maps.Stun = S{
        'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
        'Thunderbolt','Whirl of Rage'
    }
        
    -- Healing spells
    blue_magic_maps.Healing = S{
        'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral','White Wind',
        'Wild Carrot'
    }
    
    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{
        'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body','Plasma Charge',
        'Pyric Bulwark','Reactor Cool',
    }

    -- Other general buffs
    blue_magic_maps.Buff = S{
        'Amplification','Animating Wail','Battery Charge','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell',
        'Memento Mori','Nat. Meditation','Occultation','Orcish Counterstance','Refueling',
        'Regeneration','Saline Coat','Triumphant Roar','Warm-Up','Winds of Promyvion',
        'Zephyr Mantle'
    }
    
    
    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{
        'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve',
        'Crashing Thunder','Droning Whirlwind','Gates of Hades','Harden Shell','Polar Roar',
        'Pyric Bulwark','Thunderbolt','Tourbillion','Uproot'
    }
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Refresh', 'Learning', 'TH')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Learning')
    state.HybridMode:options('Normal', 'DW')

    -- Additional local binds
    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')
	send_command('bind ^w gs c cycle WeaponMode')
	
    


    update_combat_form()
    select_default_macro_book()
	send_command('wait 2; input /lockstyleset 1')

end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
	send_command('unbind ^w')
end


-- Set up gear sets.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.buff['Burst Affinity'] = {feet="Hashi. Basmak +1"}
    sets.buff['Chain Affinity'] = {head="Hashishin Kavuk +1", feet="Assimilator's Charuqs"}
    sets.buff.Convergence = {head="Luhlaza Keffiyeh"}
    sets.buff.Diffusion = {feet="Luhlaza Charuqs"}
    sets.buff.Enchainment = {body="Luhlaza Jubbah"}
    sets.buff.Efflux = {legs="Hashishin Tayt +1"}

    
    -- Precast Sets
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = {hands={ name="Luh. Bazubands +1", augments={'Enhances "Azure Lore" effect',}}}


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Uk'uxkaj Cap",
        body="Vanir Cotehardie",hands="Buremte Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Hagondes Pants",feet="Iuitl Gaiters +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {    ammo="Sapience Orb",
    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    body={ name="Hashishin Mintan +1"},
    hands="Magavan Mitts",
    legs="Gyve Trousers",
    feet={ name="Amalric Nails", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Conserve MP"+6',}},
    waist="Rumination Sash",
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    back="Swith Cape"}
        
    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {    body="Hashishin Mintan +1",
    hands="Hashi. Bazu. +1"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {    ammo="Hasty Pinion +1",
    head={ name="Herculean Helm", augments={'Attack+5','Weapon skill damage +3%','DEX+4','Accuracy+14',}},
    body={ name="Herculean Vest", augments={'Accuracy+18 Attack+18','"Triple Atk."+3','DEX+11','Accuracy+4','Attack+11',}},
    hands="Jhakri Cuffs +2",
    legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
    feet={ name="Herculean Boots", augments={'Weapon skill damage +2%','Pet: Accuracy+28 Pet: Rng. Acc.+28','Quadruple Attack +1',}},
    neck="Fotia Gorget",
    waist="Caudata Belt",
    left_ear="Odr Earring",
    right_ear="Ishvara Earring",
    left_ring="Ilabrat Ring",
    right_ring="Karieyh Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}}}
    
    sets.precast.WS.acc = set_combine(sets.precast.WS, {legs="Taeon tights"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] ={    ammo="Quartz Tathlum +1",
    head={ name="Herculean Helm", augments={'Attack+5','Weapon skill damage +3%','DEX+4','Accuracy+14',}},
    body="Vanir Cotehardie",
    hands="Jhakri Cuffs +2",
    legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
    feet={ name="Herculean Boots", augments={'Weapon skill damage +2%','Pet: Accuracy+28 Pet: Rng. Acc.+28','Quadruple Attack +1',}},
    neck="Imbodla Necklace",
    waist="Salire Belt",
    left_ear="Lifestorm Earring",
    right_ear="Influx Earring",
    left_ring="Levia. Ring",
    right_ring="Karieyh Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}},}

    sets.precast.WS['Sanguine Blade'] = {
        head="Hagondes Hat",neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Hagondes Coat",hands="Hashi. Bazu. +1",ring1="Acumen Ring",ring2="Strendu Ring",
        back="Toro Cape",legs="Hagondes Pants",feet="Iuitl Gaiters +1"}
    
	sets.precast.WS['Chant du Cygne'] = {
        ammo="Cheruski Needle",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
		feet="Aya. Gambieras +1",
		neck="Fotia Gorget",
		waist="Artful Belt",
		left_ear="Ishvara Earring",
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}},
		}
    
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Haruspex Hat",ear2="Loquacious Earring",
        body="Luhlaza Jubbah",hands="Hashi. Bazu. +1",ring1="Prolix Ring",
        back="Swith Cape +1",waist="Hurch'lan Sash",legs="Enif Cosciales",feet="Iuitl Gaiters +1"}
        
    sets.midcast['Blue Magic'] = {}
    
    -- Physical Spells --
    
    sets.midcast['Blue Magic'].Physical = {    ammo="Hasty Pinion +1",
    head="Jhakri Coronal +2",
    body="Jhakri Robe +2",
    hands={ name="Despair Fin. Gaunt.", augments={'STR+12','VIT+7','Haste+2%',}},
    legs={ name="Herculean Trousers", augments={'Crit.hit rate+2','STR+7','Weapon skill damage +5%','Accuracy+18 Attack+18',}},
    feet={ name="Rawhide Boots", augments={'STR+10','Attack+15','"Store TP"+5',}},
    neck="Caro Necklace",
    waist="Grunfeld Rope",
    left_ear="Telos Earring",
    right_ear="Odr Earring",
    left_ring="Ifrit Ring",
    right_ring="Petrov Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}}}

    sets.midcast['Blue Magic'].PhysicalAcc = {    ammo="Hasty Pinion +1",
    head="Aya. Zucchetto +2",
    body={ name="Herculean Vest", augments={'Accuracy+18 Attack+18','"Triple Atk."+3','DEX+11','Accuracy+4','Attack+11',}},
    hands="Aya. Manopolas +2",
    legs="Aya. Cosciales +1",
    feet={ name="Rawhide Boots", augments={'STR+10','Attack+15','"Store TP"+5',}},
    neck="Sanctity Necklace",
    waist="Grunfeld Rope",
    left_ear="Telos Earring",
    right_ear="Odr Earring",
    left_ring="Ilabrat Ring",
    right_ring="Ramuh Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','Weapon skill damage +10%','System: 1 ID: 640 Val: 4',}}}

    sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Iuitl Vest",hands="Assimilator's Bazubands +1"})

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical,
        {ammo="Jukukik Feather",body="Iuitl Vest",hands="Assimilator's Bazubands +1",
         waist="Chaac Belt",legs="Manibozho Brais"})

    sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",back="Iximulew Cape"})

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Vanir Cotehardie",hands="Iuitl Wristbands",ring2="Stormsoul Ring",
         waist="Chaac Belt",feet="Iuitl Gaiters +1"})

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical,
        {ear1="Psystorm Earring",body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",
         ring2="Icesoul Ring",back="Toro Cape",feet="Hagondes Sabots"})

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical,
        {ear1="Lifestorm Earring",body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",
         ring2="Aquasoul Ring",back="Refraction Cape"})

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",back="Refraction Cape",
         waist="Chaac Belt"})

    sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical)


    -- Magical Spells --
    
    sets.midcast['Blue Magic'].Magical = {    ammo="Ghastly Tathlum",
    head="Jhakri Coronal +2",
    body="Jhakri Robe +2",
    hands="Jhakri Cuffs +2",
    legs="Jhakri Slops +2",
    feet="Jhakri Pigaches +2",
    neck="Sanctity Necklace",
    waist="Acuity Belt",
    left_ear="Hecate's Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring",
    right_ring="Shiva Ring",
    back={ name="Cornflower Cape", augments={'MP+15','DEX+2','Accuracy+3','Blue Magic skill +10',}}}

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical,
        {body="Vanir Cotehardie",ring1="Sangoma Ring",legs="Iuitl Tights",feet="Hashi. Basmak +1"})
    
    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,
        {ring1="Aquasoul Ring"})

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical,
        {ring1="Spiral Ring"})

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicAccuracy = {    ammo="Mavi Tathlum",
    head="Aya. Zucchetto +2",
    body="Ayanmo Corazza +2",
    hands="Aya. Manopolas +2",
    legs="Aya. Cosciales +1",
    feet="Aya. Gambieras +1",
    neck="Mirage Stole +1",
    waist="Salire Belt",
    left_ear="Lifestorm Earring",
    right_ear="Psystorm Earring",
    left_ring="Sangoma Ring",
    right_ring="Etana Ring",
    back={ name="Cornflower Cape", augments={'MP+15','DEX+2','Accuracy+3','Blue Magic skill +10',}}}

    -- Breath Spells --
    
    sets.midcast['Blue Magic'].Breath = {    ammo="Mavi Tathlum",
    head={ name="Luh. Keffiyeh +1", augments={'Enhances "Convergence" effect',}},
    body="Jhakri Robe +2",
    hands="Jhakri Cuffs +2",
    legs="Jhakri Slops +2",
    feet="Jhakri Pigaches +2",
    neck="Ardor Pendant +1",
    waist="Salire Belt",
    left_ear="Lifestorm Earring",
    right_ear="Psystorm Earring",
    left_ring="Arvina Ringlet +1",
    right_ring="Jhakri Ring",
    back={ name="Cornflower Cape", augments={'MP+15','DEX+2','Accuracy+3','Blue Magic skill +10',}}}

    -- Other Types --
    
    sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,
        {waist="Chaac Belt"})
        
    sets.midcast['Blue Magic']['White Wind'] = {
    ammo="Mavi Tathlum",
    head={ name="Luh. Keffiyeh +1", augments={'Enhances "Convergence" effect',}},
    body="Gyve Doublet",
    hands={ name="Telchine Gloves", augments={'Pet: Attack+6 Pet: Rng.Atk.+6','"Avatar perpetuation cost" -4','Pet: Damage taken -1%',}},
    legs="Gyve Trousers",
    feet="Skaoi Boots",
    neck="Cuamiz Collar",
    waist="Kasiri Belt",
    left_ear="Etiolation Earring",
    right_ear="Eabani Earring",
    left_ring="Meridian Ring",
    right_ring="Menelaus's Ring",
    back="Solemnity Cape",}

    sets.midcast['Blue Magic'].Healing = {
    ammo="Quartz Tathlum +1",
    head="Aya. Zucchetto +2",
    body="Vanir Cotehardie",
    hands={ name="Telchine Gloves", augments={'Pet: Attack+6 Pet: Rng.Atk.+6','"Avatar perpetuation cost" -4','Pet: Damage taken -1%',}},
    legs="Gyve Trousers",
    feet="Skaoi Boots",
    neck="Imbodla Necklace",
    waist="Gishdubar Sash",
    left_ear="Lifestorm Earring",
    right_ear="Influx Earring",
    left_ring="Levia. Ring",
    right_ring="Menelaus's Ring",
    back="Solemnity Cape",}

    sets.midcast['Blue Magic'].SkillBasedBuff = {    ammo="Mavi Tathlum",
    head={ name="Luh. Keffiyeh +1", augments={'Enhances "Convergence" effect',}},
    body="Assim. Jubbah +1",
    legs="Hashishin Tayt +1",
    feet={ name="Luhlaza Charuqs +1", augments={'Enhances "Diffusion" effect',}},
    neck="Mirage Stole +1",
    right_ear="Njordr Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Cornflower Cape", augments={'MP+15','DEX+2','Accuracy+3','Blue Magic skill +10',}},}

    sets.midcast['Blue Magic'].Buff = {}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Protectra = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    sets.midcast.Shellra = {ring1="Sheltered Ring"}
    

    
    
    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
    sets.Learning = set_combine(sets.engaged.dw, {    ammo="Mavi Tathlum",
		head={ name="Luh. Keffiyeh +1", augments={'Enhances "Convergence" effect',}},				
		body="Assim. Jubbah +1",
		hands="Assim. Bazu. +1",
		legs="Hashishin Tayt +1",
		feet={ name="Luhlaza Charuqs +1", augments={'Enhances "Diffusion" effect',}},
		neck="Mirage Stole +1",
		right_ear="Njordr Earring",
		left_ring="Antica Ring",
		back={ name="Cornflower Cape", augments={'MP+15','DEX+2','Accuracy+3','Blue Magic skill +10',}}})
        --head="Luhlaza Keffiyeh",  
        --body="Assimilator's Jubbah",hands="Assimilator's Bazubands +1",
        --back="Cornflower Cape",legs="Hashishin Tayt +1",feet="Luhlaza Charuqs"}


    sets.latent_refresh = {waist="Fucho-no-obi",ring1="stikini ring", ring2="stikini ring"}

    -- Resting sets
    sets.resting = {
        head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
        body="Hagondes Coat",hands="Serpentes Cuffs",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        waist="Austerity Belt",feet="Chelona Boots +1"}
    
    -- Idle sets
    sets.idle = {ammo="Staunch Tathlum",
		head={name="Rawhide Mask", augments={'Accuracy+15','Pet: Accuracy+15','Pet: "Dbl. Atk."+3',}},
		body="Jhakri Robe +2",
		hands="Serpentes Cuffs",
		legs="Carmine Cuisses",
		feet={name="Herculean Boots", augments={'Weapon skill damage +2%','Pet: Accuracy+28 Pet: Rng. Acc.+28','Quadruple Attack +1',}},
		neck="Sanctity Necklace",
		waist="Fucho-no-Obi",
		left_ear="Brachyura Earring",
		right_ear="Ethereal Earring",
		left_ring="Karieyh Ring",
		right_ring="Sheltered Ring",
		back="Kumbira Cape",}

    sets.idle.PDT = {ammo="Staunch Tathlum",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +1",
		feet="Aya. Gambieras +1",
		neck="Twilight Torque",
		waist="Isa Belt",
		left_ear="Ethereal Earring",
		right_ear="Etiolation Earring",
		left_ring="Ayanmo Ring",
		right_ring="Defending Ring",
		back="Solemnity Cape"}

    sets.idle.Town = {set_combine(sets.idle, {legs="carmine cuisses"})}

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    
    -- Defense sets
    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Whirlpool Mask",neck="Wiglen Gorget",ear1="Bloodgem Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}

    sets.defense.MDT = {ammo="Demonry Stone",
        head="Whirlpool Mask",neck="Twilight Torque",ear1="Bloodgem Earring",
        body="Hagondes Coat",hands="Iuitl Wristbands",ring1="Defending Ring",ring2="Shadow Ring",
        back="Engulfer Cape",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}

    sets.Kiting = {legs="Crimson Cuisses"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {ammo="Hasty Pinion +1",
    head="Herculean helm",
    body={ name="Herculean Vest", augments={'Accuracy+18 Attack+18','"Triple Atk."+3','DEX+11','Accuracy+4','Attack+11',}},
    hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
    legs={ name="Taeon Tights", augments={'Pet: Accuracy+13 Pet: Rng. Acc.+13','Weapon Skill Acc.+10','AGI+9',}},
    feet={ name="Herculean Boots", augments={'Weapon skill damage +2%','Pet: Accuracy+28 Pet: Rng. Acc.+28','Quadruple Attack +1',}},
    neck="Asperity Necklace",
    waist="Windbuffet Belt",
    left_ear="Telos Earring",
    right_ear="Brutal Earring",
    left_ring="Hetairoi Ring",
    right_ring="Epona's Ring",
    back="Bleating Mantle"}

    sets.engaged.Acc = {ammo="Jukukik Feather",
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Luhlaza Jubbah",hands="Buremte Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Letalis Mantle",waist="Hurch'lan Sash",legs="Manibozho Brais",feet="Qaaxo Leggings"}

    sets.engaged.Refresh = {ammo="Jukukik Feather",
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Luhlaza Jubbah",hands="Assimilator's Bazubands +1",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Windbuffet Belt",legs="Manibozho Brais",feet="Qaaxo Leggings"}

	sets.DW = {}
	
    sets.engaged.DW = {ammo="Hasty Pinion +1",
    head={ name="Adhemar Bonnet", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
    body={ name="Herculean Vest", augments={'Accuracy+18 Attack+18','"Triple Atk."+3','DEX+11','Accuracy+4','Attack+11',}},
    hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
    legs={ name="Taeon Tights", augments={'Pet: Accuracy+13 Pet: Rng. Acc.+13','Weapon Skill Acc.+10','AGI+9',}},
    feet={ name="Herculean Boots", augments={'Weapon skill damage +2%','Pet: Accuracy+28 Pet: Rng. Acc.+28','Quadruple Attack +1',}},
    neck="Asperity Necklace",
    waist="Windbuffet Belt",
    left_ear="Telos Earring",
    right_ear="Brutal Earring",
    left_ring="Hetairoi Ring",
    right_ring="Epona's Ring",
    back="Bleating Mantle"}

    sets.engaged.DW.Acc = {ammo="Jukukik Feather",
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Heartseeker Earring",ear2="Dudgeon Earring",
        body="Luhlaza Jubbah",hands="Buremte Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Letalis Mantle",waist="Hurch'lan Sash",legs="Manibozho Brais",feet="Qaaxo Leggings"}

    sets.engaged.DW.Refresh = {ammo="Jukukik Feather",
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Heartseeker Earring",ear2="Dudgeon Earring",
        body="Luhlaza Jubbah",hands="Assimilator's Bazubands +1",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Letalis Mantle",waist="Windbuffet Belt",legs="Manibozho Brais",feet="Qaaxo Leggings"}

    sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)
    sets.engaged.DW.Learning = set_combine(sets.engaged.DW, sets.Learning)
	sets.engaged.TH	= set_combine(sets.engaged.DW,{head={ name="Herculean Helm", augments={'Pet: Accuracy+15 Pet: Rng. Acc.+15','Pet: DEX+7','"Treasure Hunter"+1',}},
		waist="Chaac Belt",})
	sets.dps = {main="Almace", sub="Naegling"}
	sets.dps.matt = {
		main={ name="Colada", augments={'DEX+2','Mag. Acc.+7 "Mag.Atk.Bns."+7','"Treasure Hunter"+1',}},
		sub={ name="Colada", augments={'Mag. Acc.+4 "Mag.Atk.Bns."+4','MND+7','"Mag.Atk.Bns."+20','DMG:+10',}},}
		
	sets.matt = {main="nibiru cudgel", sub="nibiru cudgel"}
	sets.TH = {main="almace", sub={ name="Colada", augments={'DEX+2','Mag. Acc.+7 "Mag.Atk.Bns."+7','"Treasure Hunter"+1',},}}

    sets.self_healing = {ring1="Kunaji Ring",ring2="Asklepian Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
            equip(sets.self_healing)
        end
    end

    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    if state.OffenseMode.value == 'Learning' then
        equip(sets.Learning)
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
        state.Buff[buff] = gain
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end

	elseif stateField == 'Weapon Mode' then
        if newValue == 'DPS' then
            equip(sets.dps)
        elseif newValue == 'SwordMA' then
            equip(sets.dps.matt)
		elseif newValue == 'ClubMA' then
			equip(sets.matt)
		elseif newValue == 'DWTH' then
			equip(sets.TH)	
        end
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'WEAPONMODE: '..state.WeaponMode.current
    add_to_chat(122, msg)
    eventArgs.handled = true
end

function update_combat_form()
    -- Check for H2H or single-wielding
    if player.equipment.sub == { name="Colada", augments={'DEX+2','Mag. Acc.+7 "Mag.Atk.Bns."+7','"Treasure Hunter"+1',}} then 
		state.ComabatForm:set('TH')
	elseif player.equipment.sub == "Genbu's Shield" or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    else
        state.CombatForm:set('DW')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 16)
    else
        set_macro_page(1, 16)
    end
end
