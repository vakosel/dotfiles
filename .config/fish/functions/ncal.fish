function ncal --description "wpgtk color support for all ncal flags"
    # Check if the user is asking for a full year layout (-y)
    if string match -q -- "-*y*" "$argv"
        # Year view coloring pipeline
        script -q -c "command ncal $argv" /dev/null | sed -E \
            -e "s/\x1b\[7m/\x1b\[1;35m/g" \
            -e "s/\x1b\[27m/\x1b\[0m/g" \
            -e "s/(Δε|Τρ|Τε|Πε|Πα|Σα|Κυ)/\x1b\[1;36m&\x1b\[0m/g" \
            -e "s/([α-ωΑ-Ωίϊΐόάέύϋΰήώ]{3,15})/\x1b\[1;33m&\x1b\[0m/g"
    else
        # Standard monthly view coloring pipeline
        script -q -c "command ncal $argv" /dev/null | sed -E \
            -e "s/\x1b\[7m/\x1b\[1;35m/g" \
            -e "s/\x1b\[27m/\x1b\[0m/g" \
            -e "s/(Δε|Τρ|Τε|Πε|Πα|Σα|Κυ)/\x1b\[1;36m&\x1b\[0m/g" \
            -e "s/([α-ωΑ-Ωίϊΐόάέύϋΰήώ]{3,15} [0-9]{4})/\x1b\[1;33m&\x1b\[0m/g"
    end
end
