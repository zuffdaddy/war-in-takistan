	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// WARCONTEXT - Description - Init
	//
	// DEVELOPPER - MAP 
	//
	// Main scripts
	// warcontext\WC_fnc_mainloop : loop concerning environment mission on going. First build a new environment, build the mission, wait mission is done, delete environment, and redo the loop.
	// warcontext\WC_fnc_clientside : contains all the client side script call
	// warcontext\WC_fnc_serverside : contains all the server side script call
	// warcontext\WC_fnc_createsidemission : build the mission

	private ["_objs"];
	titleText [localize "STR_WC_MESSAGEINITIALIZING", "BLACK FADED"];


	// initialize lobby parameters
	for "_i" from 0 to (count paramsArray - 1) do {
		call compile format["%1=%2;", configName ((missionConfigFile >> "Params") select _i), paramsArray select _i];
		sleep 0.01;
	};

	if (wcAutoUseACE == 1) then
	{
		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then
		{
			wcwithACE = 1;
			wcautoloadweapons = 1;
			[] spawn {
				waitUntil { sleep 1; ace_sys_eject; };
				ace_sys_eject_fnc_weaponCheckEnabled = { false };
			};
		}
		else
		{
			wcwithACE = 0;
		};
	};

	// protection against dummy player that come with ACE when doesn t need
	if(wcwithACE == 1) then {
		if!(isClass(configFile >> "cfgPatches" >> "ace_main")) then {
			if(isserver) then {				
				while { true } do { hint "Player without ACE:\n check your addons!"; diag_log "WARCONTEXT: DEDICATED SERVER - MISSING ACE ADDONS - WIT DOESNT START"; sleep 10;};
			} else {
				player setpos [0,0,0];
				removeAllItems player;
				removeAllWeapons player;
				player enablesimulation false;
				while { true } do { hint "Player without ACE:\n check your addons!"; sleep 1;};
			};
		};
	} else {
		if (isClass(configFile >> "cfgPatches" >> "ace_main")) then {
			if(isserver) then {
				while { true } do { hint "Player with ACE:\n check your addons!"; diag_log "WARCONTEXT: DEDICATED SERVER - USING ACE WITH NON ACE VERSION - WIT DOESNT START"; sleep 10;};
			} else {
				player setpos [0,0,0];
				removeAllItems player;
				removeAllWeapons player;
				player enablesimulation false;
				while { true } do { hint "Player with ACE:\n check your addons!"; sleep 1;};
			};
		};
	};

	// init R3F arty and logistic script
	[] spawn { execVM "extern\R3F_ARTY_AND_LOG\init.sqf"; };

	// init BON loadout script
	[] spawn { presetDialogUpdate = compile preprocessFile "extern\bon_loadoutpresets\bon_func_presetdlgUpdate.sqf"; };

	// init TPW House Lights Script
	if (wcHouseLights == 1) then {
		[] spawn { execVM "scripts\tpw_houselights108-mp-dedi.sqf"; };
	};

	// init TPWC AI Suppression
	if (wcAISuppressionSystem == 1) then {
		[] spawn { [] execVM "tpwcas\tpwcas.sqf"; };
	};

	// LHD
	// do lhd stuff if wcUseCarrier
	diag_log "LHD Markers";
	basePosLHD =+ getMarkerPos "LHD_bluefor";
	diag_log str (basePosLHD);
	basePosLand =+ getMarkerPos "hq";
	diag_log str (basePosLand);

if (wcUseCarrier == 1) then {
	LHD_mainLight = nil;
	LHD_marker_name = "LHD_location";
	LHD_position = getMarkerPos LHD_marker_name;
	//LHD_position = [0,0,0];
	LHD_direction = markerDir LHD_marker_name;
	//LHD_direction = 0;
	LHD_deck_height = 16;	// 17.5 for vehicle spawns

	// get positonal and direction info for our placeholder
	LHD_spawnGuide_pos = getMarkerPos "LHD_spawnGuide";
	LHD_spawnGuide_dir = markerDir "LHD_spawnGuide";

	// get the old base position so we can delete whatever is there later
	//basePosLand = getMarkerPos "bluefor";
	
if (isServer) then {
	LHD_parts =
	[
		"Land_LHD_house_1",
		"Land_LHD_house_2",
		"Land_LHD_elev_R",
		"Land_LHD_1",
		"Land_LHD_2",
		"Land_LHD_3",
		"Land_LHD_4",
		"Land_LHD_5",
		"Land_LHD_6"
	];

	{
		_dummy = _x createvehicle LHD_position;
		_dummy setdir LHD_direction;
		_dummy setpos LHD_position;
	} forEach LHD_parts;

	// ---------------------------------------------------------------------------------
	// ok here we go. try to grab a base layout from land and place it on the carrier
	// ---------------------------------------------------------------------------------


	// get everything in a radius around our land carrier placeholder
	_objs = nearestObjects [LHD_spawnGuide_pos, ["All"], 250];

	// get everything in our carrier placeholder rectangle
	_validObjects = [];
	{
		_isInArea = [LHD_area_total, getPos _x] call BIS_fnc_inTrigger;
		if (_isInArea) then {
			_validObjects = _validObjects + [_x];
		};
	} foreach _objs;
	_objs = [];

	// get a relPos pair for each object we want on the carrier
	{
		_obj = _x;
		_objPos = getPos _x;
		_objDir = getDir _x;

		_zOffset = 0;
		if (_obj isKindOf "Static") then {
			_zOffset = 0.1;
		} else {
			_zOffset = 0.5;
		};

		_dist = [LHD_spawnGuide_pos, _objPos] call BIS_fnc_distance2D;
		_dir = [LHD_spawnGuide_pos, _objPos] call BIS_fnc_dirTo;

		_temp_lhd_pos = [LHD_position, _dist, _dir + LHD_direction] call BIS_fnc_relpos;
		_obj setPosASL [_temp_lhd_pos select 0, _temp_lhd_pos select 1, LHD_deck_height + _zOffset];
		_obj setDir LHD_direction + _objDir;
	} foreach _validObjects;
};

	_markers = [
		"respawn_west",
		"crate1",
		"autoloadcrate",
		"hospital",
		"convoystart",
		"bluefor"//,
		//"alss"
	];

	{
		_mark = _x;
		//_markPos = getMarkerPos _mark;
		//_markDir = markerDir _mark;

		_lhdMark = format ["LHD_%1", _mark];
		_lhdMarkPos = getMarkerPos _lhdMark;
		_lhdMarkDir = markerDir _lhdMark;

		_dist = [LHD_spawnGuide_pos, _lhdMarkPos] call BIS_fnc_distance2D;
		_dir = [LHD_spawnGuide_pos, _lhdMarkPos] call BIS_fnc_dirTo;

		_temp_lhd_pos = [LHD_position, _dist, _dir + LHD_direction] call BIS_fnc_relpos;
		_mark setMarkerPos [_temp_lhd_pos select 0, _temp_lhd_pos select 1, LHD_deck_height + 0.5];
		_mark setMarkerDir LHD_direction + _lhdMarkDir;

	} foreach _markers;

	// move mission board and officer to carrier
if (isServer) then {
	_lhdMarkPos = getMarkerPos "LHD_board";
	_lhdMarkDir = markerDir "LHD_board";
	
	_dist = [LHD_spawnGuide_pos, _lhdMarkPos] call BIS_fnc_distance2D;
	_dir = [LHD_spawnGuide_pos, _lhdMarkPos] call BIS_fnc_dirTo;
	
	_temp_lhd_pos = [LHD_position, _dist, _dir + LHD_direction] call BIS_fnc_relpos;
	board setPosASL [_temp_lhd_pos select 0, _temp_lhd_pos select 1, LHD_deck_height + 0.1];
	// move officer with waypoints to the board
	anim setPosASL (getPosASL board);
};
	_officerWPS = waypoints anim;
	{
		_x setWPPos (getPosASL anim);
	} foreach _officerWPS;
	// end move mission board and officer

	// move alss and it's repair service trigger
	_alssMarkers = ["alss_text", "alss_circle"];
	_alssVehicles = ["alss_service", "alss_pad"];

	{
		_mark = _x;
		//_markPos = getMarkerPos _mark;
		//_markDir = markerDir _mark;

		//_lhdMark = format ["LHD_%1", _mark];
		_lhdMark = "LHD_alss";
		_lhdMarkPos = getMarkerPos _lhdMark;
		_lhdMarkDir = markerDir _lhdMark;

		_dist = [LHD_spawnGuide_pos, _lhdMarkPos] call BIS_fnc_distance2D;
		_dir = [LHD_spawnGuide_pos, _lhdMarkPos] call BIS_fnc_dirTo;

		_temp_lhd_pos = [LHD_position, _dist, _dir + LHD_direction] call BIS_fnc_relpos;
		_mark setMarkerPos [_temp_lhd_pos select 0, _temp_lhd_pos select 1, LHD_deck_height + 0.5];
		_mark setMarkerDir LHD_direction + _lhdMarkDir;

	} foreach _alssMarkers;

	_alssPos = getMarkerPos "alss_circle";
	_alssPos = [_alssPos select 0, _alssPos select 1, LHD_deck_height + 1];
	alss_service setPosASL _alssPos;
	alss_pad setPosASL _alssPos;

//if (isServer) then {
//	flagusa setPosASL [getMarkerPos "respawn_west" select 0, getMarkerPos "respawn_west" select 1, LHD_deck_height];
//};

};
	// remove the ghost base
	if (isServer) then {
		removeBaseAtPos1 = [];
		removeBaseAtPos2 = [];
		if (wcUseCarrier == 1) then {
			removeBaseAtPos1 = basePosLand;
			diag_log str (removeBaseAtPos1);
			objs1 = nearestObjects [removeBaseAtPos1, ["All"], 200];
			{
				diag_log format["objs1 delete: %1",_x];
				deleteVehicle _x;
			} foreach objs1;
			diag_log str (objs1);
		} else {
			removeBaseAtPos2 = basePosLHD;
			diag_log str (removeBaseAtPos2);
			objs2 = nearestObjects [removeBaseAtPos2, ["All"], 200];
			{
				diag_log format["objs2 delete: %1",_x];
				deleteVehicle _x;
			} foreach objs2;
			diag_log str (objs2);
		};
	};

	// external scripts
	EXT_fnc_atot 			= compile preprocessFile "extern\EXT_fnc_atot.sqf";
	EXT_fnc_createcomposition	= compile preprocessFile "extern\EXT_fnc_createcomposition.sqf";
	EXT_fnc_SortByDistance		= compile preprocessFile "extern\EXT_fnc_Common_SortByDistance.sqf";
	EXT_fnc_infotext		= compile preprocessFile "extern\EXT_fnc_infoText.sqf";
	WC_fnc_teamstatus		= compile preprocessFile "extern\TeamStatusDialog\TeamStatusDialog.sqf";

	// warcontext config files
	WC_fnc_clientinitconfig 	= compile preprocessFile "WC_fnc_clientinitconfig.sqf";
	WC_fnc_commoninitconfig 	= compile preprocessFile "WC_fnc_commoninitconfig.sqf";
	WC_fnc_serverinitconfig 	= compile preprocessFile "WC_fnc_serverinitconfig.sqf";

	// warcontext anim - camera
	WC_fnc_intro			= compile preprocessFile "warcontext\camera\WC_fnc_intro.sqf";
	WC_fnc_camfocus 		= compile preprocessFile "warcontext\camera\WC_fnc_camfocus.sqf";
	WC_fnc_credits			= compile preprocessFile "warcontext\camera\WC_fnc_credits.sqf";
	WC_fnc_outro			= compile preprocessFile "warcontext\camera\WC_fnc_outro.sqf";
	WC_fnc_outrolooser		= compile preprocessFile "warcontext\camera\WC_fnc_outrolooser.sqf";

	// warcontext ressources
	WC_fnc_enumcfgpatches 		= compile preprocessFile "warcontext\ressources\WC_fnc_enumcfgpatches.sqf";
	WC_fnc_enumcompositions		= compile preprocessFile "warcontext\ressources\WC_fnc_enumcompositions.sqf";
	WC_fnc_enumfaction 		= compile preprocessFile "warcontext\ressources\WC_fnc_enumfaction.sqf";
	WC_fnc_enummagazines 		= compile preprocessFile "warcontext\ressources\WC_fnc_enummagazines.sqf";
	WC_fnc_enummusic 		= compile preprocessFile "warcontext\ressources\WC_fnc_enummusic.sqf";
	WC_fnc_enumvehicle 		= compile preprocessFile "warcontext\ressources\WC_fnc_enumvehicle.sqf";
	WC_fnc_enumweapons 		= compile preprocessFile "warcontext\ressources\WC_fnc_enumweapons.sqf";
	WC_fnc_enumvillages		= compile preprocessFile "warcontext\ressources\WC_fnc_enumvillages.sqf";


	// warcontext functions
	WC_fnc_attachmarker 		= compile preprocessFile "warcontext\functions\WC_fnc_attachmarker.sqf";
	WC_fnc_attachmarkerlocal	= compile preprocessFile "warcontext\functions\WC_fnc_attachmarkerlocal.sqf";
	WC_fnc_attachmarkerinzone	= compile preprocessFile "warcontext\functions\WC_fnc_attachmarkerinzone.sqf";
	WC_fnc_backupbuilding		= compile preprocessFile "warcontext\functions\WC_fnc_backupbuilding.sqf";
	WC_fnc_checkpilot		= compile preprocessFile "warcontext\functions\WC_fnc_checkpilot.sqf";
	WC_fnc_clockformat 		= compile preprocessFile "warcontext\functions\WC_fnc_clockformat.sqf";
	WC_fnc_copymarker 		= compile preprocessFile "warcontext\functions\WC_fnc_copymarker.sqf";
	WC_fnc_copymarkerlocal 		= compile preprocessFile "warcontext\functions\WC_fnc_copymarkerlocal.sqf";
	WC_fnc_creategridofposition	= compile preprocessFile "warcontext\functions\WC_fnc_creategridofposition.sqf";
	WC_fnc_createmarker 		= compile preprocessFile "warcontext\functions\WC_fnc_createmarker.sqf";
	WC_fnc_createmarkerlocal	= compile preprocessFile "warcontext\functions\WC_fnc_createmarkerlocal.sqf";
	WC_fnc_createcircleposition	= compile preprocessFile "warcontext\functions\WC_fnc_createcircleposition.sqf";
	WC_fnc_createposition 		= compile preprocessFile "warcontext\functions\WC_fnc_createposition.sqf";
	WC_fnc_createpositionaround	= compile preprocessFile "warcontext\functions\WC_fnc_createpositionaround.sqf";
	WC_fnc_createpositioninmarker 	= compile preprocessFile "warcontext\functions\WC_fnc_createpositioninmarker.sqf";
	WC_fnc_deletemarker		= compile preprocessFile "warcontext\functions\WC_fnc_deletemarker.sqf";
	WC_fnc_garbagecollector		= compile preprocessFile "warcontext\functions\WC_fnc_garbagecollector.sqf";
	WC_fnc_getobject		= compile preprocessFile "warcontext\functions\WC_fnc_getobject.sqf";
	WC_fnc_getterraformvariance	= compile preprocessFile "warcontext\functions\WC_fnc_getterraformvariance.sqf";
	WC_fnc_isInheritFrom		= compile preprocessFile "warcontext\functions\WC_fnc_isInheritFrom.sqf";
	WC_fnc_markerhint		= compile preprocessFile "warcontext\functions\WC_fnc_markerhint.sqf";
	WC_fnc_markerhintlocal		= compile preprocessFile "warcontext\functions\WC_fnc_markerhintlocal.sqf";
	WC_fnc_missionname	 	= compile preprocessFile "warcontext\functions\WC_fnc_missionname.sqf";
	WC_fnc_playerhint		= compile preprocessFile "warcontext\functions\WC_fnc_playerhint.sqf";
	WC_fnc_playersmarkers		= compile preprocessFile "warcontext\functions\WC_fnc_playersmarkers.sqf";
	WC_fnc_sortlocationbydistance	= compile preprocessFile "warcontext\functions\WC_fnc_sortlocationbydistance.sqf";
	WC_fnc_randomMinMax		= compile preprocessFile "warcontext\functions\WC_fnc_randomMinMax.sqf";
	WC_fnc_range			= compile preprocessFile "warcontext\functions\WC_fnc_range.sqf";
	WC_fnc_relocatelocation		= compile preprocessFile "warcontext\functions\WC_fnc_relocatelocation.sqf";
	WC_fnc_relocateposition		= compile preprocessFile "warcontext\functions\WC_fnc_relocateposition.sqf";
	WC_fnc_restorebuilding		= compile preprocessFile "warcontext\functions\WC_fnc_restorebuilding.sqf";
	WC_fnc_seed	 		= compile preprocessFile "warcontext\functions\WC_fnc_seed.sqf";
	WC_fnc_setskill 		= compile preprocessFile "warcontext\functions\WC_fnc_setskill.sqf";
	WC_fnc_vehiclesmarkers		= compile preprocessFile "warcontext\functions\WC_fnc_vehiclesmarkers.sqf";
	WC_fnc_weaponcanflare		= compile preprocessFile "warcontext\functions\WC_fnc_weaponcanflare.sqf";
	WC_fnc_weather		 	= compile preprocessFile "warcontext\functions\WC_fnc_weather.sqf";

	// warcontext ambiant scripts 
	WC_fnc_antiair 			= compile preprocessFile "warcontext\WC_fnc_antiair.sqf";
	WC_fnc_airpatrol 		= compile preprocessFile "warcontext\WC_fnc_airpatrol.sqf";
	WC_fnc_ambiantlife 		= compile preprocessFile "warcontext\WC_fnc_ambiantlife.sqf";
	WC_fnc_bomb			= compile preprocessFile "warcontext\WC_fnc_bomb.sqf";
	WC_fnc_computeavillage 		= compile preprocessFile "warcontext\WC_fnc_computeavillage.sqf";
	WC_fnc_createammobox 		= compile preprocessFile "warcontext\WC_fnc_createammobox.sqf";
	WC_fnc_createairpatrol		= compile preprocessFile "warcontext\WC_fnc_createairpatrol.sqf";
	WC_fnc_createseapatrol		= compile preprocessFile "warcontext\WC_fnc_createseapatrol.sqf";
	WC_fnc_createsheep		= compile preprocessFile "warcontext\WC_fnc_createsheep.sqf";
	WC_fnc_createcomposition	= compile preprocessFile "warcontext\WC_fnc_createcomposition.sqf";
	WC_fnc_createcivilcar 		= compile preprocessFile "warcontext\WC_fnc_createcivilcar.sqf";
	WC_fnc_createconvoy 		= compile preprocessFile "warcontext\WC_fnc_createconvoy.sqf";
	WC_fnc_creategenerator 		= compile preprocessFile "warcontext\WC_fnc_creategenerator.sqf";
	WC_fnc_creategroup 		= compile preprocessFile "warcontext\WC_fnc_creategroup.sqf";
	WC_fnc_creategroupdefend	= compile preprocessFile "warcontext\WC_fnc_creategroupdefend.sqf";
	WC_fnc_creategroupsupport	= compile preprocessFile "warcontext\WC_fnc_creategroupsupport.sqf";
	WC_fnc_createied 		= compile preprocessFile "warcontext\WC_fnc_createied.sqf";
	WC_fnc_createiedintown 		= compile preprocessFile "warcontext\WC_fnc_createiedintown.sqf";
	WC_fnc_createlistofmissions	= compile preprocessFile "warcontext\WC_fnc_createlistofmissions.sqf";
	WC_fnc_createmedic 		= compile preprocessFile "warcontext\WC_fnc_createmedic.sqf";
	WC_fnc_createmortuary		= compile preprocessFile "warcontext\WC_fnc_createmortuary.sqf";
	WC_fnc_createnuclearfire 	= compile preprocessFile "warcontext\WC_fnc_createnuclearfire.sqf";
	WC_fnc_createnuclearzone 	= compile preprocessFile "warcontext\WC_fnc_createnuclearzone.sqf";
	WC_fnc_createradio	 	= compile preprocessFile "warcontext\WC_fnc_createradio.sqf";
	WC_fnc_createsidemission 	= compile preprocessFile "warcontext\WC_fnc_createsidemission.sqf";
	WC_fnc_createstatic	 	= compile preprocessFile "warcontext\WC_fnc_createstatic.sqf";
	WC_fnc_createmhq	 	= compile preprocessFile "warcontext\WC_fnc_createmhq.sqf";
	WC_fnc_debug			= compile preprocessFile "warcontext\WC_fnc_debug.sqf";
	WC_fnc_dosillything		= compile preprocessFile "warcontext\WC_fnc_dosillything.sqf";
	WC_fnc_eventhandler 		= compile preprocessFile "warcontext\WC_fnc_eventhandler.sqf";
	WC_fnc_exportweaponsplayer	= compile preprocessFile "warcontext\WC_fnc_exportweaponsplayer.sqf";
	WC_fnc_fasttime			= compile preprocessFile "warcontext\WC_fnc_fasttime.sqf";
	WC_fnc_fireflare 		= compile preprocessFile "warcontext\WC_fnc_fireflare.sqf";
	WC_fnc_grouphandler		= compile preprocessFile "warcontext\WC_fnc_grouphandler.sqf";
	WC_fnc_ieddetector		= compile preprocessFile "warcontext\WC_fnc_ieddetector.sqf";
	WC_fnc_keymapper		= compile preprocessFile "warcontext\WC_fnc_keymapper.sqf";
	WC_fnc_lifeslider		= compile preprocessFile "warcontext\WC_fnc_lifeslider.sqf";
	WC_fnc_light			= compile preprocessFile "warcontext\WC_fnc_light.sqf";
	WC_fnc_loadweapons 		= compile preprocessFile "warcontext\WC_fnc_loadweapons.sqf";
	WC_fnc_mainloop 		= compile preprocessFile "warcontext\WC_fnc_mainloop.sqf";
	WC_fnc_mortar		 	= compile preprocessFile "warcontext\WC_fnc_mortar.sqf";
	WC_fnc_nastyvehicleevent	= compile preprocessFile "warcontext\WC_fnc_nastyvehicleevent.sqf";
	WC_fnc_nuclearnuke		= compile preprocessFile "warcontext\WC_fnc_nuclearnuke.sqf";
	WC_fnc_onkilled			= compile preprocessFile "warcontext\WC_fnc_onkilled.sqf";
	WC_fnc_patrol			= compile preprocessFile "warcontext\WC_fnc_patrol.sqf";
	WC_fnc_clienthandler		= compile preprocessFile "warcontext\WC_fnc_clienthandler.sqf";
	WC_fnc_playerranking		= compile preprocessFile "warcontext\WC_fnc_playerranking.sqf";
	WC_fnc_protectobject		= compile preprocessFile "warcontext\WC_fnc_protectobject.sqf";
	WC_fnc_publishmission		= compile preprocessFile "warcontext\WC_fnc_publishmission.sqf";
	WC_fnc_restoreloadout		= compile preprocessFile "warcontext\WC_fnc_restoreloadout.sqf";
	WC_fnc_restoreactionmenu	= compile preprocessFile "warcontext\WC_fnc_restoreactionmenu.sqf";
	WC_fnc_respawnvehicle		= compile preprocessFile "warcontext\WC_fnc_respawnvehicle.sqf";
	WC_fnc_seapatrol 		= compile preprocessFile "warcontext\WC_fnc_seapatrol.sqf";
	WC_fnc_serverhandler 		= compile preprocessFile "warcontext\WC_fnc_serverhandler.sqf";
	WC_fnc_serverside 		= compile preprocessFile "warcontext\WC_fnc_serverside.sqf";
	WC_fnc_sentinelle	 	= compile preprocessFile "warcontext\WC_fnc_sentinelle.sqf";
	WC_fnc_support	 		= compile preprocessFile "warcontext\WC_fnc_support.sqf";
	WC_fnc_saveloadout		= compile preprocessFile "warcontext\WC_fnc_saveloadout.sqf";
	WC_fnc_vehiclehandler 		= compile preprocessFile "warcontext\WC_fnc_vehiclehandler.sqf";

	// wit civilians script
	WC_fnc_altercation 		= compile preprocessFile "warcontext\civilian\WC_fnc_altercation.sqf";
	WC_fnc_buildercivilian		= compile preprocessFile "warcontext\civilian\WC_fnc_buildercivilian.sqf";
	WC_fnc_civilianinit 		= compile preprocessFile "warcontext\civilian\WC_fnc_civilianinit.sqf";
	WC_fnc_drivercivilian		= compile preprocessFile "warcontext\civilian\WC_fnc_drivercivilian.sqf";
	WC_fnc_healercivilian		= compile preprocessFile "warcontext\civilian\WC_fnc_healercivilian.sqf";
	WC_fnc_popcivilian		= compile preprocessFile "warcontext\civilian\WC_fnc_popcivilian.sqf";
	WC_fnc_propagand		= compile preprocessFile "warcontext\civilian\WC_fnc_propagand.sqf";
	WC_fnc_sabotercivilian 		= compile preprocessFile "warcontext\civilian\WC_fnc_sabotercivilian.sqf";

	// wit missions scripts
	WC_fnc_bringvehicle		= compile preprocessFile "warcontext\missions\WC_fnc_bringvehicle.sqf";
	WC_fnc_build			= compile preprocessFile "warcontext\missions\WC_fnc_build.sqf";
	WC_fnc_defend			= compile preprocessFile "warcontext\missions\WC_fnc_defend.sqf";
	WC_fnc_destroygroup		= compile preprocessFile "warcontext\missions\WC_fnc_destroygroup.sqf";
	WC_fnc_heal			= compile preprocessFile "warcontext\missions\WC_fnc_heal.sqf";
	WC_fnc_jail			= compile preprocessFile "warcontext\missions\WC_fnc_jail.sqf";
	WC_fnc_liberatehotage 		= compile preprocessFile "warcontext\missions\WC_fnc_liberatehotage.sqf";
	WC_fnc_rescuecivil		= compile preprocessFile "warcontext\missions\WC_fnc_rescuecivil.sqf";
	WC_fnc_rob			= compile preprocessFile "warcontext\missions\WC_fnc_rob.sqf";
	WC_fnc_steal	 		= compile preprocessFile "warcontext\missions\WC_fnc_steal.sqf";
	WC_fnc_sabotage	 		= compile preprocessFile "warcontext\missions\WC_fnc_sabotage.sqf";
	WC_fnc_securezone 		= compile preprocessFile "warcontext\missions\WC_fnc_securezone.sqf";

	wcgarbage = [] call WC_fnc_commoninitconfig;

	waituntil {!isnil "bis_fnc_init"};

	//
	//	CLIENT SIDE
	//
	if(local player) then { wcgarbage = [] execVM "warcontext\WC_fnc_clientside.sqf"; };

	//
	//	SERVER SIDE
	//
	if (!isServer) exitWith{};

	diag_log "WARCONTEXT: INITIALIZING MISSION";

	call compile preprocessFileLineNumbers "extern\Init_UPSMON.sqf";
	
	// Init global variables
	wcgarbage = [] call WC_fnc_serverinitconfig;

	// Init Debugger
	wcgarbage = [] spawn WC_fnc_debug;

	// Init Mission - Main loop
	wcgarbage = [] spawn WC_fnc_mainloop;

	// Init Server SIDE
	wcgarbage = [] spawn WC_fnc_serverside;
	
	enableSaving [false, false];
