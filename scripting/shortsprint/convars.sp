/*
 * SourceMod ShortSprint Plugin
 * Copyright (C) 2009-2013 Martin Walter
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Thanks to:
 * - Shaman (Alican Çubukçuoglu), who released a sprint plugin for SourceMod in
 *   2007 called "Sprint: Source".
 * - blade81, who used a unreleased plugin with progress bar and sprint sound on
 *   the Gamerz Paradise CS:S soccer servers in 2009.
 * - SWAT_88, who released the SM Parachute plugin with added +use button support
 *   in 2008.
 * - Forlix (Dominik Friedrichs), who helped me a lot with scripting.
 */

//Convar defaults
#define DEF_ANNOUNCEMENT_TYPE  "1"
#define DEF_BUTTON             "1"
#define DEF_CHATTRIGGER        "!"
#define DEF_COOLDOWN           "10"
#define DEF_SPRINT_ENABLED     "1"
#define DEF_SPEED              "1.25"
#define DEF_TIME               "3"

static Handle:h_ANNOUNCEMENT = INVALID_HANDLE;
static Handle:h_BUTTON = INVALID_HANDLE;
static Handle:h_CHATTRIGGER = INVALID_HANDLE;
static Handle:h_COOLDOWN = INVALID_HANDLE;
static Handle:h_SPRINT_ENABLED = INVALID_HANDLE;
static Handle:h_SPEED = INVALID_HANDLE;
static Handle:h_TIME = INVALID_HANDLE;

new bool:bANNOUNCEMENT;
new bool:bSPRINT_BUTTON;
new String:sCHAT_TRIGGER[16];
new Float:fSPRINT_COOLDOWN = 0.0;
new bool:bSPRINT_ENABLED;
new Float:fSPRINT_SPEED = 0.0;
new Float:fSPRINT_TIME = 0.0;

SetupConVars()
{
  new Handle:shortsprint_version = CreateConVar(PLUGIN_VERSION_CVAR,
  PLUGIN_VERSION, "ShortSprint Version",
  FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_NOTIFY|FCVAR_PRINTABLEONLY);

  SetConVarString(shortsprint_version, PLUGIN_VERSION, false, false);

  h_ANNOUNCEMENT= CreateConVar("sm_shortsprint_announcement_type", DEF_ANNOUNCEMENT_TYPE,
  "How often the plugin may announce itself to players: Every round-start (0), Once after connect (1)",
  0, true, 0.0, true, 1.0);

  h_BUTTON = CreateConVar("sm_shortsprint_button", DEF_BUTTON,
  "Enable/Disable +use button support", 0, true, 0.0, true, 1.0);

  h_CHATTRIGGER= CreateConVar("sm_shortsprint_chat_trigger", DEF_CHATTRIGGER,
  "Set this to one of the ChatTrigger strings configured in SourceMod's core.cfg");

  h_COOLDOWN= CreateConVar("sm_shortsprint_cooldown", DEF_COOLDOWN,
  "Time in seconds the player must wait for the next sprint", 0, true, 1.0, true, 15.0);

  h_SPRINT_ENABLED= CreateConVar("sm_shortsprint_enable", DEF_SPRINT_ENABLED,
  "Enable/Disable ShortSprint", 0, true, 0.0, true, 1.0);

  h_SPEED= CreateConVar("sm_shortsprint_speed", DEF_SPEED,
  "Ratio for how fast the player will sprint", 0, true, 1.01, true, 5.00);

  h_TIME= CreateConVar("sm_shortsprint_time", DEF_TIME, "Time in seconds the player will sprint",
  0, true, 1.0, true, 30.0);

  HookConVarChange(h_ANNOUNCEMENT, AnnouncementConVarChanged);
  HookConVarChange(h_BUTTON, ButtonConVarChanged);
  HookConVarChange(h_CHATTRIGGER, ChatTriggerConVarChanged);
  HookConVarChange(h_COOLDOWN, CooldownConVarChanged);
  HookConVarChange(h_SPRINT_ENABLED, EnabledConVarChanged);
  HookConVarChange(h_SPEED, SpeedConVarChanged);
  HookConVarChange(h_TIME, TimeConVarChanged);

  //Manually trigger convar readout
  AnnouncementConVarChanged(INVALID_HANDLE, "0", "0");
  ChatTriggerConVarChanged(INVALID_HANDLE, "0", "0");
  CooldownConVarChanged(INVALID_HANDLE, "0", "0");
  EnabledConVarChanged(INVALID_HANDLE, "0", "0");
  SpeedConVarChanged(INVALID_HANDLE, "0", "0");
  TimeConVarChanged(INVALID_HANDLE, "0", "0");

  return;
}

public AnnouncementConVarChanged(Handle:convar, const String:oldValue[],
                                 const String:newValue[])
{
  bANNOUNCEMENT = GetConVarBool(h_ANNOUNCEMENT);
  return;
}
public ButtonConVarChanged(Handle:convar, const String:oldValue[],
                           const String:newValue[])
{
  bSPRINT_BUTTON = GetConVarBool(h_BUTTON);
  return;
}
public ChatTriggerConVarChanged(Handle:convar, const String:oldValue[],
                                const String:newValue[])
{
  GetConVarString(h_CHATTRIGGER, sCHAT_TRIGGER, sizeof(sCHAT_TRIGGER));
  return;
}
public CooldownConVarChanged(Handle:convar, const String:oldValue[],
                             const String:newValue[])
{
  fSPRINT_COOLDOWN = GetConVarFloat(h_COOLDOWN);
  return;
}
public EnabledConVarChanged(Handle:convar, const String:oldValue[],
                            const String:newValue[])
{
  bSPRINT_ENABLED = GetConVarBool(h_SPRINT_ENABLED);

  if(!bSPRINT_ENABLED)
  {
    bSPRINT_BUTTON=false;
    return;
  }

  ButtonConVarChanged(INVALID_HANDLE, "0", "0");

  return;
}
public SpeedConVarChanged(Handle:convar, const String:oldValue[],
                          const String:newValue[])
{
  fSPRINT_SPEED = GetConVarFloat(h_SPEED);
  return;
}
public TimeConVarChanged(Handle:convar, const String:oldValue[],
                         const String:newValue[])
{
  fSPRINT_TIME = GetConVarFloat(h_TIME);
  return;
}