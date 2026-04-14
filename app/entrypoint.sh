#!/bin/bash

# BOOT LOG_INIT ( Captures the script output | Default: false )
if [[ "${LOG_INIT:-false}" == "true" ]]; then
    BOOT_LOG="$LOGPATH/container_init.log"
    # Writes to the console and saves to a file.
    exec > >(while read -r line; do echo "[$(date +'%Y-%m-%d %H:%M:%S')] $line"; done | tee -a "$BOOT_LOG") 2>&1
    echo -e "\n--- Starting Terraria World Settings ---\n"
    echo -e "[INFO] File logging is ENABLED.\n[INFO] Saving to $BOOT_LOG"
else
    # It only writes to the console (STDOUT - visible via 'docker logs').
    exec > >(while read -r line; do echo "[$(date +'%Y-%m-%d %H:%M:%S')] $line"; done) 2>&1
    echo -e "\n--- Starting Terraria World Settings ---\n"
    echo -e "[INFO] File logging is DISABLED.\n[INFO] Set LOG_INIT=true to enable."
fi

# Graceful Shutdown:
term_handler() {
    echo -e "\n[INFO] Stop signal received. Saving the world..."
    echo "exit" >&3
    wait "$child"
	echo -e "\n[INFO] Server shut down safely. World saved!"
    exit 0
}
trap 'term_handler' SIGTERM

# Create the Pipe:
PIPE="/tmp/tshock.pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

# Open FD 3 with the internal FD 4, to keep the Pipe "alive".
exec 3> >(
    exec 4> "$PIPE"
    while read -r cmd; do
        echo "[PIPE-IN] $cmd"  # This appears in the console (and log) for conference.
        echo "$cmd" >&4        # This sends ONLY the clean command to the server.
    done
)
echo "[INFO] Pipe Monitor active and waiting for server..."

# Check if the configuration file exists.
if [[ ! -f "$CONFIGPATH/config.json" ]]; then
    echo "[INFO] config.json not found in volume. Copying base file..."
    cp /app/config.json "$CONFIGPATH/config.json"
fi
if [[ ! -f "$CONFIGPATH/sscconfig.json" ]]; then
    echo "[INFO] sscconfig.json not found in volume. Copying base file..."
    cp /app/sscconfig.json "$CONFIGPATH/sscconfig.json"
fi

# Parameters config.json:
if [[ ${SERVER_PASSWORD+x} ]]; then
    echo "[INFO] Setting a Server Password to: (hidden for security)"
    jq --arg val "$SERVER_PASSWORD" '.Settings.ServerPassword = $val' "$CONFIGPATH/config.json" > "$CONFIGPATH/config.tmp" \
&&  mv "$CONFIGPATH/config.tmp" "$CONFIGPATH/config.json"
fi
if [[ ${MAX_SLOTS+x} && "$MAX_SLOTS" =~ ^[0-9]+$ ]]; then
    echo "[INFO] Changing Max Players to: $MAX_SLOTS"
    jq --arg val "$MAX_SLOTS" '.Settings.MaxSlots = ($val | tonumber)' "$CONFIGPATH/config.json" > "$CONFIGPATH/config.tmp" \
&&  mv "$CONFIGPATH/config.tmp" "$CONFIGPATH/config.json"
fi
if [[ ${REST_API_ENABLED+x} && "$REST_API_ENABLED" =~ ^(true|false)$ ]]; then
    echo "[INFO] Changing RestApiEnabled to: $REST_API_ENABLED"
    jq --arg val "$REST_API_ENABLED" '.Settings.RestApiEnabled = ($val == "true")' "$CONFIGPATH/config.json" > "$CONFIGPATH/config.tmp" \
&&  mv "$CONFIGPATH/config.tmp" "$CONFIGPATH/config.json"
fi
if [[ ${LOG_REST+x} && "$LOG_REST" =~ ^(true|false)$ ]]; then
    echo "[INFO] Changing LogRest state to: $LOG_REST"
    jq --arg val "$LOG_REST" '.Settings.LogRest = ($val == "true")' "$CONFIGPATH/config.json" > "$CONFIGPATH/config.tmp" \
&&  mv "$CONFIGPATH/config.tmp" "$CONFIGPATH/config.json"
fi
if [[ ${DISABLE_UUID_LOGIN+x} && "$DISABLE_UUID_LOGIN" =~ ^(true|false)$ ]]; then
    echo "[INFO] Changing DisableUUIDLogin to: $DISABLE_UUID_LOGIN"
    jq --arg val "$DISABLE_UUID_LOGIN" '.Settings.DisableUUIDLogin = ($val == "true")' "$CONFIGPATH/config.json" > "$CONFIGPATH/config.tmp" \
&&  mv "$CONFIGPATH/config.tmp" "$CONFIGPATH/config.json"
fi
if [[ ${AUTO_SAVE+x} && "$AUTO_SAVE" =~ ^(true|false)$ ]]; then
    echo "[INFO] Changing AutoSave to: $AUTO_SAVE"
    jq --arg val "$AUTO_SAVE" '.Settings.AutoSave = ($val == "true")' "$CONFIGPATH/config.json" > "$CONFIGPATH/config.tmp" \
&&  mv "$CONFIGPATH/config.tmp" "$CONFIGPATH/config.json"
fi

# Parameters sscconfig.json:
if [[ ${SSC_ENABLED+x} && "$SSC_ENABLED" =~ ^(true|false)$ ]]; then
    echo "[INFO] Changing sscconfig.json Enabled to: $SSC_ENABLED"
    jq --arg val "$SSC_ENABLED" '.Settings.Enabled = ($val == "true")' "$CONFIGPATH/sscconfig.json" > "$CONFIGPATH/sscconfig.tmp" \
&&  mv "$CONFIGPATH/sscconfig.tmp" "$CONFIGPATH/sscconfig.json"
fi
if [[ ${SSC_SAVE+x} && "$SSC_SAVE" =~ ^[0-9]+$ ]]; then
    echo "[INFO] Changing ServerSideCharacterSave to: $SSC_SAVE"
    jq --arg val "$SSC_SAVE" '.Settings.ServerSideCharacterSave = ($val | tonumber)' "$CONFIGPATH/sscconfig.json" > "$CONFIGPATH/sscconfig.tmp" \
&&  mv "$CONFIGPATH/sscconfig.tmp" "$CONFIGPATH/sscconfig.json"
fi
if [[ ${PLAYER_APPEARANCE+x} && "$PLAYER_APPEARANCE" =~ ^(true|false)$ ]]; then
    echo "[INFO] Changing KeepPlayerAppearance to: $PLAYER_APPEARANCE"
    jq --arg val "$PLAYER_APPEARANCE" '.Settings.KeepPlayerAppearance = ($val == "true")' "$CONFIGPATH/sscconfig.json" > "$CONFIGPATH/sscconfig.tmp" \
&&  mv "$CONFIGPATH/sscconfig.tmp" "$CONFIGPATH/sscconfig.json"
fi

# Adds items to the Inventory for new players when SSC is enabled.
if [[ -n "$STARTINGINVENTORY" ]]; then
    if [[ "$STARTINGINVENTORY" == "true" ]]; then
        echo "[INFO] STARTINGINVENTORY is 'true'. Applying default items..."
        STARTINGINVENTORY="282,0,99,false:292,0,99,false:285,0,1,false:3199,0,1,false:4711,0,1,false"

    # Checks if the instruction is a removal instruction (Ex: remove:3199)
    elif [[ "$STARTINGINVENTORY" =~ ^remove:[0-9]+$ ]]; then
        REMOVE_ID="${STARTINGINVENTORY#remove:}"
        echo "[INFO] Removal request detected for Item ID: $REMOVE_ID."

        # Remove the item directly from the JSON using the jq select.
        if jq --arg id "$REMOVE_ID" '.Settings.StartingInventory |= map(select(.netID != ($id | tonumber)))' "$CONFIGPATH/sscconfig.json" > "$CONFIGPATH/sscconfig.tmp"; then
            mv "$CONFIGPATH/sscconfig.tmp" "$CONFIGPATH/sscconfig.json"
            echo "[INFO] Item $REMOVE_ID successfully removed from starting inventory."
        else
            echo "[ERROR] Failed to remove item via jq."
        fi
        # Clear the variable to prevent it from being processed in the ADDITION operation below.
        STARTINGINVENTORY=""

    # Regex: It requires 4 parameters separated by commas and mandates that the last one be either true or false.
    elif [[ "$STARTINGINVENTORY" =~ ^([-0-9]+,[0-9]+,[0-9]+,(true|false))(:[-0-9]+,[0-9]+,[0-9]+,(true|false))*$ ]]; then
        echo "[INFO] Custom STARTINGINVENTORY detected. Validating list..."
    else
        echo -e "[WARNING] Environment STARTINGINVENTORY wrongly defined.\n[WARNING] Format: 'true', 'remove:ID' or 'ID,Prefix,Stack,Favorited'.\n[WARNING] Ignoring..."
        STARTINGINVENTORY=""
    fi

    # ADDITION block (only runs if STARTINGINVENTORY still has content and is not a removal block)
    if [[ -n "$STARTINGINVENTORY" ]]; then
        # jq reads the raw string, splits it along the ':' and ',', and assembles the JSON array perfectly.
        NEW_ITEMS=$(jq -n -c --arg raw "$STARTINGINVENTORY" '
          [
            $raw | split(":")[] | split(",") | 
            {
              "netID": .[0] | tonumber,
              "prefix": .[1] | tonumber,
              "stack": .[2] | tonumber,
              "favorited": (.[3] == "true")
            }
          ] | unique_by(.netID)
        ')

        # The inventory is merged with the new items; the `unique_by` parameter ensures there are no duplicates.
        if jq --argjson newItems "$NEW_ITEMS" '.Settings.StartingInventory = (.Settings.StartingInventory + $newItems | unique_by(.netID))' "$CONFIGPATH/sscconfig.json" > "$CONFIGPATH/sscconfig.tmp"; then
            mv "$CONFIGPATH/sscconfig.tmp" "$CONFIGPATH/sscconfig.json"
            echo "[INFO] Items successfully added to starting inventory."
        else
            echo "[ERROR] Failed to inject Starting Inventory via jq."
        fi
    fi
fi

# Define the World filename if it does not exist or is invalid:
 # - Store all matching .wld (map files) paths into an array
 # - If a World file exists, use the name of the existing file.
 # - If WORLD_FILE and the world file do not exist, use the default.
 # - Format the string, lowercase - spaces to underscores - Removes special characters.
 # - Ensures it ends in .wld - without duplicating if it already exists.
echo -e "[INFO] Analyzing the World file name..."
FILE_PATH=( "$WORLDPATH"/*.wld )
if [[ -f "${FILE_PATH[0]}" ]]; then
    WORLD_FILE="${FILE_PATH[0]##*/}"

elif [[ -z "$WORLD_FILE" ]]; then
    WORLD_FILE="${WORLD_NAME:-terraria_world}"

fi
WORLD_FILE="${WORLD_FILE,,}"
WORLD_FILE="${WORLD_FILE// /_}"
WORLD_FILE="${WORLD_FILE//[^a-z0-9_.-]/}"
if [[ "$WORLD_FILE" != *.wld ]]; then
    WORLD_FILE="${WORLD_FILE}.wld"
fi
echo -e "[INFO] World name: $WORLD_NAME\n[INFO] World file: $WORLD_FILE"

# Check if the world file exist, if not, create a new world.
ARGS=()
if [[ -f "${FILE_PATH[0]}" ]]; then
	echo "[INFO] World found in: ${FILE_PATH[0]}"
	ARGS+=("-world" "${FILE_PATH[0]}")
else
    echo "[INFO] World not found in $WORLDPATH/$WORLD_FILE. Creating a new world..."
	if [[ ! "$AUTO_CREATE" =~ ^(1|2|3)$ ]]; then
		echo -e "[INFO] AUTO_CREATE not defined or value incorrect, use 1, 2, or 3.\n[INFO] Set to: 1 (small world)."
		AUTO_CREATE="1"
	fi
    ARGS+=("-autocreate" "$AUTO_CREATE" "-world" "$WORLDPATH/$WORLD_FILE")
	if [[ ${DIFFICULTY+x} && "$DIFFICULTY" =~ ^[0-3]$ ]]; then
    	echo "[INFO] Applying difficulty: $DIFFICULTY"
    	ARGS+=("-difficulty" "$DIFFICULTY")
	fi
	if [[ ${WORLD_EVIL+x} && "$WORLD_EVIL" =~ ^(random|corrupt|crimson)$ ]]; then
	    echo "[INFO] World evil state set to: $WORLD_EVIL"
        ARGS+=("-worldevil" "$WORLD_EVIL")
    fi
    if [[ ${SEED+x} ]]; then
		echo "[INFO] Seed detected: $SEED"
        ARGS+=("-seed" "$SEED")
    fi
fi

# Common parameters:
ARGS+=("-noupnp" "-nosplash" "-forceunicode")
if [[ -n "$WORLD_NAME" ]]; then
	echo "[INFO] World name set to: $WORLD_NAME"
    ARGS+=("-worldname" "$WORLD_NAME")
fi
ARGS+=("-configpath" "$CONFIGPATH" "-logpath" "$LOGPATH" "-crashdir" "$CRASHDIR" "-additionalplugins" "$ADDITIONALPLUGINS")

# Check for optional parameters:
if [[ "$FORCE_UPDATE" == "true" ]]; then
	echo "[INFO] Applying -forceupdate flag."
	ARGS+=("-forceupdate")
fi
if [[ -n "$MOTD" ]]; then
	echo "[INFO] Message of the day will be changed to: $MOTD"
	ARGS+=("-motd" "$MOTD")
fi
if [[ "$SECURE" == "true" ]]; then
    echo "[INFO] Applying -secure flag."
	ARGS+=("-secure")
fi
if [[ "$LANG" =~ ^(en-US|de-DE|it-IT|fr-FR|es-ES|ru-RU|zh-Hans|pt-BR|pl-PL)$ ]]; then
	echo "[INFO] Server language will be changed to: $LANG"
	ARGS+=("-lang" "$LANG")
fi

# Redirects ServerLog.txt to the logs folder:
rm -f "$WDIR/ServerLog.txt"
ln -s "$LOGPATH/ServerLog.txt" "$WDIR/ServerLog.txt"
echo "[INFO] Symbolic link created: ServerLog.txt -> $LOGPATH/ServerLog.txt"

echo "[INFO] Arguments: ${ARGS[@]}"

echo -e "[INFO] World Settings for $WORLD_NAME ($WORLD_FILE) is ready."
echo -e "[INFO] Loading world......\n"

# Run TShock with the pipe:
#exec ./TShock.Server "${ARGS[@]}" < "$PIPE" &
exec env DOTNET_ROLL_FORWARD=LatestMajor ./TShock.Server "${ARGS[@]}" < "$PIPE" &
child=$!

echo -e "--- Server launched with PID: $child ---\n" 

# Wait for process:
wait "$child"

sleep 1