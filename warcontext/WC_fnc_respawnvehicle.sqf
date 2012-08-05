	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// warcontext - Description:
	// respawn vehicle at their original position
	// Context: server side
	// Xeno respawn reworks
	// -----------------------------------------------
	if (!isServer) exitWith{};

	private [
		"_vehicle", 
		"_delay", 
		"_startpos", 
		"_startdir", 
		"_type", 
		"_disabled", 
		"_vehiclename",
		"_westside",
		"_idleTime",
		"_name",
		"_objets_charges"
	];
	
	_vehicle = _this select 0;
	if(format["%1", _vehicle] == "any") exitWith{};
	_delay = _this select 1;

if (wcUseCarrier == 1) then {
	_startpos = getposasl _vehicle;	// at sea level
} else {
	_startpos = getposatl _vehicle;	// at terrain level
};
	_startdir = getdir _vehicle;
	_type = typeof _vehicle;
	_vehiclename = vehicleVarName _vehicle;
	_idleTime = 0;

	if(wcwithrandomfuel == 1) then {
		_vehicle setfuel random 0.5; 
		_vehicle setVehicleAmmo random 0.5;
	};

	WC_fnc_initializevehicle = {
		_vehicle = _this select 0;
		
		if(wcCustomVehicleHandleDamage == 1) then {
			_vehicle removeAllEventHandlers "HandleDamage";
			_vehicle addEventHandler ['HandleDamage', {
				if (_this select 2 > wcdammagethreshold) then {
					(_this select 0) removeAllEventHandlers "HandleDamage";
					if((_this select 2) + (getdammage (_this select 0)) > 0.9) then {
						(_this select 0) setdamage 1;
					} else {
						(_this select 0) setdamage ((getdammage(_this select 0)) + (_this select 2));
					};
				};
			}];
		};

		if((wcCustomVehicleHandleDamage == 2)) then {
			_vehicle setVariable ["selections", []];
			_vehicle setVariable ["gethit", []];
			_vehicle addEventHandler
			[
				"HandleDamage",
				{
					diag_log text format ["T=%1 : %2", time, _this];

					_unit = _this select 0;
					_selections = _unit getVariable ["selections", []];
					_gethit = _unit getVariable ["gethit", []];
					_selection = _this select 1;
					_source = _this select 3;

					_coeff = 1.0;	// multipy damage by this amount

					if (_unit isKindOf "Helicopter") then {
						_coeff = 1.5;
						if (_selection != "") then {
							_coeff = 0.1;
						};
					};

					if (_unit isKindOf "MV22") then {
						_coeff = 0.5;
						_list = ["ZSU_Base","2S6M_Tunguska"];
						{
							if (_source isKindOf _x) exitWith {
								_coeff = 0.25;
							};
						} forEach _list;
						diag_log text format ["%2 damage coeff: %1", _coeff, typeOf _source];
					};

					if !(_selection in _selections) then
					{
						_selections set [count _selections, _selection];
						_gethit set [count _gethit, 0];
					};
					_i = _selections find _selection;
					_olddamage = _gethit select _i;
					_damage = _olddamage + ((_this select 2) - _olddamage) * _coeff;
					_gethit set [_i, _damage];

					//if (((_selection == "") and (_damage >= 1)) and ((count crew _unit) > 0)) then {
					//	//diag_log "EJECT!!!!!!!!";
					//	{
					//		_x action ["eject", vehicle _x];
					//	} forEach (crew _unit);
					//};

					_damage;
				}
			];
		};
		_vehicle addEventHandler ['Fired', '
			private ["_name"];
			if!(wcdetected) then {
				if((getmarkerpos "rescue") distance (position player) < 400) then {
					wcalerttoadd = random (10);
					["wcalerttoadd", "server"] call WC_fnc_publicvariable;
				};
			};
			wcammoused = wcammoused + 1;
		'];

		if (_vehicle isKindOf "MV22") then {
			_handle = [_vehicle] execVM "f2f_modules\f2f_alss\f2f_exe\f2f_exe_vecInit_clrWeps.sqf";
			waitUntil {scriptDone _handle};
			_text = "";
			_item = "120Rnd_CMFlare_Chaff_Magazine";
			_text = _text + format["this addMagazine '%1';", _item];
			_item = "CMFlareLauncher";
			_text = _text + format["this addWeapon '%1';", _item];
			diag_log _text;
			_vehicle setVehicleInit _text;
			processInitCommands;
		};
	};

	[_vehicle] call WC_fnc_initializevehicle;

	// if simulation vehicles not respawn
	if(wckindofgame == 2) exitwith {};

	while {true} do {
		_disabled = (if (damage _vehicle >= 1.0) then {true} else {false});
		if ((count (crew _vehicle) == 0) or _disabled) then {
			_idleTime = _idleTime + 1;
			if ((locked _vehicle) and !(_disabled) and (alive _vehicle)) then {
				_idleTime = 0;
			};
			if (_disabled || !(alive _vehicle) || ((_idleTime > 1800) and (getpos _vehicle distance _startpos > 10))) then {
				//sleep wctimetogarbagedeadbody;
				sleep 30; // respawn timer
				_vehicle setpos [0,0,0];
				_vehicle setdamage 1;
				_objets_charges = _vehicle getVariable "R3F_LOG_objets_charges";
				clearVehicleInit _vehicle;
				deletevehicle _vehicle;
				sleep 0.5;
				_vehicle = _type createvehicle _startpos;
				if (wcUseCarrier == 1) then {
					_vehicle setposasl _startpos;	// at sea level
				} else {
					_vehicle setposatl _startpos;	// at terrain level
				};
				_vehicle setdir _startdir;
				_vehicle setvehiclevarname _vehiclename;
				_vehicle setvehicleinit format["this setvehiclevarname '%1';", _vehiclename];
				processinitcommands;
				_vehicle setvariable ["R3F_LOG_objets_charges", _objets_charges, true];
				_idleTime = 0;
				_name= getText (configFile >> "CfgVehicles" >> _type >> "DisplayName");
				diag_log format["WARCONTEXT: RESPAWN VEHICLE %1", _name];
				[_vehicle] call WC_fnc_initializevehicle;
			};
		}else{
			_idleTime = 0;
		};
		sleep 1;
	};