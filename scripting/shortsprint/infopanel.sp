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

#define PANEL_DISPLAYTIME  50

public Action:Command_InfoPanel(client, args)
{
  if(!client)
  {
    return(Plugin_Continue);
  }

  if(!bSPRINT_ENABLED)
  {
    return(Plugin_Handled);
  }

  decl String:sBuf[256];
  decl String:sBuf2[64];
  new Handle:h_Infopanel = CreatePanel();
  new panel_keys = 0;

  SetGlobalTransTarget(client);

  Format(sBuf, sizeof(sBuf), "ShortSprint v%s\n ", PLUGIN_VERSION);
  DrawPanelText(h_Infopanel, sBuf);

  Format(sBuf2, sizeof(sBuf2), "%s%s", sCHAT_TRIGGER, SPRINT_COMMAND);

  if(bSPRINT_BUTTON)
  {
    Format(sBuf, sizeof(sBuf), "%t\n ", "INFOPANEL_TEXT_BUTTON");
    DrawPanelText(h_Infopanel, sBuf);
  }
  else
  {
    Format(sBuf, sizeof(sBuf), "%t\n ", "INFOPANEL_TEXT_NOBUTTON", sBuf2);
    DrawPanelText(h_Infopanel, sBuf);
  }

  //Client settings
  Format(sBuf, sizeof(sBuf), "%t:", "INFOPANEL_TEXT_SETTINGS");
  DrawPanelText(h_Infopanel, sBuf);

  new cStatus = '-';
  static String:sItem_display[3][27] = {"INFOPANEL_TEXT_MESSAGES",
  "INFOPANEL_TEXT_PROGRESSBAR", "INFOPANEL_TEXT_SOUND"};

  for(new i = 1; i <= 3; i++)
  {
    cStatus = '-';
    if(iP_SETTINGS[client] & (1<<i))
    {
      cStatus = '+';
    }

    panel_keys |= (1<<i-1);
    Format(sBuf, sizeof(sBuf), "->%i. [%c] %t", i, cStatus, sItem_display[(i-1)]);
    DrawPanelText(h_Infopanel, sBuf);
  }
  //

  DrawPanelText(h_Infopanel, " ");

  Format(sBuf, sizeof(sBuf), "%t\n ", "INFOPANEL_TEXT_BIND", sBuf2);
  DrawPanelText(h_Infopanel, sBuf);

  DrawPanelText(h_Infopanel,
  "(c) 2009-2013 walmar\n - walmar.postbox@gmail.com\n - http://github.com/walmar\n ");

  panel_keys |= (1<<10-1);
  Format(sBuf, sizeof(sBuf), "0. %t", "INFOPANEL_EXIT");
  DrawPanelText(h_Infopanel, sBuf);

  SetPanelKeys(h_Infopanel, panel_keys);

  SendPanelToClient(h_Infopanel, client, InfoPanelReturn, PANEL_DISPLAYTIME);
  CloseHandle(h_Infopanel);

  return(Plugin_Handled);
}

public InfoPanelReturn(Handle:panel, MenuAction:action, client, key)
{
  if(action == MenuAction_Select && key >= 1 && key <= 3)
  {
    new iP_setting = key;

    if((iP_SETTINGS[client] ^ (1<<iP_setting)) > PLAYER_INITIALIZED)
    {
      iP_SETTINGS[client] ^= (1<<iP_setting);
      iP_SETTINGS[client] |= PLAYER_INITIALIZED;
    }
    else
    {
      PrintHintText(client, "%t", "HINT_TEXT_MISENTRY");
    }

    Command_InfoPanel(client, 0);
  }
  return;
}