#!/bin/bash


get_arg() {
  str="$1"
  i="$2"
  IFS="$3"

  read -d '' -ra array <<< "$str"
  echo "${array[i]}"
}

kill_process() {
  target="$1"
  mapfile -t l < <(ps -e -o pid,comm | grep ${target})
  pid=$(get_arg "${l[0]}" 0 ' ')
  if [[ $pid != "" ]]; then
    kill -KILL ${pid}
    echo "Killed existing ${target} process"
  fi
}


# Load config file
text=$(<config)
IFS=$'\n' read -d '' -ra lines <<< "$text"

testserver_addr="$(get_arg ${lines[0]} 1 ';')"
testserver_pem="$(get_arg ${lines[0]} 2 ';')"
liveserver_addr="$(get_arg ${lines[1]} 1 ';')"
liveserver_pem="$(get_arg ${lines[1]} 2 ';')"
repo_addr="$(get_arg ${lines[2]} 1 ';')"
port="$(get_arg ${lines[3]} 1 ';')"

SSH_DEP_SETUP='
echo "Installing/updating dependencies"
sudo apt install -y git
sudo apt install -y build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup_install_script
sh rustup_install_script -y
rm rustup_install_script
source ~/.cargo/env
rustup default nightly '


read -d '' -r SSH_WEBSERVER_SETUP <<EOF
echo "Installing/updating RTServer"
mkdir -p server && cd server
ls | grep -q RTServer
if [[ \$? == 1 ]]; then
  git clone "$repo_addr"
fi
cd RTServer
git_res="\$(git pull)"
if [[ "\$git_res" == "Already up to date." ]]; then
  echo "No updates to repo"
  #TODO: add options for aborting the script, or skipping to test live server
fi
EOF

read -d '' -r SSH_RUN_WEBSERVER <<EOF
$(declare -f get_arg)
$(declare -f kill_process)
kill_process "RTServer"
cargo_path="\$HOME/.cargo/bin/cargo"
cd \$HOME/server/RTServer/RTServer
cargo_build=\$(\${cargo_path} build)
nohup "\${cargo_path}" run >/dev/null 2>&1 &
EOF

read -d '' -r SSH_TEST_WEBSERVER <<EOF
sleep 1
curl -s localhost:$port > curl_res
res=\$(diff data/RT_talents.txt curl_res)
rm curl_res
if [[ \$res == "" ]]; then
  # echo "Test succesful, webserver ready for live deployment"
  echo "TEST_STATUS=OK"
else
  echo "TEST_STATUS=FAILED"
fi
EOF

# Run update on test server
flag=$(ssh "admin@${testserver_addr}" -i "${testserver_pem}" /bin/bash <<EOF | tee /dev/stderr | grep "TEST_STATUS=" | cut -d= -f2
$SSH_DEP_SETUP
$SSH_WEBSERVER_SETUP
$SSH_TEST_WEBSERVER
echo end
EOF
)

if [[ ${flag} == "OK" ]]; then
  echo "Tests succesfull on test machine, deploying on live server"
else
  echo "Tests failed on test machine, exiting"
  exit
fi

ssh "admin@${liveserver_addr}" -i "${liveserver_pem}" /bin/bash <<EOF
cd \$HOME/server/RTServer
echo "Updating systemctl webserver.service"
sudo systemctl stop webserver.service
sudo cp webserver.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now webserver-service
system status webserver.service
$SSH_DEP_SETUP
$SSH_WEBSERVER_SETUP
$SSH_RUN_WEBSERVER
$SSH_TEST_WEBSERVER
EOF

