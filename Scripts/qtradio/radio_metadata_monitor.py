#!/usr/bin/env python3
import json
import os
import socket
import sys
import time

# Get the directory where this script is located
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Define constants
IPC_SOCKET = "/tmp/mpv-radio-ipc"
RADIO_SONG_FILE = os.path.join(SCRIPT_DIR, "radio-song.txt")
RADIO_SONG_FULL_FILE = os.path.join(SCRIPT_DIR, "radio-song-full.txt")
FALLBACK_TEXT = "No song info / Playing station name"
MAX_SONG_INFO_LENGTH = 50
ELLIPSIS = "..."


def send_mpv_command_and_get_response(sock, command_json_str, timeout=0.5):
    """
    Sends an MPV command and tries to read its immediate response.
    Returns the parsed JSON response or None on failure/timeout.
    """
    try:
        request_id = int(time.time() * 1000) % 1000000
        command_with_id = json.loads(command_json_str)
        command_with_id["request_id"] = request_id
        command_str_with_id = json.dumps(command_with_id) + "\n"

        sock.sendall(command_str_with_id.encode("utf-8"))

        start_time = time.time()
        buffer = ""
        while time.time() - start_time < timeout:
            try:
                sock.setblocking(False)
                data = sock.recv(4096)
                sock.setblocking(True)

                if not data:
                    return None

                decoded_data = data.decode("utf-8", errors="ignore")
                buffer += decoded_data

                for line in buffer.split("\n"):
                    if line.strip():
                        try:
                            response = json.loads(line)
                            if (
                                response.get("request_id") == request_id
                                and "data" in response
                            ):
                                return response.get("data")
                        except json.JSONDecodeError:
                            pass
                buffer = "\n".join(
                    [
                        l
                        for l in buffer.split("\n")
                        if l.strip() and json.loads(l).get("request_id") != request_id
                    ]
                )

            except BlockingIOError:
                time.sleep(0.01)
            except Exception:
                return None
        return None
    except Exception:
        return None


def monitor_mpv_metadata():
    s = None
    try:
        timeout_start = time.time()
        while not os.path.exists(IPC_SOCKET):
            if time.time() - timeout_start > 5:
                with open(RADIO_SONG_FILE, "w", encoding="utf-8") as f:
                    f.write("Radio not playing")
                with open(RADIO_SONG_FULL_FILE, "w", encoding="utf-8") as f:
                    f.write("Radio not playing")
                sys.exit(1)
            time.sleep(0.1)

        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(IPC_SOCKET)

        s.sendall(b'{"command": ["observe_property", 0, "metadata"]}\n')
        s.sendall(b'{"command": ["observe_property", 1, "media-title"]}\n')
        s.sendall(b'{"command": ["observe_property", 2, "pause"]}\n')

        last_song_info_display = ""
        last_song_info_full = ""
        buffer = ""
        while True:
            try:
                data = s.recv(8192)
                if not data:
                    break

                decoded_data = data.decode("utf-8", errors="ignore")
                buffer += decoded_data

                while "\n" in buffer:
                    line, buffer = buffer.split("\n", 1)
                    if not line.strip():
                        continue

                    try:
                        response = json.loads(line)
                        current_song_info_raw = None

                        if response.get("event") == "property-change":
                            prop_name = response.get("name")
                            prop_data = response.get("data")

                            if prop_name == "metadata":
                                if isinstance(prop_data, dict):
                                    title = prop_data.get("icy-title") or prop_data.get(
                                        "title"
                                    )
                                    artist = prop_data.get(
                                        "icy-artist"
                                    ) or prop_data.get("artist")
                                    if title and artist:
                                        current_song_info_raw = (
                                            f"{title} - {artist}".strip(" - ")
                                        )
                                    elif title:
                                        current_song_info_raw = title.strip()

                            elif prop_name == "media-title" and prop_data:
                                current_song_info_raw = str(prop_data).strip()

                            elif prop_name == "pause":
                                if prop_data is True:
                                    current_song_info_raw = "Paused"
                                else:
                                    metadata_data = send_mpv_command_and_get_response(
                                        s, '{"command": ["get_property", "metadata"]}'
                                    )
                                    media_title_data = send_mpv_command_and_get_response(
                                        s,
                                        '{"command": ["get_property", "media-title"]}',
                                    )

                                    if isinstance(metadata_data, dict):
                                        title = metadata_data.get(
                                            "icy-title"
                                        ) or metadata_data.get("title")
                                        artist = metadata_data.get(
                                            "icy-artist"
                                        ) or metadata_data.get("artist")
                                        if title and artist:
                                            current_song_info_raw = (
                                                f"{title} - {artist}".strip(" - ")
                                            )
                                        elif title:
                                            current_song_info_raw = title.strip()

                                    if not current_song_info_raw and media_title_data:
                                        current_song_info_raw = str(
                                            media_title_data
                                        ).strip()

                                    if not current_song_info_raw:
                                        current_song_info_raw = FALLBACK_TEXT

                        if current_song_info_raw is None:
                            if last_song_info_full and last_song_info_full != "Paused":
                                current_song_info_raw = last_song_info_full
                            else:
                                current_song_info_raw = FALLBACK_TEXT

                        if current_song_info_raw == "Paused":
                            current_song_info_full_for_file = "Paused"
                            current_song_info_display = "Paused"
                        elif current_song_info_raw == FALLBACK_TEXT:
                            current_song_info_full_for_file = FALLBACK_TEXT
                            current_song_info_display = FALLBACK_TEXT
                        else:
                            current_song_info_full_for_file = current_song_info_raw
                            if len(current_song_info_raw) > MAX_SONG_INFO_LENGTH:
                                current_song_info_display = (
                                    current_song_info_raw[
                                        : MAX_SONG_INFO_LENGTH - len(ELLIPSIS)
                                    ]
                                    + ELLIPSIS
                                )
                            else:
                                current_song_info_display = current_song_info_raw

                        if current_song_info_display != last_song_info_display:
                            last_song_info_display = current_song_info_display
                            with open(RADIO_SONG_FILE, "w", encoding="utf-8") as f:
                                f.write(current_song_info_display)

                        if current_song_info_full_for_file != last_song_info_full:
                            last_song_info_full = current_song_info_full_for_file
                            with open(RADIO_SONG_FULL_FILE, "w", encoding="utf-8") as f:
                                f.write(current_song_info_full_for_file)

                    except json.JSONDecodeError:
                        pass
                    except Exception:
                        pass

            except BlockingIOError:
                time.sleep(0.05)
            except ConnectionResetError:
                break
            except Exception:
                break

    except ConnectionRefusedError:
        with open(RADIO_SONG_FILE, "w", encoding="utf-8") as f:
            f.write("Radio not playing (socket error)")
        with open(RADIO_SONG_FULL_FILE, "w", encoding="utf-8") as f:
            f.write("Radio not playing (socket error)")
    except FileNotFoundError:
        with open(RADIO_SONG_FILE, "w", encoding="utf-8") as f:
            f.write("Radio not playing (socket not found)")
        with open(RADIO_SONG_FULL_FILE, "w", encoding="utf-8") as f:
            f.write("Radio not playing (socket not found)")
    except Exception:
        with open(RADIO_SONG_FILE, "w", encoding="utf-8") as f:
            f.write("Radio not playing (monitor setup error)")
        with open(RADIO_SONG_FULL_FILE, "w", encoding="utf-8") as f:
            f.write("Radio not playing (monitor setup error)")
    finally:
        if os.path.exists(RADIO_SONG_FILE):
            with open(RADIO_SONG_FILE, "w", encoding="utf-8") as f:
                f.write("🎙️ Off Air")
        if os.path.exists(RADIO_SONG_FULL_FILE):
            with open(RADIO_SONG_FULL_FILE, "w", encoding="utf-8") as f:
                f.write("🎙️ Off Air")

        if "s" in locals() and s is not None and not s._closed:
            s.close()


if __name__ == "__main__":
    monitor_mpv_metadata()
