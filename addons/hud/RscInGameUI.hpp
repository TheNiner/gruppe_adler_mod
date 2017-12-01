class RscPictureKeepAspect;
class RscInGameUI {
    class RscStanceInfo {
        controls[] = {
            "StanceIndicatorBackground",
            "StanceIndicator",
            "CombatPaceIndicator"
		};
        class StanceIndicatorBackground;
        class StanceIndicator;
        class CombatPaceIndicator: RscPictureKeepAspect {
            idc=6510;
            text="\x\grad\addons\hud\combatpace.paa";
            x="(profilenamespace getvariable [""IGUI_GRID_STANCE_X"",((safezoneX + safezoneW) - (3.7 * (((safezoneW / safezoneH) min 1.2) / 40)) - 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))])";
            y="(profilenamespace getvariable [""IGUI_GRID_STANCE_Y"",(safezoneY + 0.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))]) + ((3.7 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)) *0.75)";
            w="((3.7 *(((safezoneW / safezoneH) min 1.2) / 40)))   / 4";
            h="((3.7 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)))    / 4";
        };
    };
};
