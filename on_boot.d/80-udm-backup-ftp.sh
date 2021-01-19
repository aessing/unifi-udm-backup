#!/bin/sh

# =============================================================================
# on-boot-script
# (https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script)
# Unifi Dream Machine Backup to FTP
# https://github.com/aessing/udm-backup-ftp
# -----------------------------------------------------------------------------
# Developer.......: Andre Essing (https://www.andre-essing.de/)
#                                (https://github.com/aessing)
#                                (https://twitter.com/aessing)
#                                (https://www.linkedin.com/in/aessing/)
# -----------------------------------------------------------------------------
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
# =============================================================================

echo ""
echo "------------------------------------------------------------"
echo " Configure scheduled copy of backups to external FTP server"
echo "------------------------------------------------------------"


FTP_SERVER={SERVERNAME}
FTP_PATH={BACKUPPATH}
FTP_USER={FTPUSER}
FTP_PASSWORD={FTPPASSWORD}

CRON_FILE='/etc/cron.d/udm-backup-ftp'
CRON_SCHEDULE='30 * * * *'


SDN_MOUNT="/mnt/data/unifi-os/unifi/data/backup/autobackup:/backups/unifi:ro"
# you can comment next line to disable protect backup (or if protect is disabled on your UDM)
PROTECT_MOUNT="/mnt/data_ext/unifi-os/unifi-protect/backups:/backups/protect:ro"

CRON_CMD="${CRON_SCHEDULE} podman run -it --rm --name UDM-FTP-Backup --network=host -e \"FTP_SERVER=$FTP_SERVER\" -e \"FTP_PATH=$FTP_PATH\" -e \"FTP_USER=$FTP_USER\" -e \"FTP_PASSWORD=$FTP_PASSWORD\""
BACKUP_IMG='docker.io/aessing/udm-backup-ftp'



if [ ! -z "${SDN_MOUNT}" ]; then
    CRON_CMD="${CRON_CMD} -v \"$SDN_MOUNT\""
fi

if [ ! -z "${PROTECT_MOUNT}" ]; then
    CRON_CMD="${CRON_CMD} -v \"$PROTECT_MOUNT\""
fi

CRON_CMD="${CRON_CMD} ${BACKUP_IMG}"

if [ ! -f "${CRON_FILE}" ]; then
    echo "${CRON_CMD}" > ${CRON_FILE}
    chmod 644 ${CRON_FILE}
    /etc/init.d/crond reload ${CRON_FILE}
fi

echo " - done"
echo ""
