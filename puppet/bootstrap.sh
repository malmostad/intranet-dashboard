#!/usr/bin/env bash
#
# Bootstraps Puppet on Ubuntu 16.04
#
set -e

# Silence locale warnings during provisioning
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8

# Load up the release information
. /etc/lsb-release

DEB_FILE="puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb"

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Install the PuppetLabs repo
echo "Configuring PuppetLabs repo..."
wget http://apt.puppetlabs.com/${DEB_FILE} >/dev/null 2>&1
dpkg -i ${DEB_FILE}
rm ${DEB_FILE}
apt-get update >/dev/null

# Install Puppet
echo "Installing Puppet..."
apt-get install -y puppet >/dev/null
# puppet resource package puppet ensure=latest

# Adapt Puppet to it's own requirements ...
touch /etc/puppet/hiera.yaml >/dev/null

echo "Installing malmo-mcommons Puppet module"
wget https://github.com/malmostad/puppet-mcommons/archive/v2.0.1.tar.gz -O malmo-mcommons.tar.gz 2>/dev/null
puppet module install malmo-mcommons.tar.gz
# rm malmo-mcommons.tar.gz >/dev/null

# Vagrant uses vagrant.pp for Puppet provisioning
# We use server.pp if we are not in a Vagrant box
if ! [ -e "/vagrant" ]
then
  echo "Starting Puppet provisioning defined in server.pp"
  puppet apply server.pp
fi
