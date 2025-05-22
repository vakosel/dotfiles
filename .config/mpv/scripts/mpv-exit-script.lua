-- ~/.config/mpv/scripts/mpv-exit-script.lua
-- This script runs inside mpv and updates the status file when mpv exits.
mp.register_event(mp.EVENT_SHUTDOWN, function()
	-- Update the status file to "Off Air"
	os.execute("echo '🎙️ Off Air' > " .. os.getenv("HOME") .. "/.cache/dm-radio-status")
	-- Clean up the PID file if it exists, as mpv is now gone
	os.execute("rm -f /tmp/mpv-radio-pid")
end)
