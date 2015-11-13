
#!/bin/bash
#
# Watches the folder or files passed as arguments to the script and when it
# detects a change it automatically refreshes the current selected Chrome tab or
# window.
#
# Usage:
# ./chrome-refresh.sh /folder/to/watch /some/folder/file_to_watch.html

TIME_FORMAT='%F %H:%M'
OUTPUT_FORMAT='%T Event(s): %e fired for file: %w. Refreshing.'

CMD=$1
echo $CMD

shift
FILES=$@
echo $FILES

while inotifywait -q -r --event=modify --timefmt "${TIME_FORMAT}" --format "${OUTPUT_FORMAT}" $FILES; do
    MYWINDOW=$(xdotool getwindowfocus)
    CHROME_WINDOW_ID=$(xdotool search --onlyvisible --name "$CMD" | head -1)
    echo "chrome window: $CHROME_WINDOW_ID"
    xwininfo -root -tree |grep `printf 0x%x $CHROME_WINDOW_ID`
    xdotool key --window $CHROME_WINDOW_ID windowfocus F5 # 'CTRL+r'
    xdotool key --window $CHROME_WINDOW_ID windowfocus 'CTRL+r'
    xdotool windowfocus --sync ${MYWINDOW}
done
