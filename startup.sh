#! /bin/sh

# =============================================================================
# Entrypoint Script
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


###############################################################################
#
# Use lftp to mirror local mounted backup directory to external FTP server
#

echo ""
echo "============================================================================="
echo "$(date)"
echo "Starting backtup to:"
echo " - FTP Server: ${FTP_SERVER}"
echo " - FTP Path: ${FTP_PATH}"
echo " - FTP User: ${FTP_USER}"
echo "-----------------------------------------------------------------------------"
echo ""
/usr/bin/lftp -e "set ssl:verify-certificate no;mirror --overwrite --no-perms --no-umask --no-symlinks -R $UNIFI_BACKUPS $FTP_PATH;exit" -u $FTP_USER,$FTP_PASSWORD $FTP_SERVER
echo ""
echo " - done"
echo "============================================================================="
echo ""


###############################################################################
#EOF
