#!/usr/bin/env ash

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
find /var/lib/bareos ! -user bareos -exec chown bareos {} \;
find "${bareos_sd_config_dir}" ! -user bareos -exec chown bareos {} \;
find /dev -regex "/dev/[n]?st[0-9]+" ! -user bareos -exec chown bareos {} \;
find /dev -regex "/dev/tape/.*" ! -user bareos -exec chown bareos {} \;

# Run Dockerfile CMD
exec "$@"
