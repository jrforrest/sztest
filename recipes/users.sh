# Create devs group
if ! grep -q "^devs" /etc/group; then
  groupadd devs
fi

# Ensure app user present
if ! id -u <%= @attributes.app_name %> >/dev/null; then
  useradd --create-home --shell /bin/bash --user-group <%= @attributes.app_name %>
fi

for key in `ls files/pubkeys/*.pub`; do
  user=`basename -s .pub $key` 

  #  if user does not exist, create him
  if ! id -u $user > /dev/null; then
    useradd --create-home --shell /bin/bash --user-group --groups devs $user
  fi
  
  sshdir=/home/$user/.ssh
  keysfile=${sshdir}/authorized_keys
    
  [ ! -d $sshdir ] && mkdir -p $sshdir
  if ! grep -q "`cat $key`" $keysfile; then
    cat $key >> $keysfile
  fi

  chmod 700 $sshdir
  chmod 600 $keysfile
  chown -R $user:$user $sshdir
  echo chown -R $user:$user $sshdir
done
