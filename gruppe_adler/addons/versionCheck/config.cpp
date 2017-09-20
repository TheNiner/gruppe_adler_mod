class CfgPatches {
	class grad_versionCheck {

		name = "GRAD versionCheck";
		author = "McDiod";

		requiredVersion = 1.0;
		requiredAddons[] = {"grad_main","ace_common"};

		units[] = {};
		weapons[] = {};
	};
};

#include "script_component.hpp"
#include "cfgEventHandlers.hpp"
#include "cfgFunctions.hpp"