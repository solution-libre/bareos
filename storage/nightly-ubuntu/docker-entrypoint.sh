#!/usr/bin/env bash

bareos_sd_config_dir='/etc/bareos/bareos-sd.d'
bareos_sd_config="${bareos_sd_config_dir}/director/bareos-dir.conf"
control_file="${bareos_sd_config_dir}/bareos-config.control"

if [ ! -f "${control_file}" ]; then
  tar xfz /bareos-sd.tgz --backup=simple --suffix=.before-control

  # Update bareos-storage configs
  sed -i 's#Password = .*#Password = '\""${BAREOS_SD_PASSWORD}"\"'#' $bareos_sd_config

  # Control file
  touch "${control_file}"
fi

# Fix permissions
find "${bareos_sd_config_dir}" ! -user bareos -exec chown bareos {} \;
chown -R bareos /var/lib/bareos /dev/[n]st* /dev/tape

# Run Dockerfile CMD
exec "$@"
