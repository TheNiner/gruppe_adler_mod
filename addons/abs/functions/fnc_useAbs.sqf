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
