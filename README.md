### ShortSprint Plugin for SourceMod

#### Feature list
* Players are able to sprint for a short time by pressing the +use button or sending the sprint command.
* The plugin announce itself to players in chat once after connect or every round-start.
* Typing the shortsprint command in chat displays the ShortSprint menu with settings and help for players.
* Every player can enable/disable individually the sprint chat messages, the sprint sound and the cool down time progress bar. The settings will be stored in sourcemod/data/sqlite/clientprefs-sqlite.sq3 on the server.
* Multilanguage support: English and German phrase-files are already included.

#### Installation instructions
* Download the plugin and the translation files.
* Copy the files to the correct folders of [SourceMod](http://www.sourcemod.net "SourceMod: Half-Life 2 Scripting").

#### Configuration ConVars
* sm_shortsprint_enable (default 1)
    * Enable/Disable ShortSprint
* sm_shortsprint_button (default 1)
    * Enable/Disable +use button support
* sm_shortsprint_announcement_type (default 1)
    * How often the plugin may announce itself to players: Every round-start (0), Once after connect (1)
* sm_shortsprint_speed (default 1.25)
    * Ratio for how fast the player will sprint
* sm_shortsprint_time (default 3)
    * Time in seconds the player will sprint
* sm_shortsprint_cooldown (default 10)
    * Time in seconds the player must wait for the next sprint
* sm_shortsprint_chat_trigger (default "!")
    * Set this to one of the ChatTrigger strings configured in SourceMod's core.cfg
* sm_shortsprint_version
    * Version tracking (don't modify this)

#### Changelog
* 1.20 (2013-05-28)
    * Initial release.

#### Thanks to
* [Shaman](http://forums.alliedmods.net/member.php?u=23292 "AlliedModders - View Profile: Shaman"), who released a sprint plugin for SourceMod in 2007 called Sprint: Source.
* [blade81](http://forums.alliedmods.net/member.php?u=15144 "AlliedModders - View Profile: blade81"), who used a unreleased plugin with progress bar and sprint sound on the Gamerz Paradise CS:S soccer servers in 2009.
* [SWAT_88](http://forums.alliedmods.net/member.php?u=34532 "AlliedModders - View Profile: SWAT_88"), who released the SM Parachute plugin with added +use button support in 2008.
* [Forlix](http://forums.alliedmods.net/member.php?u=45536 "AlliedModders - View Profile: Forlix"), who helped me a lot with scripting.

The development of this SourceMod plugin already began in 2009. It was improved over the years while being in use on just a few CS:S Public Soccer Servers.
