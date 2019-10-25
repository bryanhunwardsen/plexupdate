# Description
Automatically update Plex Media Server on Synology NAS

# How to
Download this script and create it is a Scheduled Task. The script will auto check to see if the current version is lower than the latest and then proceed to update as needed.

This script is configured to use the Public repo. If you'd like to change to the PlexPass repo, update the URL to include your token. `https://plex.tv/api/downloads/5.json?channel=plexpass&X-Plex-Token=<TOKEN HERE>`

### Download Script
SSH in to the NAS and download this script, via a command like `sudo wget https://github.com/nitantsoni/plexupdate/raw/master/plexupdate.sh`  

### Setup Scheduler
From the Synology Control Panel, open up the Task Scheduler and add a "User-defined script" task  
Set it to execute as "root" & give it a command like so  
`bash /volume1/Scripts/plexupdate.sh`  

Original source found here - https://forums.plex.tv/t/script-to-auto-update-plex-on-synology-nas-rev4/479748/36?u=martino
