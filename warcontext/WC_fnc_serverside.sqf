	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// warcontext 
	// -----------------------------------------------

	private ["_civillocation"];

	if (!isServer) exitWith{};

	// Grab all WC_fnc_publicvariable events
	if(isdedicated) then {
		wcgarbage = [] spawn WC_fnc_eventhandler;
	};
	wcgarbage = [] spawn WC_fnc_serverhandler;

	_flagObj = nil;
	
	if (wcUseCarrier == 1) then {
		_flagObj = LHD_flagusa;
	} else {
		_flagObj = flagusa;
	};

	// add halo jump option at flag
	if(wcwithhalojump == 1) then {
		_flagObj setvehicleinit 'this addAction ["Halo Jump", "warcontext\actions\WC_fnc_dohalojump.sqf",[],-1,false]';
	};

	// Init Weather
	if(wcwithweather == 1) then {
		wcgarbage = [wcrainrate] spawn WC_fnc_weather;
	};

	if(wcairopposingforce > 0) then {
		wcgarbage = [] spawn WC_fnc_createairpatrol;
	};

	if(wcwithseapatrol == 1) then {
		wcgarbage = [wcseainitpos] spawn WC_fnc_createseapatrol;
	};

	if(wcwithteleporttent == 1) then {
		_flagObj setvehicleinit 'this addAction ["Teleport to TENT", "warcontext\actions\WC_fnc_doteleporttotent.sqf",[],-1,false]'; 
	};

	if(wcwithmhq == 1) then {
		_flagObj setvehicleinit 'this addAction ["Teleport to MHQ", "warcontext\actions\WC_fnc_doteleporttomhq.sqf",[],-1,false]';
	};
	processinitcommands;


	// create mortuary
	wcgarbage = [] spawn WC_fnc_createmortuary;

	// put light around chopper landing zone
	if!(isnull tower2) then {
		_positions = [position tower2, 7, 360, getdir tower2, 7] call WC_fnc_createcircleposition;
		{
			_light = "Land_runway_edgelight" createVehicle _x;
			_light setpos _x;
			_light setVehicleInit "this allowdammage false;";
			processInitCommands;
			sleep 0.01;
		}foreach _positions;
	};

	if!(isnull tower3) then {	
		_positions = [position tower3, 7, 360, getdir tower3, 7] call WC_fnc_createcircleposition;
		{
			_light = "Land_runway_edgelight" createVehicle _x;
			_light setpos _x;
			_light setVehicleInit "this allowdammage false;";
			processInitCommands;
			sleep 0.01;
		}foreach _positions;
	};
	
	if!(isnull tower4) then {
		_positions = [position tower4, 7, 360, getdir tower3, 7] call WC_fnc_createcircleposition;
		{
			_light = "Land_runway_edgelight" createVehicle _x;
			_light setpos _x;
			_light setVehicleInit "this allowdammage false;";
			processInitCommands;
			sleep 0.01;
		}foreach _positions;
	};

	_positions = [getmarkerpos "repair", 7, 360, getdir tower3, 7] call WC_fnc_createcircleposition;
	{
		_light = "Land_runway_edgelight" createVehicle _x;
		_light setpos _x;
		_light setVehicleInit "this allowdammage false;";
		processInitCommands;
		sleep 0.01;
	}foreach _positions;

	[defender1, wcenemyside] spawn WC_fnc_sentinelle;
	[defender2, wcenemyside] spawn WC_fnc_sentinelle;
	[defender3, wcenemyside] spawn WC_fnc_sentinelle;
	[defender4, wcenemyside] spawn WC_fnc_sentinelle;
	[defender5, wcenemyside] spawn WC_fnc_sentinelle;
	[defender6, wcenemyside] spawn WC_fnc_sentinelle;
	[defender7, wcenemyside] spawn WC_fnc_sentinelle;
	[defender8, wcenemyside] spawn WC_fnc_sentinelle;
	[defender9, wcenemyside] spawn WC_fnc_sentinelle;
	[defender10, wcenemyside] spawn WC_fnc_sentinelle;

	{
		wcgarbage = [_x, 120] spawn WC_fnc_respawnvehicle;
		sleep 0.01;
	}foreach wcrespawnablevehicles;
	wcrespawnablevehicles = [];

	{
		if(wcwithcivilian > 0) then {
			wcgarbage = [_x] spawn WC_fnc_popcivilian;
		};

		if(wcwithsheeps == 1) then {
			if(random 1> 0.9) then {
				wcgarbage = [position _x] spawn WC_fnc_createsheep;
			};
		};
	}foreach wctownlocations;

	if(wcwithcivilian > 0) then {
		wcgarbage = [] spawn WC_fnc_civilianinit;
	};


	_bunker = nearestObjects [getmarkerpos "respawn_west", ["Land_fortified_nest_small_EP1"], 20000];
	{
		_dir = getdir _x;
		_pos = getpos _x; 
		_unit = "DSHKM_TK_GUE_EP1" createvehicle _pos; 
		_unit setpos _pos; 
		_unit setdir (_dir + 180);
	}foreach _bunker;



	// we must wait - async return bug of arma
	sleep 1;

	// refresh public markers
	[] spawn {
		while { true } do {
			{
				_position = getmarkerpos (_x select 0);
				(_x select 0) setMarkerPos _position;
				sleep 0.01;
			}foreach wcarraymarker;
			sleep 120;
		};
	};

	// create random nuclear fire
	if(wcwithnuclear == 1) then {
		[] spawn {
			while { true } do {
				sleep (3800 + random (3800));
				if(random 1 > wcnuclearprobability) then {
					wcgarbage = [imam, 1] spawn WC_fnc_createnuclearfire;
				};
			};
		};
	};

	// heartbeat of teamscore and detection
	[] spawn {
		private ["_lastteamscore", "_lastalert"];
		_lastteamscore = 0;
		_lastalert = 0;
		while { true } do {
			if(wcalert > 100) then { wcalert = 100;};
			if(wcfame < 0) then { wcfame = 0;};		
			if(wcteamscore != _lastteamscore) then {
				["wcteamscore", "client"] call WC_fnc_publicvariable;
				_lastteamscore = wcteamscore;
			};
			if(wcalert != _lastalert) then {
				["wcalert", "client"] call WC_fnc_publicvariable;
				_lastalert = wcalert;
			};	
			sleep 5;
		};
	};



	// decrease alert level by time
	[] spawn {
		private["_decrease", "_lastalert"];
		while { true } do {
			_decrease = ceil(random(10));
			if(wcalert > _decrease) then { 
				_enemys = nearestObjects[getmarkerpos "rescuezone",["Man"], 300];
				if((west countside _enemys) == 0) then {
					wcalert = wcalert - _decrease;
					if(wcalert < 0) then { wcalert = 0;};
					if(_lastalert != wcalert) then {
						["wcalert", "client"] call WC_fnc_publicvariable;
					};
				};
			};
			sleep 60;
		};
	};

	// Manage player score
	[] spawn {
		private ["_score", "_player", "_playername", "_point"];
		if(wckindofserver != 3) then {
			while { true } do {
				{
					_playername = _x select 0;
					_player = _x select 1;
					_point = _x select 2;
					if(score _player < 0) then {
						_score = (score _player) * -1;
						_player addscore _score;
					} else {
						if(score _player != _point) then {
							_score = _point - (score _player);
							_player addscore _score;
						};
					};
					sleep 0.01;
				}foreach wcscoreboard;
				sleep 1;
			};
		};
	};

	// create radiation on nuclear zone
	[] spawn {
		private ["_array"];
		while { true } do {
			{
				_array = _x nearEntities [["Man","Landvehicle"], 500];
				{
					if(side _x == civilian) then {
						_x setdamage (getDammage _x +  0.01);
					} else {
						_x setdamage (getDammage _x +  0.001);
					};
					{_x setdamage  (getDammage _x + 0.001); sleep 0.01;} foreach (crew _x);
					sleep 0.01;
				} forEach _array;
				sleep 0.01;
			}foreach wcnuclearzone;
			sleep 1;
		};
	};

	// For open game - all players are team members
	if(wckindofserver != 1) then {
		[] spawn {
			private ["_array", "_knownplayer", "_player", "_lastinteam"];

			// array contains known player (diff jip & player)
			_knownplayer = [];

			while { true } do {
				_array = [];
				
				{
					_player = name _x;
					if!(_player in _knownplayer) then {
						_array = _array + [_player];
						_knownplayer = _knownplayer + [_player];
					};
					sleep 0.01;
				}foreach playableUnits;
	
				_lastinteam = wcinteam + _array;
		
				if(format["%1", wcinteam] != format["%1", _lastinteam]) then {
					wcinteam = _lastinteam;
					["wcinteam", "client"] call WC_fnc_publicvariable;
				};
				sleep 60;
			};
		};
	};

	// synchronize the players rank
	[] spawn {
		private ["_lastranksync"];
		_lastranksync = [];
		while { true } do {
			wcranksync = [];
			{
				wcranksync = wcranksync + [[_x, rank _x]];
				sleep 0.01;
			}foreach playableunits;	
			if(format["%1", _lastranksync] != format["%1", wcranksync]) then {
				_lastranksync = wcranksync;
				["wcranksync", "client"] call WC_fnc_publicvariable;
			};
			sleep 60;
		};
	};

	if (wcReduceAITurretAccuracy == 1) then {
		[] spawn {
			while { true } do {
				{
					_vech = _x;
					if (side _vech == east) then {
						_crew = crew _vech;
						{
							_roleArray = assignedVehicleRole _x;
							if (isNil "_roleArray") exitWith {};
							
							_roleName = _roleArray select 0;
							if (_roleName == "Turret") then {
								_x setSkill ["aimingAccuracy", 0.025];
								_x setSkill ["aimingShake",    0.003];
								_x setUnitRecoilCoefficient 10;
							};
						} foreach _crew;
					};
				} foreach vehicles;
				sleep 1;
			};
		};
	};
	
	// CARRIER SERVICE - repair, rearm and refuel area on the carrier
	[] spawn {
		private ["_objs","_object"];
		while { true } do {
			_objs = nearestObjects [alss_service, ["Air","LandVehicle"], 50];
			{
				_object = _x;
				if (((count (crew _object)) > 0) && (speed _object < 0.1)) then {
	// ---from WC_fnc_servicing ---------------------------------------------------------------------------
	if (!alive _object) exitWith {};

	if (_object isKindOf "MV22") then {
		_handle = [_object] execVM "f2f_modules\f2f_alss\f2f_exe\f2f_exe_vecInit_clrWeps.sqf";
		waitUntil {scriptDone _handle};
		_text = "";
		_item = "120Rnd_CMFlare_Chaff_Magazine";
		_text = _text + format["this addMagazine '%1';", _item];
		_item = "CMFlareLauncher";
		_text = _text + format["this addWeapon '%1';", _item];
		//diag_log _text;
		_object setVehicleInit _text;
		processInitCommands;
	};

	_type = typeof _object;
	_object setVehicleInit "this vehicleChat ""Servicing... Please stand by..."";";
	processInitCommands;
	//sleep ceil(random(5));

	_object setVehicleInit "this setVariable [""selections"", []];this setVariable [""gethit"", []];";
	processInitCommands;

	_type = typeOf _object;
	_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

	if (!alive _object) exitWith {};
	_object setVehicleInit "this vehicleChat ""Reloading weapons ..."";";
	processInitCommands;
	//sleep ceil(random(5));

	if (count _magazines > 0) then {
		_text = "";
		_removed = [];
		{
			if (!(_x in _removed)) then {
				_text = _text + format["this removeMagazines '%1';", _x];
				_removed = _removed + [_x];
			};
		} forEach _magazines;
		{
			_text = _text + format["this addMagazine '%1';", _x];
		} forEach _magazines;
		_text = _text + "this setVehicleAmmo 1;";
		_object setVehicleInit _text;
		processInitCommands;
	};

	_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");
	if (_count > 0) then {
		_text = "";
		for "_i" from 0 to (_count - 1) do {
			_config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
			_magazines = getArray(_config >> "magazines");
			_removed = [];
			{
				if (!(_x in _removed)) then {
					_text = _text + (format["this removeMagazinesTurret ['%1',[%2]];", _x, _i]);
					_removed = _removed + [_x];
				};
			} forEach _magazines;
			{
				_text = _text + (format["this addMagazineTurret ['%1',[%2]];", _x, _i]);
			} forEach _magazines;

		};
		_object setVehicleInit _text;
		processInitCommands;
	};


	if (!alive _object) exitWith {};
	//sleep ceil(random(5));
	if (!alive _object) exitWith {};
	_object setVehicleInit "this vehicleChat ""Repairing...""; this setDamage 0;";
	processInitCommands;
	//sleep ceil(random(5));
	_object setVehicleInit "this vehicleChat ""Refueling..."";";
	processInitCommands;
	//sleep ceil(random(5));
	_object setVehicleInit "this vehicleChat ""Vehicle is ready"";this setfuel 1;";
	processInitCommands;
	// --- end from WC_fnc_servicing ---------------------------------------------------------------------------
						sleep 1;
					};
			} foreach _objs;
			sleep 15;
		};
	};

	onPlayerConnected "[_id, _name] spawn WC_fnc_publishmission";
	onPlayerDisconnected "wcplayerready = wcplayerready - [_name];";