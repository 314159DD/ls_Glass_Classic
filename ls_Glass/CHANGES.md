# LS: Glass Classic

This is a modified distribution of [LS: Glass](https://github.com/ls-/ls_Glass) by lightspark,
ported to WoW Classic Era. The original addon is his work and is licensed under the Apache License
2.0, a copy of which ships alongside this file as `LICENSE.txt`.

Upstream targets retail and is retired. This fork exists to keep the addon running on Classic Era.
It is not maintained by the original author.

## Modified files and what changed

- `ls_Glass.toc` - Interface raised to 11509, retitled, version scheme changed.
- `core/components/tab.lua` - chat tab textures use the Classic Era keys (`leftTexture`,
  `leftSelectedTexture`, `leftHighlightTexture` and friends) instead of the retail names.
- `core/components/editbox.lua` - dropped the focus border textures, which do not exist on
  Classic Era.
- `core/components/slidingmessageframe.lua` - guarded the battle pet tooltip, and fixed a hook that
  registered `ChatPageDown` as a second `ChatPageUp`.
- `core/components/button.lua` - guarded `QuickJoinToastButton` and the chat alert subsystems, with
  a fallback anchor for the channel button.
- `core/config.lua` - hid the Quick Join toast option, added a note for when Prat's Editbox module
  owns the chat input box.
- `locales/enUS.lua` - added the string for that note.
- `init.lua` - guarded frames absent on Classic Era, and corrected the minimize button lookup to
  `ChatFrame<N>MinimizeButton`.

Full history: https://github.com/314159DD/ls_Glass_Classic
