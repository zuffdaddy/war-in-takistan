/*    
TPWC AI SUPPRESSION 
SP / MP / DEDI COMPATIBLE   

Authors: TPW && -Coulum- && fabrizio_T && Ollem

Version: 3.04  

Last modified: 20120810 

Requires: 		CBA
				bdetect074.sqf
				tpwcas_client_debug.sqf
				tpwcas_debug.sqf
				tpwcas_decskill.sqf
				tpwcas_incskill.sqf
				tpwcas_mainloop.sqf
				tpwcas_supstate.sqf
				tpwcas_textdebug.sqf
				tpwcas_visuals.sqf
				
Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original authors in any derivative works. 
*/    


///////////////////// 
// GENERAL VARIABLES 
/////////// /////////
if ( (count _this) == 15 ) then 
	{
	tpwcas_hint = _this select 0;
	tpwcas_sleep = _this select 1;
	tpwcas_debug = _this select 2;
	tpwcas_textdebug = _this select 3;
	tpwcas_ir = _this select 4;
	tpwcas_maxdist = _this select 5;
	tpwcas_bulletlife = _this select 6;
	tpwcas_st = _this select 7;
	tpwcas_mags = _this select 8;
	tpwcas_skillsup = _this select 9;
	tpwcas_playershake = _this select 10;
	tpwcas_playervis = _this select 11;
	tpwcas_minskill = _this select 12;
	tpwcas_reveal = _this select 13;
	tpwcas_canflee = _this select 14;
	};

//STARTUP HINT (TPWCAS & BDETECT). 0 = NO HINT, 1 = HINT. 
if(isNil "tpwcas_hint") then {
	tpwcas_hint = 0;
	}; 

//DELAY BEFORE SUPPRESSION FUNCTIONS START. ALLOWS TIME FOR OTHER MODS TO INITIALISE ETC. 
if(isNil "tpwcas_sleep") then {
	tpwcas_sleep = 1;
	}; 

//DEBUGGING. 0 = NO DEBUGGING, 1 = DISPLAY COLOURED BALLS OVER ANY SUPPRESSED UNITS, 2 = BALLS + BDETECT LOGGING. 
if(isNil "tpwcas_debug") then {
	tpwcas_debug = 0;
	}; 

//TEXT BASED DEBUG RATE (Hz). 0 = NO TEXT DEBUGGING. 5 = 5 UPDATES PER SECOND. 
if(isNil "tpwcas_textdebug") then {
	tpwcas_textdebug = 0;
	}; 

////////////////////
// BULLET VARIABLES
////////////////////

//BULLET IGNORE RADIUS (M). BULLETS FROM A SHOOTER CLOSER THAN THIS WILL NOT SUPPRESS.  
if(isNil "tpwcas_ir") then {
	tpwcas_ir = 25;
	}; 


//MAXIMUM BULLET DISTANCE (m). A BULLET FURTHER THAN THIS FROM ITS SHOOTER WILL NOT SUPPRESS. SET LARGER IF YOU PLAN ON DOING A LOT OF SNIPING - BUT MAY IMPACT PERFORMANCE.
if(isNil "tpwcas_maxdist") then {
	tpwcas_maxdist = 800;
	}; 

//BULLET LIFETIME (sec). BULLETS STILL ALIVE THIS LONG AFTER BEING SHOT ARE IGNORED.
if(isNil "tpwcas_bulletlife") then {
	tpwcas_bulletlife = 1;
	}; 

//SHOT THRESHOLD. MORE SHOTS THAN THIS WILL CAUSE UNIT TO DROP/CRAWL. 
if(isNil "tpwcas_st") then {
	tpwcas_st = 10;
	}; 

//PISTOL AND SMG AMMO TO IGNORE. ADD CUSTOM AMMO (EG SUPPRESSED) OR CHANGE TO TASTE.   
//ToDo: add ACR DLC Ammo
if(isNil "tpwcas_mags") then 
	{
	tpwcas_mags =   
		[   
		"30rnd_9x19_MP5",      
		"30rnd_9x19_MP5SD",      
		"15Rnd_9x19_M9",      
		"15Rnd_9x19_M9SD",      
		"7Rnd_45ACP_1911",      
		"7Rnd_45ACP_1911",     
		"8Rnd_9x18_Makarov",     
		"8Rnd_9x18_MakarovSD",     
		"64Rnd_9x19_Bizon",     
		"64Rnd_9x19_SD_Bizon",     
		"13Rnd_9mm_SLP",     
		"17Rnd_9x19_glock17",     
		"6Rnd_45ACP",     
		"30Rnd_9x19_UZI",     
		"30Rnd_9x19_UZI_SD",
		"ACE_17Rnd_9x19_G17",
		"ACE_33Rnd_9x19_G18",
		"ACE_30Rnd_9x19_S_UZI",
		"ACE_20Rnd_765x17_vz61",
		"ACE_20Rnd_9x39_S_SP6_OC14",
		"ACE_20Rnd_9x39_B_SP6_OC14",
		"ACE_20Rnd_9x39_S_OC14",
		"ACE_20Rnd_9x39_B_OC14",
		"ACE_20Rnd_9x39_SP6_VSS",
		"ACE_10Rnd_9x39_SP6_VSS",
		"ACE_64Rnd_9x19_S_Bizon",
		"ACE_30Rnd_1143x23_B_M3",
		"ACE_25Rnd_1143x23_S_UMP45",
		"ACE_25Rnd_1143x23_B_UMP45",
		"ACE_30Rnd_9x19_S_MP5",
		"ACE_40Rnd_S_46x30_MP7",
		"ACE_40Rnd_B_46x30_MP7",
		"ACE_15Rnd_9x19_P8",
		"ACE_15Rnd_9x19_P226",
		"ACE_13Rnd_9x19_L9A1",
		"ACE_15Rnd_9x19_S_M9",
		"ACE_20Rnd_9x18_APSB",
		"ACE_20Rnd_9x18_APS",
		"ACE_8Rnd_762x25_B_Tokarev",
		"ACE_12Rnd_45ACP_USP",
		"ACE_12Rnd_45ACP_USPSD"
		]; 
	};	

/////////////////////////
// SUPPRESSION VARIABLES
/////////////////////////
	
//AI SKILL SUPPRESSION. 0 = SKILLS WILL NOT BE CHANGED, ONLY STANCE. 1 = SKILLS AND STANCE CHANGED UNDER SUPPRESSION. 
if(isNil "tpwcas_skillsup") then {
	tpwcas_skillsup = 1;
	}; 

//PLAYER SUPPRESSION SHAKE. 0 = NO SUPPRESSION, 1 = SUPPRESSION.    
if(isNil "tpwcas_playershake") then {
	tpwcas_playershake = 0;
	};  

//PLAYER SUPPRESSION VISUALS. 0 = NO SUPPRESSION, 1 = SUPPRESSION.     
if(isNil "tpwcas_playervis") then {
	tpwcas_playervis = 0;
	}; 

//MINIMUM SKILL VALUE, NONE OF A UNIT'S SKILLS WILL DROP BELOW THIS UNDER SUPPRESSION. 
if(isNil "tpwcas_minskill") then {
	tpwcas_minskill = 0.05;
	};  

//REVEAL VALUE WHEN SUPPRESSED. 0 = REVEAL DISABLED. <1 = SUPPRESSED UNIT KNOWS NOTHING ABOUT SHOOTER. 4 = UNIT KNOWS THE SHOOTER'S SIDE, POSITION, SHOE SIZE ETC. 
if(isNil "tpwcas_reveal") then {
	tpwcas_reveal = 1.25;
	}; 

//UNITS CAN FLEE IF COURAGE AND MORALE TOO LOW. 0 = UNITS WILL NOT FLEE. 1 = UNITS WILL FLEE. SET TO 0 IF TOO MANY UNITS ARE FLEEING OR UNSUPPRESSABLE. 
if(isNil "tpwcas_canflee") then {
	tpwcas_canflee = 1;
	}; 

//////////   
//SET UP    
//////////   

//WAIT 
sleep tpwcas_sleep;    

//START HINT       
if (tpwcas_hint == 1) then 
	{    
	0 = [] spawn 
		{   
		hintsilent "TPWCAS 3.04 Active";    
		sleep 3;    
		hintsilent "";
		};    
	}; 

//CHECK IF ASR_AI 1.15.1 OR GREATER IS RUNNING       
if (isclass (configfile >> "cfgPatches">>"asr_ai_sys_aiskill")) then    
	{   
	_asr_ai_va = getArray (configfile>>"cfgPatches">>"asr_ai_main">>"versionAr");  
	if (_asr_ai_va select 0 >= 1 && _asr_ai_va select 1 >= 15 && _asr_ai_va select 2 >= 1) then   
		{  
		//DISABLE REVEAL
		tpwcas_reveal = 0; 
		};      
	};		
	
	
//////////////////////////
//COMPILE TPWCAS FUNCTIONS
//////////////////////////
call compile preprocessFileLineNumbers "tpwcas\tpwcas_client_debug.sqf"; //visual debugging
call compile preprocessFileLineNumbers "tpwcas\tpwcas_debug.sqf"; //visual debugging
call compile preprocessFileLineNumbers "tpwcas\tpwcas_decskill.sqf"; //decrease AI skills
call compile preprocessFileLineNumbers "tpwcas\tpwcas_incskill.sqf"; //increase AI skills
call compile preprocessFileLineNumbers "tpwcas\tpwcas_mainloop.sqf"; //main loop
call compile preprocessFileLineNumbers "tpwcas\tpwcas_supstate.sqf"; //bdetect callback to assign unit suppression status
call compile preprocessFileLineNumbers "tpwcas\tpwcas_textdebug.sqf"; //text debugging
call compile preprocessFileLineNumbers "tpwcas\tpwcas_visuals.sqf"; //player suppression visuals


//////////////
//CALL BDETECT
////////////// 

call compile preprocessFileLineNumbers "tpwcas\bdetect074.sqf"; //bullet detection
bdetect_bullet_skip_mags = tpwcas_mags; 
bdetect_bullet_min_distance =  tpwcas_ir;
bdetect_bullet_max_distance = tpwcas_maxdist;
bdetect_bullet_max_lifespan = tpwcas_bulletlife;
bdetect_debug_levels = [0,1,3,5,6,7,8,9,10];
tpwcas_multi_player = false;
bdetect_debug_enable = false;
if (tpwcas_debug > 1) then 
	{
	bdetect_debug_enable = true;
	};
if ( isDedicated ) then 
	{
	bdetect_mp = true;
	bdetect_mp_per_frame_emulation = true;
	bdetect_mp_per_frame_emulation_frame_d = 0.02;
	tpwcas_textdebug = 0;
	tpwcas_st = 8;
	};

if ( ( !(isServer) || isDedicated ) ) then  
	{ 
	tpwcas_multi_player = true;
	};

if (tpwcas_hint == 0) then 
	{
	bdetect_startup_hint = false;
	};
	
bdetect_callback = "tpwcas_fnc_supstate"; 
sleep 1;
call bdetect_fnc_init; 
waitUntil { !(isNil "bdetect_init_done") };

////////
//RUN IT 
////////
	
// In case of Dedicated Server make sure parameters are synched if adjusted
if ( isDedicated ) then
	{
	publicVariable "tpwcas_maxdist";
	publicVariable "tpwcas_ir"; 
	publicVariable "tpwcas_st"; 

	publicVariable "tpwcas_skillsup"; 
	publicVariable "tpwcas_minskill"; 
	publicVariable "tpwcas_reveal"; 
	publicVariable "tpwcas_canflee";

	publicVariable "tpwcas_playershake"; 
	publicVariable "tpwcas_playervis";

	publicVariable "tpwcas_debug";
	publicVariable "tpwcas_multi_player";		
	publicVariable "bdetect_bullet_max_lifespan";
	publicVariable "bdetect_debug_enable";
	};

// Trigger debug color changes on client
if ( tpwcas_multi_player && !(IsDedicated) && (tpwcas_debug == 1) ) then 
	{
	suppressDebug_compiled = call compile format["%1", tpwcas_fnc_client_debug];
	["suppressDebug", {[(_this select 0), (_this select 1) , (_this select 2)] call suppressDebug_compiled; }] call CBA_fnc_addEventHandler;

	_msg = format["Multiplayer CBA 'suppressDebug' EH has started"];
	[ _msg, 10 ] call bdetect_fnc_debug;
	};

// Run main suppression function	
[] spawn tpwcas_fnc_main_loop;

// Enable visual markers and debug logging
if (tpwcas_debug > 0) then 
	{
	[] spawn tpwcas_fnc_debug; 
	};