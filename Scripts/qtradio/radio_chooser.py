#!/usr/bin/env python3
import os
import subprocess
import sys

import requests

FAVORITES_FILE = os.path.expanduser("/home/vakosel/Scripts/qtradio/radio_stations.txt")


def rofi_prompt(options, prompt="Select", lines=10):
    menu = subprocess.run(
        ["rofi", "-dmenu", "-p", prompt, "-l", str(lines)],
        input="\n".join(options),
        text=True,
        capture_output=True,
    )
    return menu.stdout.strip()


# Preferred icons list
SOURCES = ["⭐️ Favorites", "🎵 Genres"]
GENRES = [
    "🎻 Classical",
    "🎷 Jazz",
    "🎸 Rock",
    "🎵 Blues",
    "🌌 Ambient",
    "🧘 Chillout",
    "🤘 Metal",
    "🎧 Techno",
    "☕ Lofi",
    "🎤 Pop",
    "🎺 Funk",
    "⚡ Electronic",
    "🇯🇲 Reggae",
    "🔮 Trance",
    "📰 News",
]


def clean_choice(choice):
    if not choice:
        return ""
    return choice[2:].strip()


def fetch_stations_by_genre(tag="jazz", limit=20):
    url = f"https://de1.api.radio-browser.info/json/stations/bytag/{tag}?limit={limit}&hidebroken=true"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Failed to fetch stations: {e}", file=sys.stderr)
        return []


def load_favorites():
    if not os.path.exists(FAVORITES_FILE):
        print(f"[ERROR] File does not exist: {FAVORITES_FILE}", file=sys.stderr)
        return []

    with open(FAVORITES_FILE, "r") as f:
        lines = f.read().splitlines()

    stations = []
    for line in lines:
        if "=" in line:
            name, url = line.split("=", 1)
            clean_name = name.lstrip("- ").strip()  # Strip any leading dash and spaces
            stations.append({"name": clean_name, "url": url.strip(), "country": "Fav"})
        else:
            print(f"[WARN] Skipping malformed line: {line}", file=sys.stderr)

    return stations


def main():
    source_choice = rofi_prompt(SOURCES, prompt="Choose source")
    source = clean_choice(source_choice)
    if not source:
        sys.exit(0)

    if source == "Favorites":
        stations = load_favorites()
        if not stations:
            print("No favorites found.", file=sys.stderr)
            sys.exit(1)
        display_list = [f"{s['name']} ({s['country']}) — {s['url']}" for s in stations]
        for item in display_list:
            print(item, file=sys.stderr)

    else:
        genre_choice = rofi_prompt(GENRES, prompt="Genre")
        genre = clean_choice(genre_choice).lower()
        if not genre:
            sys.exit(0)
        stations = fetch_stations_by_genre(genre)
        if not stations:
            print(f"No stations found for genre '{genre}'.", file=sys.stderr)
            sys.exit(1)
        display_list = [
            f"{s['name']} ({s['country']}) — {s['url']}"
            for s in stations
            if s.get("url")
        ]

    for item in display_list:
        print(item, file=sys.stderr)

    choice = rofi_prompt(display_list, prompt=source, lines=min(20, len(display_list)))

    if not choice:
        sys.exit(0)

    name_url = choice.split(" — ")
    if len(name_url) != 2:
        sys.exit(1)

    name_part = name_url[0]
    url = name_url[1].strip()

    # Output for radio_play.sh to capture
    print(f"{name_part}|||{url}")
    sys.exit(0)


if __name__ == "__main__":
    main()
