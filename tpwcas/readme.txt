TPWC AI Suppress (TPWCAS)
Singleplayer, Multiplayer and Dedicated Server Compatible AI Suppression System
By TPW && -Coulum- && fabrizio_T && Ollem
v3.01 20120717

Introduction:
-------------
One of the things sorely missing from Arma2 is reaction to passing bullets. An AI unit will often stand quite happily whilst bullets whiz by. This makes effective suppression of AI enemies difficult - you basically always have to aim to kill them since you can't make them keep their heads down by shooting nearby.

This addon aims to address this problem by making AI units react to passing projectiles. If a bullet snaps by within 10m of an AI unit, it will crouch/kneel (depending on movement), and if more than 10 bullets pass by a unit in 5 seconds, the unit will drop/crawl. After 10 seconds without bullets, the unit will return to its previous stance. 

Additionally, suppressive fire can alter the aiming shake, accuracy and courage of the suppressed unit. The more fire directed near a unit, the lower its skills will become. Nearby casualties will further decrease a unit's courage. After 5 or so seconds without bullets, the skills will gradually return to normal. Player units will optionally experience some visual effects if suppressed (camera shake, vision blur and darkening).

Currently there is no "suppressed" eventhandler in the game engine, so TPWCAS aims to mimic one by constantly monitoring whether any active bullet/shell projectile objects have units within a 10m radius. This allows TPWCAS to work for any opfor, blufor or independent on the map, whether editor-placed or spawned.

TPWCAS significantly changes gameplay, allowing for longer engagements and more thought required to survive them.

IMPORTANT NOTE:
TPWCAS is not an all-in-one AI behaviour modification mode. Its primary purpose at this time is to cause units to duck/drop and lose some shooting competence under suppressive fire. It's designed to play well with mods which DO alter AI behaviours under combat stress, and you are encouraged to use these if you require additional realism such as moving to cover.

VERY IMPORTANT NOTE:
TPWCAS started life as an SP only mod, but a large amount of effort has gone into modifying the bullet detection, suppression and visual debugging framework to work for MP and dedicated server. While every effort has gone into testing in SP, MP and dedi, we simply cannot vouch for perfect operation under all circumstances. 


Installation:
-------------
TPWCAS comes as a script version and an addon version.
CBA (community base addons) is required for both versions.

Script version: 
Save tpwcas and all the scripts in it to your mission directory.
Call it with: null = [] execvm "tpwcas\tpwcas.sqf", in your init.sqf or in the init of any object on the map.

Addon version:
Unpack the addon version and call it by your favourite method. For more info on running mods please check out http://www.armaholic.com/plug.php?e=faq&q=18
If you want to be able to configure it, then copy the configuration file to: your_arma_directory\userconfig\tpwc_ai_sup\tpwc_ai_sup.hpp


Features:
---------
TPWCAS enables stance and skill modification under fire.
 
* Units react to bullets passing within 10m.
* Units on foot or operating vehicle or static guns are affected. 
* Units driving are unaffected.
* Only uninjured units are affected.
* Bullets fired from less than 25m away are ignored.
* Bullets from small calibre pistols and SMG are ignored.
* Units react differently according to the side of the shooter.
* Friendly shooter: > 0 bullets --> kneel/crouch.
* Enemy shooter: 1 - 10 bullets --> kneel/crouch, > 10 bullets -->drop/crawl. 
* Units regain previous stance after 10 or so seconds without nearby bullets.
* Friendly shooter: no skill reduction.
* Enemy shooter: skills reduced according to number of bullets.
* Units gradually regain skills after 5 or so seconds without bullets.
* Shooter may be "revealed" to the suppressed unit.
* Units are more easily suppressed if there are nearby friendly casualties.
* Player experiences visual effects if suppressed.


Debugging:
----------
TPWCAS enables text and graphic debugging, and both are enabled by default for this beta release. If switched on, graphic debugging will show a coloured ball over any units. This may also come in handy for training. Markers are also shown on map. You may also switch on dDetect logging, but be warned this may lead to a lot of disk activity and a large RPT file.

* No ball - unsuppressed.
* Green ball - suppressed by friendly fire.
* Yellow ball - suppressed by sporadic enemy fire.
* Red ball - suppressed by heavy enemy fire.
* Black ball - unit is fleeing (fleeing does not mean the unit is running away, but will not be able to be suppressed).

If text debugging is switched on, then coloured floating text showing the number of enemy bullets will be displayed under each unit. 

* White text - unsuppressed.
* Green text - suppressed by friendly fire.
* Yellow text - suppressed by sporadic enemy fire.
* Red text - suppressed by heavy enemy fire.
* Black text - unit is fleeing (fleeing does not mean the unit is running away, but will not be able to be suppressed).

Text debugging is not as pretty, but potentially more informative, and eliminates problems that some people have reported where debug balls are registered as civilians, and lead to a decrease in performance. Text debugging is disabled on dedicated server.


Configuration:
--------------
TPWCAS is highly configurable. The script version has a number of well commented variables to change aspects of the system. The addon version allows the same variables to be changed in the tpwc_ai_sup.hpp config file.

Please note: The format of tpwc_ai_sup.hpp introduced with v3.00 is different than v1 and v2. Please replace your previous tpwc_ai_sup.hpp. 

General settings:
* Startup hint. 0 = no hint, 1 = hint. Default 1.
* Delay (sec) before suppression functions start. Default 1.
* Debugging. 0 = no debugging (default), 1 = display coloured balls over any suppressed units, 2 = balls + bDetect logging. 
* Text debug rate (Hz). 0 = no text debugging (default). 10 = text is refeshed 10 times per second. 100 = text is refreshed 100 times/sec - this will look very smooth but will use significant CPU if many units are on a map. 

Bullet settings:
* Bullet ignore radius (m). Bullets from a shooter closer than this will not suppress. Default 25.
* Maximum bullet distance (m). A bullet further than this from its shooter will not suppress. Set larger if you plan on doing a lot of sniping - but may impact performance. Default 800.
* Bullet lifetime (sec). bullets still alive this long after being shot are ignored. Default 1.
* Shot threshold. More shots than this will cause unit to drop/crawl. Default 10.
* Pistol and SMG ammo to ignore. Add custom ammo (eg suppressed) or change to taste.    

Suppression and skill settings:
* AI Skill suppression. 0 = no skill changes, only stance changes. 1 = skill and stance changes. Default 1.  
* Player suppression shake. 0 = no suppression, 1 = suppression. Default 1. 
* Player suppression visuals. 0 = no suppression, 1 = suppression. Default 1. 
* Minimum skill value, none of a units skills will drop below this under suppression. Default 0.05.
* Reveal value when suppressed. 0 = reveal disabled. 0.1 = suppressed unit knows essentially nothing about shooter. 4 = unit knows the shooter's side, position, shoe size etc. Default 1.25.
* Allow fleeing. 0 = units will not flee. 1 = units can flee. Set to 0 if you see too many units standing around unable to be suppressed.


Caveats:
--------
* The system uses setunitpos to change unit stance. The stance changes are subordinate to those issued by a player to a squad. A squad given "stand" orders will not duck when bullets start flying. Nor will a fleeing unit.  Nor will a unit ordered into cover. Nor may units taken over by various FSMs.
* TPWCAS is not bulletproof (pun intended), and may not operate perfectly under conditions of very heavy fire by multiple units or, if the framerate is too low.
* TPWCAS ignores rounds fired from pistols and low calibre SMGs, and subsonic ammunition. You won't be able to suppress the enemy by waving your pistol around. 
* TPWCAS implements changes to accuracy, courage etc under fire. The system should play nicely with ACE, ASR_AI, COSLX and other AI behaviour mods, but please report any clashes. 
* As far as the authors can tell, TPWCAS causes minimal drops to framerate even on low spec machines, with 50 or so AI taking pot shots at each other. Your mileage may vary depending on computer specs and number of AI. We take no responsibility if your computer explodes. 
* Debug balls are registered by the game engine as civilians (!), and may cause some unwarranted effects. Use text debugging if this occurs.
* TPWCAS is in its infancy and probably won't work the way everyone wants it to. We welcome any feedback and suggestions.


Thanks:
-------
* Variable, Jedra and 2nd Ranger for initial ideas and suggestions.
* Orcinus, Kremator and CameronMcDonald for valuable input, suggestions and encouragement.
* Froggluv and Pellejones for performance testing.
* Robalo for helping to make his incredible ASR_AI skills addon and TPWCAS work nicely together, and for additional code ideas and help. 
* Falcon_565 for demonstrating the power of cba_fnc_addPerFrameHandler.
* Foxhound for ongoing support of mod makers.
* BIS for an amazing piece of software which even allows scope for mods like this.


Changelog:
----------
* 1.00 20120623 
	- initial release

* 1.01 20120625 
	- Mode 3: Plays better with ASR AI skills. 
	- Units set to "combat" behaviour when suppressed. 
	- All modes: per frame speed optimisations.    

* 1.02 20120627 
	- Total rewrite and optimisation. 
	- Improved performance with more units. 
	- Fine tuning of skill and stance parameters under suppression. 
	- Player suppression effects (optional). 
	- Some MP optimisation (but still WIP). 
	- Units can be suppressed by vehicle fire.

* 1.04 20120630 
	- Further optimisation of bullet detection. 
	- Removed "combat mode" under suppression, since the engine and any AI mods will handle this more effectively. 
	- Significantly improved debug mode, debug balls disappear when injured/dead. 
	- Suppression not applied to injured units. 
	- Unsuppressed prone units will not crouch if fired at. 

===

* 2.00beta 20120702 
	- Total rewrite of the bullet detection code (bDetect) by fabrizio_T. 
	- Added filtering so that suppression calculations are only performed for uninjured combatants less than 1000m from the player. 
	- Removed stance-only suppression mode. 
	- bDetect 0.5.

* 2.01beta 20120703 
	- Added ability to configure stance only changes under suppression. 
	- Minor changes to accommodate changes to bdetect variables. 
	- bDetect 0.63.

* 2.02beta 20120703 
	- Minimum skill value under suppression is now configurable. 
	- Reveal amount is configurable. 
	- bDetect 0.64.

* 2.03beta 20120704 
	- Removed errors in debugging code which lead to FPS drops.
	- bDetect 0.65.

* 2.04beta 20120705 
	- Fixed config errors.
	- Fixed serious regressions with skills handling, which was leading to 0 skills, not recovering. 
	- Fixed debug errors causing debug balls to remain over dead units. 
	- Reveal function properly configurable. 
	- ASR AI skills properly recognised again.
	- Shooter reveal to suppressed units can be toggled. 
	- Removed some redundant checks now handled by bDetect.
	- Maximum bullet distance is now configurable.  
	- bDetect 0.66. 

* 2.05beta 20120706 
	- Code cleanup and optimisation.
	- Private variable declarations for each function.
	- Simplified skills modification, will not head to 0 as quickly.
	- Units are more easily suppressed if there are friendly casualties within 20m.
	- Simplified ASR AI skill recognition.
	- bDetect startup hint will not be shown if TPWCAS startup hint is not shown.
	- bDetect 0.67 (modified to allow units to suppress when shooting uphill).

* 2.06beta 20120708
	- Added ability to configure whether units will flee when morale/courage drops too low.
	- Improved visual debugging code
	- Code has been modularised, each function is compiled from its own sqf.
	- Courage does not drop so rapidly under fire (should lead to less premature fleeing).
	- bDetect 0.67.

* 2.07beta 20120710
	- Added floating text based debugging.
	- bDetect start hint now correctly not displayed if TPWCAS hint is not displayed.
	- Courage is only decreased if there are nearby friendly casualties.
	- bDetect 0.67.	
	
===

* 3.00beta 20120714
	- Bullet detect, supression and debugging framework now works in SP, MP and Dedicated (Ollem and Fabrizio).
	- Significant code overhaul (!) and cleanup.
	- Text debugging scales with distance.
	- bDetect 0.72 (SP/MP/Dedi).

* 3.01beta 20120716
	- Additional pistol and subsonic magazines added
	- Fixed colour error with debugging map markers.
	- MP and dedicated server debug ball colour handling improved.
	- Units with stances set to crouch/prone by other AI mods will not be forced to "auto"" position when unsuppressed.
	- Fixed already prone units crouching under suppression, when using ACE (thanks Robalo).
	- Reveal shooter is disabled if using ASR_AI.
	- Highly skilled units will suffer lower courage reduction under fire.
	- bDetect logging off by default, may be toggled on. 
	- bDetect 0.72


* 3.01 20120717
	- Fixed debugging locality issue