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

#define PLAYER_INITIALIZED   (1<<0)
#define PLAYER_MESSAGES      (1<<1)
#define PLAYER_PROGRESS_BAR  (1<<2)
#define PLAYER_SOUND         (1<<3)
#define DEF_SPRINT_COOKIE    PLAYER_MESSAGES|PLAYER_SOUND

new Handle:h_SPRINT_COOKIE = INVALID_HANDLE;
new iP_SETTINGS[MAXPLAYERS+1];

RegSprintCookie()
{
  h_SPRINT_COOKIE = RegClientCookie("shortsprint",
  "ShortSprint settings", CookieAccess_Private);
  return;
}

ReadClientCookie(client)
{
  if(!IsFakeClient(client) && !(iP_SETTINGS[client] & PLAYER_INITIALIZED))
  {
    decl String:sCookie_val[16];

    GetClientCookie(client, h_SPRINT_COOKIE, sCookie_val, sizeof(sCookie_val));
    iP_SETTINGS[client] = StringToInt(sCookie_val) | PLAYER_INITIALIZED;

    if(iP_SETTINGS[client] < 2)
    {
      iP_SETTINGS[client] = DEF_SPRINT_COOKIE;
    }
  }
  return;
}

ReadEveryClientCookie()
{
  for(new iClient = 1; iClient <= MaxClients; iClient++)
  {
    if(IsClientConnected(iClient) && AreClientCookiesCached(iClient))
    {
      ReadClientCookie(iClient);
    }
  }
  return;
}

WriteClientCookie(client)
{
  if(!IsFakeClient(client) && (iP_SETTINGS[client] & PLAYER_INITIALIZED))
  {
    decl String:sCookie_val[16];
    IntToString(iP_SETTINGS[client], sCookie_val, sizeof(sCookie_val));

    SetClientCookie(client, h_SPRINT_COOKIE, sCookie_val);
  }
  return;
}

WriteEveryClientCookie()
{
  for(new iClient = 1; iClient <= MaxClients; iClient++)
  {
    if(IsClientConnected(iClient))
    {
      WriteClientCookie(iClient);
    }
  }
  return;
}