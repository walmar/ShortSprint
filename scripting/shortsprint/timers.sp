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

public Action:Timer_SprintEnd(Handle:timer, any:client)
{
  h_SPRINT_TIMERS[client] = INVALID_HANDLE;

  if(IsClientInGame(client) && (iCLIENT_STATUS[client] & CLIENT_SPRINTUSING))
  {
    iCLIENT_STATUS[client] &= ~ CLIENT_SPRINTUSING;

    //Reset sprint speed
    SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);

    if(IsPlayerAlive(client) && GetClientTeam(client) > 1)
    {
      //Outputs
      PrintSprintEndMsgToClient(client);

      if(iP_SETTINGS[client] & PLAYER_PROGRESS_BAR)
      {
        SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime",
        GetGameTime());
    
        SetEntProp(client, Prop_Send, "m_iProgressBarDuration",
        RoundFloat(fSPRINT_COOLDOWN));
      }
      //----

      h_SPRINT_TIMERS[client] = CreateTimer(fSPRINT_COOLDOWN,
      Timer_SprintCooldown, client);
    }
  }

  return;
}

public Action:Timer_SprintCooldown(Handle:timer, any:client)
{
  h_SPRINT_TIMERS[client] = INVALID_HANDLE;

  if(IsClientInGame(client) && (iCLIENT_STATUS[client] & CLIENT_SPRINTUNABLE))
  {
    iCLIENT_STATUS[client] &= ~ CLIENT_SPRINTUNABLE;

    if(IsPlayerAlive(client) && GetClientTeam(client) > 1)
    {
      //Outputs
      PrintSprintCDMsgToClient(client);

      SendProgressBarResetToClient(client);
      //----
    }
  }

  return;
}