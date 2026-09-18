# Group Buff Toggle

A tiny quality-of-life addon for **World of Warcraft 1.12** that lets you
keep party and target buffs visible without covering the unit frames. No
dependencies, no configuration window, and no fuss.

## Features

- Adds a familiar Blizzard-style **Buffs** checkbox below the party frames.
- Adds a separate **Buffs** checkbox beside the target frame.
- Shows up to 16 buffs per unit in two tidy rows beside the frames.
- Keeps party and target settings independent and remembers both between sessions.
- Shows the normal game tooltip when you hover over a buff.
- Stays lightweight: it uses the built-in unit-aura API and stores only two settings.

Both displays start disabled, so the addon never changes your UI until you tick
the checkbox you want.

## Installation

1. Download the repository as a ZIP.
2. Extract the `GroupBuffToggle` folder into your World of Warcraft
   `Interface\AddOns` directory.
3. Restart the game or type `/reload`.
4. Make sure **Group Buff Toggle** is enabled on the character-select AddOns screen.

The final path should look like:

```text
World of Warcraft\Interface\AddOns\GroupBuffToggle\GroupBuffToggle.toc
```

## Upgrade from a previous add-on name

If you used this add-on under a previous folder name, migrate your saved data
before playing with the new installation. A normal file replacement is not
enough when the folder and saved-variable names change.

1. Fully close the game. Keep the previous add-on installed for this step.
2. Install the new `GroupBuffToggle` folder beside the previous folder.
3. Open PowerShell in `GroupBuffToggle` and run the following, replacing both example values:

   ```powershell
   .\Upgrade-SavedData.ps1 -ClientPath "C:\Games\World of Warcraft" -PreviousAddonName "PreviousAddonFolder"
   ```

The helper reads the previous TOC, copies account-wide and per-character saved
data to the new names, and saves backups under `AddonUpgradeBackups` in the
game folder. It keeps the original files intact and refuses to overwrite
existing saved data for the new add-on. It does not execute saved Lua code.

4. Disable the previous add-on and enable **GroupBuffToggle** before entering the world.
5. Check your settings and saved data. Keep the backups until you have verified them.

Further updates using the same add-on name keep your saved data normally.
On other operating systems, back up the files, then copy the previous add-on's
`.lua` file in each `WTF/Account/**/SavedVariables` directory to `GroupBuffToggle.lua`.
Change only the top-level variable name declared in the old TOC to the matching
name in the new TOC; leave its table contents unchanged. Do this with the game closed.

## Usage

- Tick **Buffs** below your party to toggle party-member buffs.
- Tick **Buffs** beside your target frame to toggle target buffs.
- Use slash commands to control every display independently:

```text
/groupbuffs group on|off|toggle
/groupbuffs groupbox on|off|toggle
/groupbuffs target on|off|toggle
/groupbuffs targetbox on|off|toggle
```

Run `/groupbuffs` without arguments to see command help and the current status
of all four switches. Hiding a checkbox does not disable its buffs; the buff
display remains independently controllable through its slash command.

Your choices are saved account-wide.

## Compatibility

Built specifically for the Vanilla 1.12 interface (`11200`) and the
default party and target frames. Other unit-frame replacement addons may use
different frame anchors and are not currently supported.

## License

Shared freely for players and friends to use, modify, and enjoy under the MIT License.
