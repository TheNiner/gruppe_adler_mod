#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

[
   QGVAR(allowABS),
   "SCALAR",
   [
      localize LSTRING(settingAllowABS_displayName),
      localize LSTRING(settingAllowABS_tooltip)
   ], 
   localize LSTRING(settingCategory),
   [
      "Disabled",
      "Medics only",
      "Everyone"
   ]
] call CBA_Settings_fnc_init;
