#!/usr/bin/env python3
import os
import re
import subprocess
import sys

import requests

# Get the directory where this script (radio_chooser.py) is located
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Construct the path to radio_stations.txt relative to the script's directory
FAVORITES_FILE = os.path.join(SCRIPT_DIR, "radio_stations.txt")


# --- Rofi Helper Function (UNCHANGED - use_markup will be False for emoji categories) ---
def rofi_prompt(options, prompt="Select", lines=10, use_markup=False):
    """
    Displays a Rofi menu and returns the user's choice.
    Options can contain Pango markup (for icons) if use_markup is True.
    """
    cmd = ["rofi", "-dmenu", "-p", prompt, "-l", str(lines)]
    # We will explicitly set use_markup=False for the emoji-only category menu.
    # If a future menu needs markup, this parameter is still useful.
    if (
        use_markup
    ):  # This will likely not be triggered for the new emoji-only fav categories
        cmd.append("-markup-rows")

    menu = subprocess.run(
        cmd,
        input="\n".join(options),
        text=True,
        capture_output=True,
        check=False,  # Do not raise an error for non-zero exit code (e.g., user pressing Esc)
    )

    # Rofi returns 0 on successful selection, 1 on escape/cancel
    if menu.returncode == 0:
        return menu.stdout.strip()
    else:
        return ""  # Return empty string on cancel/escape


# --- Main Menu Options for Rofi (Uses Emojis) ---
SOURCES = ["⭐️ Favorites", "🎵 Genres"]

# --- Genre Options (Uses Emojis) ---
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

# --- Continent and Country Code Data (Uses Emojis) ---
CONTINENTS = [
    "🇪🇺 Europe",
    "🌎 North America",
    "🌎 South America",
    "🇦🇺 Oceania",
]

CONTINENT_COUNTRY_CODES = {
    "Europe": [
        "AL",
        "AD",
        "AM",
        "AT",
        "AZ",
        "BY",
        "BE",
        "BA",
        "BG",
        "HR",
        "CY",
        "CZ",
        "DK",
        "EE",
        "FI",
        "FR",
        "GE",
        "DE",
        "GR",
        "HU",
        "IS",
        "IE",
        "IT",
        "KZ",
        "XK",
        "LV",
        "LI",
        "LT",
        "LU",
        "MT",
        "MD",
        "MC",
        "ME",
        "NL",
        "MK",
        "NO",
        "PL",
        "PT",
        "RO",
        "RU",
        "SM",
        "RS",
        "SK",
        "SI",
        "ES",
        "SE",
        "CH",
        "TR",
        "UA",
        "GB",
        "VA",
    ],
    "North America": [
        "AG",
        "AI",
        "AW",
        "BS",
        "BB",
        "BZ",
        "BM",
        "BQ",
        "CA",
        "KY",
        "CR",
        "CU",
        "CW",
        "DM",
        "DO",
        "SV",
        "GL",
        "GD",
        "GP",
        "GT",
        "HT",
        "HN",
        "JM",
        "MQ",
        "MX",
        "MS",
        "NI",
        "PA",
        "PR",
        "BL",
        "KN",
        "LC",
        "MF",
        "PM",
        "VC",
        "SX",
        "TT",
        "TC",
        "US",
        "VG",
        "VI",
    ],
    "South America": [
        "AR",
        "BO",
        "BR",
        "CL",
        "CO",
        "EC",
        "FK",
        "GF",
        "GY",
        "PY",
        "PE",
        "SR",
        "UY",
        "VE",
    ],
    "Oceania": [
        "AS",
        "AU",
        "CK",
        "CX",
        "CC",
        "FJ",
        "PF",
        "GU",
        "HM",
        "KI",
        "MH",
        "FM",
        "NR",
        "NC",
        "NZ",
        "NU",
        "NI",
        "NF",
        "MP",
        "PW",
        "PG",
        "PN",
        "WS",
        "SB",
        "TK",
        "TO",
        "TV",
        "UM",
        "VU",
        "WF",
    ],
}

# --- Favorite Categories Mapping with Emojis for Rofi Display ---
# The KEY is the 'clean' category name that appears in your radio_stations.txt file
# inside the brackets, e.g., '[Greek]'.
# The VALUE is the string that will be displayed in Rofi, formatted as "EMOJI CategoryName".
# If your category names in radio_stations.txt differ, adjust the keys here to match them exactly.
FAVORITE_CATEGORIES_MAP = {
    "Greek": "🇬🇷 Greek",  # Flag of Greece emoji
    "Jazz": "🎷 Jazz",  # Saxophone emoji
    "Classical": "🎻 Classical",  # Violin emoji
    "Folk": "🎶 Folk",  # Musical notes emoji (or choose another)
    "Rock": "🎸 Rock",  # Guitar emoji
    "Heavy Metal": "🤘 Heavy Metal",  # Metal hand emoji
    "Blues": "🎵 Blues",  # Musical notes emoji (or choose another)
    "Pop": "🎤 Pop",  # Microphone emoji
    "Rap": "🎤 Rap",  # Microphone emoji (or choose another)
    "Ambient": "🌌 Ambient",  # Milky Way galaxy emoji
    "Techno": "🎧 Techno",  # Headphone emoji
    "Lofi": "☕ Lofi",  # Coffee cup emoji
    "Anime": "🌸 Anime",  # Cherry blossom emoji
    "New Wave": "💿 New Wave",  # CD emoji
    "Political/Talk": "🗣️ Political/Talk",  # Speaking head emoji
    "World Music": "🌍 World Music",  # Earth globe emoji
    # Default/fallback category for any favorites categories not explicitly defined above
    "Other Favorites": "⭐ Other Favorites",  # Star emoji
}

# Define the exact order in which favorite categories will appear in Rofi.
# This list uses the CLEAN internal names (the keys from FAVORITE_CATEGORIES_MAP).
# Categories found in the file but not in this list will be appended at the end.
FAVORITE_CATEGORY_DISPLAY_ORDER_CLEAN = [
    "Greek",
    "Jazz",
    "Rock",
    "Heavy Metal",
    "Blues",
    "Pop",
    "Rap",
    "Ambient",
    "Techno",
    "Lofi",
    "Anime",
    "New Wave",
    "Classical",
    "Folk",
    "Political/Talk",
    "World Music",
    "Other Favorites",  # Ensure fallback is always present, ideally at the end
]


def clean_choice(choice):
    """
    Cleans a Rofi choice by removing leading emoji and spaces, leaving only the text.
    It expects the format 'EMOJI TEXT'.
    """
    if not choice:
        return ""

    # Split at the first space, and take the second part (the text).
    # This handles "⭐️ Favorites" -> "Favorites" and "🇬🇷 Greek" -> "Greek".
    parts = choice.split(" ", 1)
    if len(parts) > 1:
        return parts[1].strip()
    return (
        choice.strip()
    )  # If no space found, return the original (e.g., if just "Favorites")


# MODIFIED FUNCTION: load_favorites to parse categories from the file reliably
def load_favorites():
    """
    Loads favorite radio stations from FAVORITES_FILE, categorized by headers.
    Returns a dictionary: {'clean_category_name': [{'name': 'Station Name', 'url': 'URL'}, ...]}
    Ensures categories found in file are dynamically added to FAVORITE_CATEGORIES_MAP if new.
    """
    if not os.path.exists(FAVORITES_FILE):
        print(
            f"[ERROR] Favorites file does not exist: {FAVORITES_FILE}", file=sys.stderr
        )
        try:
            # Create an empty file with a default category header if it doesn't exist
            with open(FAVORITES_FILE, "w", encoding="utf-8") as f:
                # Use the clean name of the default category for the file header
                f.write(
                    f"[{clean_choice(FAVORITE_CATEGORIES_MAP['Other Favorites'])}]\n"
                )
                f.write("# Add your favorite stations here, one per line:\n")
                f.write("# Station Name=http://stream.url.com\n")
            print(
                f"[INFO] Created empty favorites file: {FAVORITES_FILE}",
                file=sys.stderr,
            )
        except IOError as e:
            print(f"[ERROR] Could not create favorites file: {e}", file=sys.stderr)
        return {}  # Return an empty dictionary if file cannot be created/read

    categorized_stations = {}

    # Initialize with 'Other Favorites' as the current category.
    # Any stations found before a category header will fall into this default.
    current_category_clean_name = "Other Favorites"
    categorized_stations[current_category_clean_name] = []

    with open(FAVORITES_FILE, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue

            if line.startswith("[") and line.endswith("]"):
                # This is a category header from the file (e.g., "[Greek]")
                category_header_from_file = line[
                    1:-1
                ].strip()  # Get "Greek" from "[Greek]"

                # Check if this category header from the file exists as a key in our map.
                # If not, it's a new category.
                if category_header_from_file not in FAVORITE_CATEGORIES_MAP:
                    # Dynamically add this new category to our map with a default emoji.
                    # This ensures it gets an icon and can be displayed.
                    FAVORITE_CATEGORIES_MAP[category_header_from_file] = (
                        f"✨ {category_header_from_file}"  # Default emoji-name format
                    )

                    # Also add it to the display order list if not already there, will appear at the end.
                    if (
                        category_header_from_file
                        not in FAVORITE_CATEGORY_DISPLAY_ORDER_CLEAN
                    ):
                        FAVORITE_CATEGORY_DISPLAY_ORDER_CLEAN.append(
                            category_header_from_file
                        )

                current_category_clean_name = category_header_from_file
                # Ensure the current category exists in the dictionary for stations to be added
                if current_category_clean_name not in categorized_stations:
                    categorized_stations[current_category_clean_name] = []

            elif "=" in line:
                # It's a station entry (e.g., "Station Name=URL")
                name, url = line.split("=", 1)
                clean_name = name.lstrip("- ").strip()

                # Add station to the current category.
                categorized_stations.setdefault(current_category_clean_name, []).append(
                    {"name": clean_name, "url": url.strip()}
                )
            else:
                print(
                    f"[WARN] Skipping malformed line in favorites file: {line}",
                    file=sys.stderr,
                )

    return categorized_stations


def fetch_stations_by_continent_and_genre(continent_name, genre_tag, limit=100):
    """Fetches stations from radio-browser.info based on continent and genre."""
    url = f"https://de1.api.radio-browser.info/json/stations/search?tag={genre_tag}&continent={continent_name}&limit={limit}&hidebroken=true"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        stations = response.json()

        allowed_country_codes = CONTINENT_COUNTRY_CODES.get(continent_name)

        if allowed_country_codes:
            filtered_stations = [
                s for s in stations if s.get("countrycode") in allowed_country_codes
            ]
            return filtered_stations
        else:
            return stations
    except Exception as e:
        print(
            f"Failed to fetch stations for {genre_tag} in {continent_name}: {e}",
            file=sys.stderr,
        )
        return []


# --- Main Logic ---
def main():
    while True:  # Loop to keep Rofi active until user truly exits or selects to exit
        source_choice_display = rofi_prompt(SOURCES, prompt="Radio Chooser:")
        source_choice_clean = clean_choice(source_choice_display)

        if not source_choice_clean:  # User pressed Escape or cancelled initial Rofi
            sys.exit(0)

        if source_choice_clean == "Favorites":
            favorites_data = load_favorites()  # Now loads categorized data

            # Filter out categories that have no stations after loading
            available_favorite_categories_clean_names = [
                cat_name for cat_name, stations in favorites_data.items() if stations
            ]

            if not available_favorite_categories_clean_names:
                subprocess.run(
                    [
                        "notify-send",
                        "Radio Chooser",
                        "No favorite stations found or favorites file is empty.",
                    ],
                    check=False,
                )
                continue  # Go back to main menu loop

            # Prepare favorite categories for Rofi display, respecting predefined order and including new ones
            sorted_favorite_display_options = []
            seen_categories_for_ordering = set()

            # Add categories from the predefined order list first
            for clean_name_from_order_list in FAVORITE_CATEGORY_DISPLAY_ORDER_CLEAN:
                if (
                    clean_name_from_order_list
                    in available_favorite_categories_clean_names
                ):
                    # Get the display string with emoji from our map.
                    sorted_favorite_display_options.append(
                        FAVORITE_CATEGORIES_MAP[clean_name_from_order_list]
                    )
                    seen_categories_for_ordering.add(clean_name_from_order_list)

            # Add any categories found in the file but not in the predefined order list (will be appended at the end)
            for clean_name_from_file in available_favorite_categories_clean_names:
                if clean_name_from_file not in seen_categories_for_ordering:
                    sorted_favorite_display_options.append(
                        FAVORITE_CATEGORIES_MAP[clean_name_from_file]
                    )

            # Display favorite categories in Rofi with emojis
            # No need for use_markup=True here, as Rofi usually handles emojis natively
            chosen_favorite_category_display = rofi_prompt(
                sorted_favorite_display_options,
                prompt="Favorites Categories",
                use_markup=False,  # Set to False as we're using raw emojis, not Pango markup
            )
            # Clean the chosen category display string to get the plain category name for lookup
            clean_chosen_category = clean_choice(chosen_favorite_category_display)

            if (
                not clean_chosen_category
            ):  # User pressed Escape or cancelled category Rofi
                continue  # Go back to main menu loop

            # Retrieve stations for the selected favorite category
            stations_in_category = favorites_data.get(clean_chosen_category, [])

            if not stations_in_category:
                subprocess.run(
                    [
                        "notify-send",
                        "Radio Chooser",
                        f"No stations found in category: {clean_chosen_category}.",
                    ],
                    check=False,
                )
                continue  # Go back to favorite category menu or main menu

            # Prepare station names for Rofi display, formatted as "Name (Fav) — URL"
            station_options = [
                f"{s['name']} (Fav) — {s['url']}" for s in stations_in_category
            ]

            chosen_station_full_string = rofi_prompt(
                station_options, prompt=f"{clean_chosen_category} Stations"
            )

            if (
                not chosen_station_full_string
            ):  # User pressed Escape or cancelled station Rofi
                continue  # Go back to favorite category menu or main menu

            # Extract the URL from the chosen string (assuming URL is always the last part after " — ")
            parts = chosen_station_full_string.split(" — ")
            if len(parts) >= 2:
                selected_url = parts[-1].strip()
                # Print the selected station and URL in the format your external script expects
                print(
                    f"{chosen_station_full_string.replace(f' — {selected_url}', '').strip()}|||{selected_url}"
                )
                sys.exit(0)  # Exit after playing a station
            else:
                subprocess.run(
                    [
                        "notify-send",
                        "Radio Chooser",
                        "Invalid station format selected.",
                    ],
                    check=False,
                )
                continue  # Go back to station selection or main menu

        elif source_choice_clean == "Genres":
            # Your existing logic for genres (mostly unchanged, adjusted for clean_choice and display format)
            continent_choice_display = rofi_prompt(CONTINENTS, prompt="Continent")
            continent_clean = clean_choice(continent_choice_display)
            if not continent_clean:
                continue  # Go back to main menu loop

            genre_choice_display = rofi_prompt(
                GENRES, prompt=f"Genre in {continent_clean}"
            )
            genre_clean = clean_choice(
                genre_choice_display
            ).lower()  # Convert to lowercase for API tag
            if not genre_clean:
                continue  # Go back to main menu loop

            stations_fetched = fetch_stations_by_continent_and_genre(
                continent_clean, genre_clean
            )
            if not stations_fetched:
                subprocess.run(
                    [
                        "notify-send",
                        "Radio Chooser",
                        f"No stations found for {genre_clean} in {continent_clean}.",
                    ],
                    check=False,
                )
                continue  # Go back to main menu loop

            # Display stations with Country Code, formatted as "Name (CountryCode) — URL"
            station_options = [
                f"{s['name']} ({s.get('countrycode', 'N/A')}) — {s['url']}"
                for s in stations_fetched
                if s.get("url")  # Ensure URL exists
            ]

            chosen_station_full_string = rofi_prompt(
                station_options,
                prompt=f"{genre_clean.capitalize()} in {continent_clean}",
            )

            if not chosen_station_full_string:
                continue  # Go back to genre selection or main menu

            # Extract the URL from the chosen string
            parts = chosen_station_full_string.split(" — ")
            if len(parts) >= 2:
                selected_url = parts[-1].strip()
                # Print the selected station and URL in the format your external script expects
                print(
                    f"{chosen_station_full_string.replace(f' — {selected_url}', '').strip()}|||{selected_url}"
                )
                sys.exit(0)  # Exit after playing a station
            else:
                subprocess.run(
                    [
                        "notify-send",
                        "Radio Chooser",
                        "Invalid station format selected.",
                    ],
                    check=False,
                )
                continue  # Go back to station selection or main menu


# When the script is executed, run the main function
if __name__ == "__main__":
    main()
