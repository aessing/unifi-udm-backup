# =============================================================================
# Dockerfile
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
# Get the base Linux image
#
FROM arm64v8/ubuntu:latest
ARG ARCH=arm64v8


###############################################################################
#
# Set parameters
#

# SETUP ENVS FOR FTP CONNECTION
ENV FTP_SERVER=''
ENV FTP_PATH=''
ENV FTP_USER=''
ENV FTP_PASSWORD=''

# SETUP PATH ENVS FOR UNIFI BACKUPS
ENV UNIFI_BACKUPS='/backups'
ENV UNIFI_NETWORK_BACKUPS='/backups/unifi'
ENV UNIFI_PROTECT_BACKUPS='/backups/protect'

# TELL THE OS IT IS HEADLESS
ENV DEBIAN_FRONTEND=noninteractive 

# SET MOUNTPOINTS
VOLUME ${UNIFI_NETWORK_BACKUPS}
VOLUME ${UNIFI_PROTECT_BACKUPS}


###############################################################################
#
# Update Linux and install necessary packages
#

# UPDATE LINUX
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y apt-utils 
RUN apt-get upgrade -y

# INSTALL PACKAGES
RUN apt-get install --no-install-recommends -y lftp ca-certificates

# CLEAN UP
RUN apt autoremove -y
RUN apt autoclean -y


###############################################################################
#
# Copy files
#

# COPY STARTUP SCRIPT
COPY startup.sh /startup.sh
RUN chmod a+x /startup.sh


###############################################################################
#
# Start FTP copy process
#

WORKDIR /
ENTRYPOINT [ "./startup.sh" ]


###############################################################################
#EOF