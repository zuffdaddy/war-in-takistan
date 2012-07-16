/*
MAIN LOOP
Every 1.5 sec:
- Assigns initial variables to each unit if they are not yet assigned
- Checks suppression state of unit and applies appropriate stance and skill changes
*/

tpwcas_fnc_main_loop = 
	{
	private ["_stanceregain","_skillregain","_unit","_x"];	
	
	if( bdetect_debug_enable ) then 
		{
        _msg = format["Started 'tpwcas_fnc_main_loop'"];
        [ _msg, 8 ] call bdetect_fnc_debug;
		};
	
	while {true} do    
		{
		tpwcas_supvisflag = 0;   
			{
			if (local _x && (vehicle _x == _x) && (lifestate _x == "ALIVE") && (side _x != civilian)) then {
			_unit  = _x;  
			_stance = _unit getvariable ["tpwcas_stance", -1];
			_stanceregain = _unit getvariable ["tpwcas_stanceregain", -1];
			_skillregain = _unit getvariable ["tpwcas_skillregain", -1]; 
			if (tpwcas_canflee == 0) then 
				{
				_unit allowfleeing 0;
				};
					  
			//SET INITIAL PARAMETERS FOR EACH UNIT   
			if (_stanceregain == -1 ) then        
				{ 
				//SET ASR AI SKILLS IF ASR AI IS RUNNNING
				if (!isNil "asr_ai_sys_aiskill_fnc_SetUnitSkill") then 
					{
					[_unit] call asr_ai_sys_aiskill_fnc_SetUnitSkill;
					};	
					
				//TEXT BASED DEBUGGING ON SP					
				if ((!(isDedicated) && isServer ) && (tpwcas_textdebug > 0)) then  
					{
					[_unit,tpwcas_textdebug] spawn tpwcas_fnc_textdebug;
					};	
					
				_unit setvariable ["tpwcas_originalaccuracy", _unit skill "aimingaccuracy"];      
				_unit setvariable ["tpwcas_originalshake",  _unit skill "aimingshake"];     
				_unit setvariable ["tpwcas_originalcourage", _unit skill "courage"];      
				_unit setvariable ["tpwcas_general", _unit skill "general"];     
				_unit setvariable ["tpwcas_stanceregain", time];      
				_unit setvariable ["tpwcas_skillregain", time]; 
				_unit setvariable ["tpwcas_stance", "auto"];
				};    
			 
			//IF UNIT STANCE IS UNSUPPRESSED   
			if ( time >= _stanceregain) then        
				{ 
				                    
				_unit setvariable ["tpwcas_supstate",0];  
				_unit setvariable ["tpwcas_bulletcount",0];     
				_unit setvariable ["tpwcas_enemybulletcount",0]; 
				_unit setvariable ["tpwcas_stanceregain", time + 10]; 
				if (_stance in ["middle","down"]) then 
					{
					_unit setunitpos "auto"; 
					_unit setvariable ["tpwcas_stance", "auto"];
					};
				};   
					 
			//IF UNIT SKILLS ARE UNSUPPRESSED   
			if (time >= _skillregain) then       
				{
				[_unit] call tpwcas_fnc_incskill;				
				};  
			
			//UNIT CHANGES FOR DIFFERENT SUPPRESSION 
			switch ( _unit getvariable "tpwcas_supstate" ) do  
				{  
				case 1: //IF ANY BULLETS NEAR UNIT  
					{  
					//CROUCH IF NOT PRONE 
					if ((_unit call CBA_fnc_getunitanim) select 0 != "prone" && animationState _unit != "ACE_AmovPpneMstpSrasWrflDnon_Supported") then  
						{ 
						_unit setunitpos "middle"; 
						_unit setvariable ["tpwcas_stance", "middle"];		
						}; 
					};  
				  
				case 2: //IF ENEMY BULLETS NEAR UNIT  
					{ 
					//CROUCH IF NOT PRONE 
					if ((_unit call CBA_fnc_getunitanim) select 0 != "prone" && animationState _unit != "ACE_AmovPpneMstpSrasWrflDnon_Supported") then  
						{ 
						_unit setunitpos "middle"; 
						_unit setvariable ["tpwcas_stance", "middle"];						
						}; 
					//SKILL MODIFICATION 
					if (tpwcas_skillsup == 1) then 
						{ 
						[_unit] call tpwcas_fnc_decskill;
						};     
					//PLAYER CAMERA SHAKE  
					if ((isplayer unit) && (tpwcas_playershake == 1)) then    
						{    
						addCamShake [1.5 - (skill player),(random 4)-((_unit getvariable "tpwcas_general")+(_unit getvariable "tpwcas_originalcourage")) , 2.5]   
						};     
					};  
				  
				case 3: //IF UNIT IS SUPPRESSED BY MULTIPLE ENEMY BULLETS   
					{ 
					//GO PRONE 
					_unit setunitpos "down"; 
					_unit setvariable ["tpwcas_stance", "down"];					
					_unit forcespeed -1;  
					//SKILL MODIFICATION 
					if (tpwcas_skillsup == 1) then 
						{ 
						[_unit] call tpwcas_fnc_decskill;
						};
					//PLAYER CAMERA SHAKE AND FX 
					if (isplayer _unit) then     
						{   
						if (tpwcas_playershake == 1) then  
							{ 
							addCamShake [2 - (skill _unit),(random 6)-((_unit getvariable "tpwcas_general")+(_unit getvariable "tpwcas_originalcourage")) , 5]   
							}; 
						if (tpwcas_playervis == 1) then  
							{     
							[] spawn tpwcas_fnc_visuals;   
							}; 
						};   
					}; 
				};
				};
			} foreach allunits; 
		sleep 1.5;      
		};   
	};  
