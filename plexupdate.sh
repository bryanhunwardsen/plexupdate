#!/bin/bash

# Script to Auto Update Plex on Synology NAS
# Must be run as root.
# @author Martino https://forums.plex.tv/u/Martino
# @source @martinorob https://github.com/martinorob/plexupdate
# @author @nitantsoni https://github.com/nitantsoni
# @source @martinorob https://github.com/nitantsoni/plexupdate
# @see https://forums.plex.tv/t/script-to-auto-update-plex-on-synology-nas-rev4/479748

CPU=$(uname -m)
mkdir -p /tmp/plex/
cd /tmp/plex/ || echo "Failed to create /tmp/plex/" exit

#echo "PLEXPASS (PREMIUM) Channel"
#@TOKEN=$(cat /volume1/Plex/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml | grep -oP 'PlexOnlineToken="\K[^"]+')
#PMS_PATH=$(find / -path '*/Plex Media Server' -print -quit 2>/dev/null)
#TOKEN=$(grep -Po 'PlexOnlineToken="\K[^"]+' "${PMS_PATH}"/Preferences.xml)
#PACKAGE_URL=$(echo "https://plex.tv/api/downloads/5.json?channel=plexpass&X-Plex-Token=${TOKEN}")

echo "PLEX Public Channel"
PACKAGE_URL="https://plex.tv/api/downloads/5.json"

INSTALLED_VERSION=$(synopkg version "PlexMediaServer" | cut -d"-" -f1);
echo "Installed version: $INSTALLED_VERSION"

JSON=$(curl -s -k $PACKAGE_URL)
# -k
DSM_VER="Synology (DSM 7)"
CURRENT_VERSION=$(echo $JSON | jq -r '.nas."Synology (DSM 7.2.2+)".version' | cut -d"-" -f1);
echo "Current version: $CURRENT_VERSION"

RELEASE_URL=$(echo $JSON | jq -r '.nas."Synology (DSM 7.2.2+)".releases[] | select(.build=="linux-'"$CPU"'") | .url')

if [[ $CURRENT_VERSION > $INSTALLED_VERSION ]] ; then
  # shellcheck disable=SC2016
  PKG_UPDATE="{\"%PKG_HAS_UPDATE%\": \"PlexMediaServer has an update: $CURRENT_VERSION\"}"
  /usr/syno/bin/synonotify PKGHasUpgrade "$PKG_UPDATE"
  echo "PLEX update is downloading..."
  /bin/wget $RELEASE_URL --no-hsts -P /tmp/plex/
  # --no-check-certificate
  echo "PlexMediaServer update is installing..."
  /usr/syno/bin/synopkg install /tmp/plex/*.spk
  echo "PlexMediaServer is restarting..."
  /usr/syno/bin/synopkg start "PlexMediaServer"
  if [ "$?" -ne "0" ]; then
	PKG_FAIL="{\"%PKG_HAS_UPDATE%\": \"PlexMediaServer failed to upgrade/restart: $CURRENT_VERSION\"}"
    /usr/syno/bin/synonotify PKGHasUpgrade "$PKG_FAIL"
    echo "PlexMediaServer failed to upgrade or restart successfully."
  else    
    PKG_UPDATED="{\"%PKG_HAS_UPDATE%\": \"PlexMediaServer has been updated to: $CURRENT_VERSION\"}"
    /usr/syno/bin/synonotify PKGHasUpgrade "$PKG_UPDATED"
    echo "PlexMediaServer restarted after successfully being upgraded."
    echo "Cleaning up PlexMediaServer upgrade artifacts..."
	rm -rf /tmp/plex/
  fi
else
  echo "PlexMediaServer is currently up to date."
fi
echo "Exiting PlexMediaServer update script."
exit

#if [[ "${NEW_VERSION}" > "${CURRENT_VERSION}" ]] ; then
#  # shellcheck disable=SC2016
#  /usr/syno/bin/synonotify PKGHasUpgrade '{"[%HOSTNAME%]": $(hostname), "[%OSNAME%]": "Synology", "[%PKG_HAS_UPDATE%]": "Plex", "[%COMPANY_NAME%]": "Synology"}'
#  /bin/wget $URL2 -P /tmp/plex/
#  /usr/syno/bin/synopkg install /tmp/plex/*.spk
#  /usr/syno/bin/synopkg start "Plex Media Server"
#  rm -rf /tmp/plex/
#
# if [ "$CPU" = "x86_64" ] ; then
#   URL=$(echo $JSON | jq -r ".nas.Synology.releases[1] | .url")
# else
#   URL=$(echo $JSON | jq -r ".nas.Synology.releases[0] | .url")
# fi