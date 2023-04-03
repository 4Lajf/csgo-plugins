#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>

public Plugin myinfo =
{
    name = "Extend Round Upon Kill",
    author = "4Lajf",
    description = "Adds one minute to the round time on Counter-Terrorist kill.",
    version = "1.0",
    url = "https://www.example.com"
};

public void OnPluginStart()
{
    HookEvent("player_death", Event_PlayerDeath);
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
    int killer = GetClientOfUserId(GetEventInt(event, "attacker"));
    int victim = GetClientOfUserId(GetEventInt(event, "userid"));

    if (killer == 0 || victim == 0)
    {
        return Plugin_Continue;
    }

    if (GetClientTeam(victim) == CS_TEAM_T)
    {
        AddRoundTime(60);
    }

    return Plugin_Continue;
}

public void AddRoundTime(int extraTime)
{
    int timeLeft = GameRules_GetProp("m_iRoundTime");
    GameRules_SetProp("m_iRoundTime", timeLeft + 60, 4, 0, true);
}

public int GetGameRulesProxy()
{
    int maxClients = MaxClients;
    for (int i = maxClients + 1; i <= maxClients + 65; i++)
    {
        char classname[64];
        GetEntityClassname(i, classname, sizeof(classname));

        if (strcmp(classname, "CCSGameRulesProxy") == 0)
        {
            return i;
        }
    }
    return -1;
}

