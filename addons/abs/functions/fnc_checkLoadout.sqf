params ["_unit", "_level"];

private _loadout = getUnitLoadout _unit;
private _items = [];
{
   private _itemsInLoadout = _loadout select _x;
   if !(_itemsInLoadout isEqualTo [] && {!((_itemsInLoadout select 1) isEqualTo [])}) then {
      _items append (_itemsInLoadout select 1);
   };
}forEach [3,4,5];

if (_items isEqualTo []) exitWith { false };
private _bandages = [];
{
   private _item = _x;
   {
      if (_item in _x) then {
         _bandages pushback _x;
      };
   }forEach ([["ACE_fieldDressing"], ["ACE_packingBandage", "ACE_elasticBandage", "ACE_quikclot"]] select (_level == 0));
} forEach _items;

if (count _bandages <= GVAR(amountOfBandagesForABS)) exitWith { false };

GVAR(bandagesOnUnit) = _bandages;

true;
