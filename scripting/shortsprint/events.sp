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

public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
  if(bSPRINT_ENABLED && !bANNOUNCEMENT)
  {
    PrintAnnouncementMsg(0);
  }
  return;
}

public Event_PlayerSpawn(Handle:event,const String:name[],bool:dontBroadcast)
{
  new iClient = GetClientOfUserId(GetEventInt(event, "userid"));

  ResetSprint(iClient);

  PrintSprintCDMsgToClient(iClient);
  
  iCLIENT_STATUS[iClient] &= ~ CLIENT_SPRINTUNABLE;

  if((iCLIENT_STATUS[iClient] & CLIENT_ANNOUNCEMENT) && GetClientTeam(iClient))
  {
    PrintAnnouncementMsg(iClient);

    iCLIENT_STATUS[iClient] &= ~ CLIENT_ANNOUNCEMENT;
  }

  return;
}

public Event_PlayerDeath(Handle:event,const String:name[],bool:dontBroadcast)
{
  new iClient = GetClientOfUserId(GetEventInt(event, "userid"));

  ResetSprint(iClient);

  return;
}