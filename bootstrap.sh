#!/bin/bash
export HAB_LICENSE="accept-no-persist"

if [ ! -e "/bin/hab" ]; then
  curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
fi

if grep "^hab:" /etc/passwd > /dev/null; then
  echo "Hab user exists"
else
  useradd hab && true
fi

if grep "^hab:" /etc/group > /dev/null; then
  echo "Hab group exists"
else
  groupadd hab && true
fi

# fix for https://github.com/habitat-sh/habitat/issues/6771
hab pkg install core/hab-studio/0.83.0

pkg_origin=$1
pkg_name=$2

echo "Starting $pkg_origin/$pkg_name"

latest_hart_file=$(ls -la /tmp/results/$pkg_origin-$pkg_name* | tail -n 1 | cut -d " " -f 10)
echo "Latest hart file is $latest_hart_file"

echo "Installing $latest_hart_file"
hab pkg install $latest_hart_file

echo "Determing pkg_prefix for $latest_hart_file"
pkg_prefix=$(find /hab/pkgs/$pkg_origin/$pkg_name -maxdepth 2 -mindepth 2 | sort | tail -n 1)

echo "Found $pkg_prefix"

NODE_NAME=$(hostname)

# Create client.rb
FILE=/etc/chef/client.rb
if [ ! -f "$FILE" ]; then
  /bin/echo 'log_location     STDOUT' >> /etc/chef/client.rb
  /bin/echo -e "chef_server_url  \"https://api.chef.io/organizations/migration666\"" >> /etc/chef/client.rb
  /bin/echo -e "validation_client_name \"migration666-validator\"" >> /etc/chef/client.rb
  /bin/echo -e "validation_key \"/etc/chef/migration666-validator.pem\"" >> /etc/chef/client.rb
  /bin/echo -e "node_name  \"${NODE_NAME}\"" >> /etc/chef/client.rb
fi

echo "Running chef for $pkg_origin/$pkg_name"
cd $pkg_prefix
hab pkg exec $pkg_origin/$pkg_name chef-client
