#!/bin/zsh

# Define the output directory and filename
OUTPUT_DIR="$HOME/Videos"
FILENAME="$(date +'%H:%M:%S_%d-%m-%Y.mp4')"
FILEPATH="$OUTPUT_DIR/$FILENAME"

# Define the lockfile location
LOCKFILE="$HOME/.screen_recorder.lock"

# Check if recording is already in progress
if [ -f "$LOCKFILE" ]; then
    # Stop recording
    pkill -SIGINT wf-recorder
    rm "$LOCKFILE"
    notify-send "Screen Recording Stopped" "Recording saved to $FILEPATH"
else
    # Start recording
    wf-recorder -f "$FILEPATH" &
    echo $$ > "$LOCKFILE"
    notify-send "Screen Recording Started" "Recording to $FILEPATH"
fi
