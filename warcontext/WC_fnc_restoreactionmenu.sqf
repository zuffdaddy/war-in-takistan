﻿	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// warcontext - restore menu action when player died
	// -----------------------------------------------

	if (isDedicated) exitWith {};

	// Default menu
	player addaction ["<t color='#ff4500'>Mission Info</t>","warcontext\dialogs\WC_fnc_createmenumissioninfo.sqf",[],-1,false];
	player addAction ["<t color='#dddd00'>"+localize "STR_WC_MENUDEPLOYTENT"+"</t>", "warcontext\actions\WC_fnc_dobuildtent.sqf",[],-1,false];
	//player addAction ["<t color='#dddd00'>"+localize "STR_WC_MENUBUILDTRENCH"+"</t>", "warcontext\actions\WC_fnc_dodigtrench.sqf",[],-1,false];

	player addaction ["<t color='#dddd00'>"+localize "STR_WC_MENUUNLOCKVEHICLE"+"</t>","warcontext\actions\WC_fnc_dounlockvehicle.sqf",[],-1,false];
	// Engineer menu
	if (typeOf player in wcengineerclass) then {
		player addaction ["<t color='#dddd00'>"+localize "STR_WC_MENUREPAIRVEHICLE"+"</t>","warcontext\actions\WC_fnc_dorepairvehicle.sqf",[],-1,false];
		player addaction ["<t color='#dddd00'>Unflip Vehicle</t>","warcontext\actions\WC_fnc_dounflipvehicle.sqf",[],-1,false];
	};

	if (typeOf player in wcmedicclass) then {
		player addAction ["<t color='#dddd00'>Heal Self</t>", "warcontext\actions\WC_fnc_doheal.sqf",[player],6,false,false,"",
			"damage player > 0"];
	};

	// new medic action
	if((wceverybodymedic == 1)) then {
		player addAction ["<t color='#dddd00'>Heal</t>", "warcontext\actions\WC_fnc_doheal2.sqf",[cursorTarget],6,false,false,"",
			"(cursorTarget isKindOf 'Man') and ((damage cursorTarget) > 0) and ((player distance cursorTarget) < 4)"];
	};

	// Admin menu
	if (wcadmin) then {
		wcbombingsupport = nil;
		wccancelmission = nil;
		wcmanageteam = nil;
		wcspectate = nil;
	};

	// Check operation Plan
	if(wcchoosemission) then {
		wcchoosemissionmenu = player addAction ["<t color='#dddd00'>"+localize "STR_WC_MENUCHOOSEMISSION"+"</t>", "warcontext\dialogs\WC_fnc_createmenuchoosemission.sqf",[],6,false];
	};