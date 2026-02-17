import os
import subprocess
import sys

from libqtile import bar, extension, hook, layout, qtile 
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import ColorFormatter
from qtile_extras import widget

import colors

mod = "mod4"  # Sets mod key to SUPER/WINDOWS
myTerm = "wezterm"  # My terminal of choice
myBrowser = "brave"  # My browser of choice
logout = "/home/vakosel/.config/rofi/powermenu/powermenu.sh"
fileBrowser = "/usr/bin/thunar"


# Allows you to input a name when adding treetab section.
@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)


# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


# A function for toggling between MAX and MONADTALL layouts
@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == "monadtall":
        qtile.current_group.layout = "max"
    elif current_layout_name == "max":
        qtile.current_group.layout = "monadtall"


alt = "mod1"
keys = [
    # The essentials
    Key([mod], "Return", lazy.spawn(myTerm), desc="Terminal"),
    Key([mod, "shift"], "Return", lazy.spawn("rofi -show drun"), desc="Run Launcher"),
    Key([mod], "w", lazy.spawn(myBrowser), desc="Web browser"),
    Key([mod], "e", lazy.spawn(fileBrowser), desc="Thunar"),
    Key(
        [mod],
        "b",
        lazy.hide_show_bar(position="all"),
        desc="Toggles the bar to show/hide",
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.spawn(logout), desc="Logout menu"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Switch between windows
    # Some layouts like 'monadtall' only need to use j/k to move
    # through the stack, but other layouts like 'columns' will
    # require all four directions h/j/k/l to move around.
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab",
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab",
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab",
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Treetab prompt
    Key(
        [mod, "shift"],
        "a",
        add_treetab_section,
        desc="Prompt to add new section in treetab",
    ),
    # Grow/shrink windows left/right.
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key(
        [mod],
        "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    # Grow windows up, down, left, right.  Only works in certain layouts.
    # Works in 'bsp' and 'columns' layout.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "m", lazy.layout.maximize(), desc="Toggle between min and max sizes"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="toggle floating"),
    Key(
        [mod],
        "f",
        maximize_by_switching_layout(),
        lazy.window.toggle_fullscreen(),
        desc="toggle fullscreen",
    ),
    Key(
        [mod, "shift"],
        "m",
        minimize_all(),
        desc="Toggle hide/show all windows on current group",
    ),
    # Swith keyboard layouts
    Key(
        [
            alt,
        ],
        "Shift_L",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout",
    ),
    # Switch focus of monitors
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
    # Dmenu/rofi scripts launched using the key chord SUPER+p followed by 'key'
    KeyChord(
        [mod],
        "p",
        [
            Key(
                [],
                "c",
                lazy.spawn("/home/vakosel/Scripts/qtradio/radio_play.sh"),
                desc="Translate text",
            ),
            Key(
                [],
                "p",
                lazy.spawn("/home/vakosel/Scripts/qtradio/toggle_play_pause.sh"),
                desc="Translate text",
            ),
            Key(
                [],
                "q",
                lazy.spawn("/home/vakosel/Scripts/qtradio/radio_stop.sh"),
                desc="Translate text",
            ),
        ],
    ),
]

groups = []
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

# group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
# group_labels = ["DEV", "WWW", "SYS", "DOC", "VBOX", "CHAT", "MUS", "VID", "GFX", "MISC"]
group_labels = ["", "", "", "", "", "", "𝦝", "", "", "⛨"]
# group_labels = [" ", " ", " ", " ", " ", " ", "⛨ ", " ", " "]

group_layouts = [
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
]


for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        )
    )

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

colors = colors.Wal_Colors
layout_theme = {
    "border_width": 2,
    "margin": 12,
    "border_focus": colors[8],
    "border_normal": colors[0],
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Tile(**layout_theme),
    layout.Max(**layout_theme),
]


# --- Functions for Radio Widget ---

base_script_dir = "/home/vakosel/Scripts/qtradio"  # Define base directory here


# Your get_radio_status function (should be defined here or imported)
# If your get_radio_status reads radio-status or radio-song.txt, ensure it also uses base_script_dir


def get_radio_status():
    status_file = os.path.join(base_script_dir, "radio-status")
    song_file = os.path.join(base_script_dir, "radio-song.txt")

    status = "🔴 Off"  # Default status
    song_info = "Loading..."  # Default song info

    if os.path.exists(status_file):
        try:
            with open(status_file, "r", encoding="utf-8") as f:
                status = f.read().strip()
        except Exception:
            status = "🔴 Error"

    if os.path.exists(song_file):
        try:
            with open(song_file, "r", encoding="utf-8") as f:
                song_info = f.read().strip()
        except Exception:
            song_info = "Error Song"

    if "🎧" in status or "⏸️" in status:
        return f"{status} {song_info}"
    else:
        return status


def get_full_radio_song():
    full_song_file = os.path.join(base_script_dir, "radio-song-full.txt")
    if os.path.exists(full_song_file):
        try:
            with open(full_song_file, "r", encoding="utf-8") as f:
                content = f.read().strip()
                return content if content else "No Full Song Info"
        except Exception:
            return "Error Reading Full Info"
    return "No Full Song Info"


def show_full_radio_song_notification():
    full_title = get_full_radio_song()

    if full_title == "Paused":
        notification_text = "Radio is currently paused."
        notification_title = "Radio Status"
    elif full_title in [
        "Radio Off",
        "No Full Song Info",
        "Error Reading Full Info",
        "🎙️ Off Air",
    ]:
        notification_text = "Radio is off or no song information is available."
        notification_title = "Radio Status"
    else:
        notification_text = full_title
        notification_title = "Current Song"

    notification_command = (
        f"notify-send '{notification_title}' '{notification_text}' -t 5000"
    )
    qtile.cmd_spawn(notification_command)


# --- End Helper Functions ---


widget_defaults = dict(font="Ubuntu Bold", fontsize=12, padding=0, background=colors[0])

extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list = [
        widget.Spacer(length=12),
        widget.Image(
            filename="~/.config/qtile/icons/infinity-icon.png",
            scale="False",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm)},
        ),
        widget.Prompt(font="Ubuntu Mono", fontsize=14, foreground=colors[1]),
        widget.GroupBox(
            fontsize=13,
            margin_y=5,
            margin_x=8,
            padding_y=0,
            padding_x=1,
            borderwidth=3,
            active=colors[6],  # default was colors[8]
            inactive=colors[9],
            rounded=False,
            highlight_color=colors[2],
            highlight_method="line",
            this_current_screen_border=colors[7],
            this_screen_border=colors[4],
            other_current_screen_border=colors[7],
            other_screen_border=colors[4],
        ),
        widget.TextBox(
            text="|",
            font="Ubuntu Mono",
            foreground=colors[9],
            padding=2,
            fontsize=14,
        ),
        widget.CurrentLayout(foreground=colors[1], padding=5),
        widget.TextBox(
            text="|",
            font="Ubuntu Mono",
            foreground=colors[9],
            padding=2,
            fontsize=14,
        ),
        widget.WindowName(foreground=colors[6], padding=4, max_chars=40),
        widget.GenPollText(
            func=get_radio_status,
            name="radio_status",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    "/home/vakosel/Scripts/qtradio/toggle_play_pause.sh"
                ),  # Left click
                "Button2": lambda: qtile.cmd_spawn(
                    "/home/vakosel/Scripts/qtradio/radio_play.sh"
                ),  # Middle click
                "Button3": lambda: qtile.cmd_spawn(
                    "/home/vakosel/Scripts/qtradio/radio_stop.sh"
                ),  # Right click
                "Button4": lambda: qtile.cmd_spawn(
                    "/Scripts/qtradio/radio_add_favorite.sh"
                ),  # Scroll up: add to favorites
                "Button5": show_full_radio_song_notification,  # Scroll down: show full song title
            },
            update_interval=1,
            padding=6,
            foreground=colors[3],
        ),
        widget.CPU(
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")},
            format=" Cpu: {load_percent}%",
            foreground=colors[4],
            padding=6,
        ),
        widget.Memory(
            foreground=colors[8],
            padding=6,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")},
            format="{MemUsed: .0f}{mm}",
            fmt="🖥  Mem: {} used",
        ),
        widget.Volume(
            backend="pipewire", 
            foreground=colors[7],
            padding=6,
            fmt="🕫  Vol: {}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol"),
                "Button2": lazy.restart(),  # Add to force a restart on middle-click
            },
        ),
        widget.KeyboardLayout(
            configured_keyboards=["us", "gr"],
            foreground=colors[4],
            padding=6,
            fmt="⌨  Kbd: {}",
        ),
        widget.Clock(
            foreground=colors[8],
            padding=6,
            format="⏱  %a, %b %d - %H:%M",
        ),
        widget.Systray(padding=3),
        widget.Spacer(length=8),
    ]
    return widgets_list


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1


# All other monitors' bars will display everything but widgets 22 (systray) and 23 (spacer).
def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    del widgets_screen2[15:16]
    return widgets_screen2


# For adding transparency to your bar, add (background="#00000000") to the "Screen" line(s)
# For ex: Screen(top=bar.Bar(widgets=init_widgets_screen2(), background="#00000000", size=24)),


def init_screens():
    return [
        Screen(
            top=bar.Bar(
                widgets=init_widgets_screen1(),
                margin=[8, 12, 0, 12],
                size=28,
            )
        ),
        Screen(
            top=bar.Bar(
                widgets=init_widgets_screen2(),
                margin=[8, 12, 0, 12],
                size=28,
            )
        ),
        Screen(
            top=bar.Bar(
                widgets=init_widgets_screen2(),
                margin=[8, 12, 0, 12],
                size=28,
            )
        ),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="dialog"),  # dialog boxes
        Match(wm_class="download"),  # downloads
        Match(wm_class="error"),  # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class="kdenlive"),  # kdenlive
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="notification"),  # notifications
        Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="toolbar"),  # toolbars
        Match(wm_class="Yad"),  # yad boxes
        Match(title="branchdialog"),  # gitk
        Match(title="Confirmation"),  # tastyworks exit box
        Match(title="Qalculate!"),  # qalculate-gtk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="tastycharts"),  # tastytrade pop-out charts
        Match(title="tastytrade"),  # tastytrade pop-out side gutter
        Match(title="tastytrade - Portfolio Report"),  # tastytrade pop-out allocation
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"),  # tastytrade settings
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
