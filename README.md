# Octo Group Buff Toggle

A tiny quality-of-life addon for **OctoWoW / Vanilla WoW 1.12** that lets you
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
2. Extract the `OctoGroupBuffToggle` folder into your OctoWoW
   `Interface\AddOns` directory.
3. Restart the game or type `/reload`.
4. Make sure **Octo Group Buff Toggle** is enabled on the character-select AddOns screen.

The final path should look like:

```text
World of Warcraft\Interface\AddOns\OctoGroupBuffToggle\OctoGroupBuffToggle.toc
```

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

Built specifically for OctoWoW's Vanilla 1.12 interface (`11200`) and the
default party and target frames. Other unit-frame replacement addons may use
different frame anchors and are not currently supported.

## License

Shared freely for players and friends to use, modify, and enjoy under the MIT License.
