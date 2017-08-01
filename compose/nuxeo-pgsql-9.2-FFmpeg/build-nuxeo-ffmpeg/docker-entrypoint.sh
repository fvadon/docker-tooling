#!/bin/bash 
set -e


NUXEO_DATA=${NUXEO_DATA:-/var/lib/nuxeo/data}
NUXEO_LOG=${NUXEO_LOG:-/var/log/nuxeo}

NUXEO_MPINSTALL_OPTIONS=${NUXEO_MPINSTALL_OPTIONS:---relax=false}


if [ "$1" = 'nuxeoctl' ]; then
  if [ ! -f $NUXEO_HOME/configured ] || [ -n $NUXEO_FORCE_CONF ]; then
    # Start by the template
    cat /etc/nuxeo/nuxeo.conf.template > $NUXEO_CONF

    # Can't do that at Java level since it's needed in nuxeoctl scripting
    cat << EOF >> $NUXEO_CONF
nuxeo.log.dir=$NUXEO_LOG
nuxeo.pid.dir=/var/run/nuxeo
nuxeo.data.dir=$NUXEO_DATA
EOF

    if [ -n "$NUXEO_CUSTOM_PARAM" ]; then
      printf "%b\n" "$NUXEO_CUSTOM_PARAM" >> $NUXEO_CONF
    fi
    
    # Deprecated since 9.1, put a nuxeo.conf file in /docker-entrypoint-initnuxeo.d instead
    if [ -f /nuxeo.conf ]; then
      cat /nuxeo.conf >> $NUXEO_CONF
    fi    

    if [ -f /docker-entrypoint-initnuxeo.d/nuxeo.conf ]; then
      cat /docker-entrypoint-initnuxeo.d/nuxeo.conf >> $NUXEO_CONF
    fi    
    touch $NUXEO_HOME/configured
  fi

  for f in /docker-entrypoint-initnuxeo.d/*; do
    case "$f" in
      *.sh)  echo "$0: running $f"; . "$f" ;;
      *.zip) echo "$0: installing Nuxeo package $f"; nuxeoctl mp-install $f ${NUXEO_MPINSTALL_OPTIONS} --accept=true ;;
      instance.clid) echo "$0: moving clid to $NUXEO_DATA"; mv $f $NUXEO_DATA/instance.clid ;;      
      *)     echo "$0: ignoring $f" ;;
    esac
  done

  # instance.clid
  if [ -n "$NUXEO_CLID" ]; then
    # Replace --  by a carriage return
    NUXEO_CLID="${NUXEO_CLID/--/\\n}"
    printf "%b\n" "$NUXEO_CLID" >> $NUXEO_DATA/instance.clid
  fi

  ## Executed at each start
  if [ -n "$NUXEO_CLID"  ] && [ ${NUXEO_INSTALL_HOTFIX:='true'} == "true" ]; then
      nuxeoctl mp-hotfix --accept=true
  fi

  # Install packages if exist
  if [ -n "$NUXEO_PACKAGES" ]; then
    nuxeoctl mp-install $NUXEO_PACKAGES $NUXEO_MPINSTALL_OPTIONS --accept=true
  fi

  if [ "$2" = "console" ]; then
    exec nuxeoctl console
  else
    exec "$@"
  fi

fi


exec "$@"
