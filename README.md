# Description
Automatically update Plex Media Server on Synology NAS

# How to
Download this script and create it is a Scheduled Task. The script will auto check to see if the current version is not the same as the latest and then proceed to update as needed.

### Setup Download Script
sudo wget https://github.com/nitantsoni/plexupdate/raw/master/plexupdate.sh  

### Setup Update Scheduler
From the Synology Control Panel, open up the Task Scheduler and add a "User-defined script" task  
Set it to execute as "root" & give it a command like so  
`bash /volume1/Scripts/plexupdate.sh`  

Original source found here - https://forums.plex.tv/t/script-to-auto-update-plex-on-synology-nas-rev4/479748/36?u=martino
