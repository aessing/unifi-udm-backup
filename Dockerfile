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
FROM arm64v8/alpine:latest

###############################################################################
#
# Set some information
#
LABEL tag="aessing/udm-backup-ftp" \
      description="A Docker container which copies automatic backups from the Unifi Dream Machine to a FTP server" \
      disclaimer="THE CONTENT OF THIS REPOSITORY IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE CONTENT OF THIS REPOSITORY OR THE USE OR OTHER DEALINGS BY CONTENT OF THIS REPOSITORY." \
      vendor="Andre Essing" \
      github-repo="https://github.com/aessing/udm-backup-ftp"

###############################################################################
#
# Set some parameters
#
ENV FTP_SERVER=''
ENV FTP_PATH=''
ENV FTP_USER=''
ENV FTP_PASSWORD=''
ENV UNIFI_BACKUPS='/backups'
ENV UNIFI_NETWORK_BACKUPS='/backups/unifi'
ENV UNIFI_PROTECT_BACKUPS='/backups/protect'
VOLUME ${UNIFI_NETWORK_BACKUPS}
VOLUME ${UNIFI_PROTECT_BACKUPS}

###############################################################################
#
# Update Linux and install necessary packages
#
RUN apk -U upgrade && \
    apk add --no-cache ca-certificates \
                       lftp && \
    rm -rf /var/cache/apk/*

###############################################################################
#
# Copy files
#
COPY startup.sh /startup.sh
RUN chmod a+x /startup.sh

###############################################################################
#
# Create and run in non-root context
#
RUN groupadd -r -g 1001 backupuser && useradd --no-log-init -r -u 1001 -g backupuser backupuser
USER backupuser

###############################################################################
#
# Start FTP copy process
#
WORKDIR /
ENTRYPOINT [ "./startup.sh" ]

###############################################################################
#EOF