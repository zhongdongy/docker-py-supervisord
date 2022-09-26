#!/usr/bin/bash

if [ -x "/app/customized-scripts/before-startup.sh" ]; then
  echo "Before-startup script found and executable, will proceed."
  /usr/bin/bash -c "/app/customized-scripts/before-startup.sh"
else
  echo "No before-startup script to execute, or not executable"
fi

supervisord -c /etc/supervisor/supervisord.conf
/usr/bin/tail -f /var/log/supervisord/supervisord.log

if [ -x "/app/customized-scripts/after-startup.sh" ]; then
  echo "After-startup script found and executable, will proceed."
  /usr/bin/bash -c "/app/customized-scripts/after-startup.sh"
else
  echo "No after-startup script to execute, or not executable"
fi
