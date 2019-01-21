#include "script_component.hpp"
/*
 * Author: Salbei
 * Applys ABS, reduzing the wound count below set Value.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Caller <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [TARGET, CALLER] call grad_mod_fnc_useAbs
 *
 * Public: Yes
 */
params ["_target", "_caller", "_selection"];

private _openWounds = _target getVariable ["ace_medical_openWounds", []];
private _wounds = [];
private _notNeededWounds = [];

{
   _x params ["", "", "_bodyPart", "_numOpenWounds", "_bloodLoss"];

   if (_bodyPart == _selection) then {
      _wounds pushBack _x;
   } else {
      _notNeededWounds pushBack _x;
   };
}forEach _openWounds;

if (count _wounds <= 50) exitWith {};

_wounds resize GVAR(amountOfWoundsForABS);
_openWounds = (_wounds + _notNeededWounds) call BIS_fnc_arrayShuffle;
_target setVariable ["ace_medical_openWounds", _openWounds, true];

for "_i" from 1 to GVAR(amountOfBandagesForABS) do {
   private _kickOut = false;
   if (count (GVAR(bandagesOnUnit) select 1) > 0) then {
      GVAR(bandagesOnUnit) set [0, ((GVAR(bandagesOnUnit) select 0) deleteAt 0)];
   }else{
      if (count (GVAR(bandagesOnUnit) select 2) > 0) then {
         GVAR(bandagesOnUnit) set [1, ((GVAR(bandagesOnUnit) select 1) deleteAt 0)];
      }else{
         if (count (GVAR(bandagesOnUnit) select 2) > 0) then {
            GVAR(bandagesOnUnit) set [2, ((GVAR(bandagesOnUnit) select 2) deleteAt 0)];
         }else{
            _kickOut = true;
         };
      };
   };

   if (_kickOut) exitWith {diag_log format ["Not enough Bandages: %1 missing.", (GVAR(amountOfBandagesForABS) - _i)};
};
