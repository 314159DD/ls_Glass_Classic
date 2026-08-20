# LS: Glass Classic

A **WoW Classic Era** port of [LS: Glass](https://github.com/ls-/ls_Glass) by lightspark.

Chat messages slide and fade in as they arrive, then fade away again once they are old. The chat
frame, its tabs and its buttons stay invisible until you move the mouse over them.

![Imgur](https://i.imgur.com/8lj13ch.gif)

## About this fork

Upstream LS: Glass targets retail and has been officially retired by its author, who does not play
Classic and declined to support it. This fork exists only to keep the addon working on Classic Era
(Interface 11509, patch 1.15.9).

It is not maintained by the original author. Please do not send him bug reports about this fork.

## Install

Copy the `ls_Glass` folder into:

```
World of Warcraft\_classic_era_\Interface\AddOns\
```

## Options

Use **`/lsglass`** or **`/lsg`** to open the in-game config.

Fade timing lives under **Chat -> Fading -> Fade Out Delay**.

## Prat 3.0

Both addons run together fine. Prat's **Editbox** module takes over the chat input box, though: it
reparents the box and sets its font directly, which overrides the Edit Box section here. Disable
that one Prat module if you want LS: Glass to own the input box. The config shows a note in that
section while the module is active.

## Changes from upstream

- Interface version raised to 11509 for Classic Era.
- Chat tab textures use the Classic Era keys (`leftTexture`, `leftSelectedTexture`,
  `leftHighlightTexture` and friends) rather than the retail `Left` / `ActiveLeft` / `HighlightLeft`.
- The chat edit box no longer touches the focus border textures, which do not exist on Classic Era.
- The minimize button is looked up as `ChatFrame<N>MinimizeButton`, where Classic Era parents it,
  instead of under the button frame.
- `QuickJoinToastButton`, `AddonCompartmentFrame`, `NewcomerHint` and `BattlePetTooltip` are guarded,
  as Classic Era has no such frames. The Quick Join toast option is hidden there.
- Fixed a hook that registered `ChatPageDown` as a second `ChatPageUp`, so page down works.
- Added a note in the Edit Box settings when Prat's Editbox module owns the input box.

## License

Apache License 2.0, unchanged from upstream. See [LICENSE.txt](LICENSE.txt).

The original addon is the work of lightspark. This is a modified distribution; the modifications are
listed above.
