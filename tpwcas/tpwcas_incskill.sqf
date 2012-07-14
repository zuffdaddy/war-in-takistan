/*
INCREASE UNIT SKILLS
- called from main loop
- aiming shake, aiming accuracy and courage increase by 5%
*/

tpwcas_fnc_incskill = 
	{
	private ["_unit","_originalaccuracy","_originalshake","_originalcourage","_currentaccuracy","_currentshake","_currentcourage","_newaccuracy","_newshake","_newcourage","_inc"];
	
	_unit = _this select 0;
	_originalaccuracy = _unit getvariable "tpwcas_originalaccuracy";        
	_originalshake = _unit getvariable "tpwcas_originalshake";      
	_originalcourage = _unit getvariable "tpwcas_originalcourage"; 
	
	_currentaccuracy = _unit skill "aimingaccuracy"; 
	_currentshake = _unit skill "aimingshake"; 
	_currentcourage = _unit skill "courage"; 
	
	_inc = 0.05; //5% increment
		
	if (_currentaccuracy < _originalaccuracy) then 
		{
		//INCREMENT SKILLS
		_newaccuracy = _currentaccuracy + (_originalaccuracy * _inc);
		_newshake = _currentshake + (_originalshake * _inc); 
		_newcourage = _currentcourage + (_originalcourage * _inc); 	
		
		_unit setskill ["aimingaccuracy",_newaccuracy];         
		_unit setskill ["aimingshake",_newshake];        
		_unit setskill ["courage",_newcourage];  
		}
		else
		{
		//RESET SKILLS
		_unit setskill ["aimingaccuracy",_originalaccuracy];         
		_unit setskill ["aimingshake",_originalshake];        
		_unit setskill ["courage",_originalcourage];  
		_unit setvariable ["tpwcas_skillregain", time + 10];
		};
	};