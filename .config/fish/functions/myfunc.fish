# Functions needed for !! and !$
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

# The bindings for !! and !$
if [ "$fish_key_bindings" = fish_vi_key_bindings ]

    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Function: coln
# Description: Prints the specified column (splits input on whitespace)
# Usage: echo "1 2 3" | coln 3
function coln
    # Ensure a column number is provided
    if test (count $argv) -lt 1
        echo "Usage: coln <column_number>"
        return 1
    end

    # Read lines and print the desired column
    while read -l input
        echo $input | awk "{print \$$argv[1]}"
    end
end

# Function: rown
# Description: Prints the specified row from input
# Usage: seq 3 | rown 2
# Output: 2
function rown --argument index
    # Validate input
    if test -z "$index"
        echo "Usage: rown <row_number>"
        return 1
    end

    # Use sed to print the requested row
    sed -n "$index"p
end

# Function: skip
# Description: Skips the first N lines of input
# Usage: seq 10 | skip 5
# Output: 6 through 10
function skip --argument n
    if test -z "$n"
        echo "Usage: skip <number_of_lines_to_skip>"
        return 1
    end

    set start (math "$n + 1")
    tail -n +$start
end

# Function: take
# Description: Takes the first N lines of input
# Usage: seq 10 | take 5
# Output: 1 through 5
function take --argument number
    if test -z "$number"
        echo "Usage: take <number_of_lines_to_take>"
        return 1
    end

    head -n $number
end

function radio --argument url
    if test -z "$url"
        echo "Usage: radio <YouTube URL>"
        return 1
    end
    mpv --no-video (yt-dlp -f bestaudio -g $url)
end
