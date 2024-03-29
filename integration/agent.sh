set -e
install() {
    # The agent is only certified with Oracle JDK Version 11
    sudo yum install -y jdk-11
    
    wget https://objectstorage.ap-singapore-1.oraclecloud.com/n/cn9yc2hk0gzg/b/oci-quickstart/o/oic_conn_agent_installer.zip
    unzip oic_conn_agent_installer.zip -d oic_conn_agent_installer
    rm oic_conn_agent_installer.zip
    # 1. Modify property `oic_URL` and `agent_GROUP_IDENTIFIER`
    # 2. Add property `oic_USER` and `oic_PASSWORD`
    vi oic_conn_agent_installer/InstallerProfile.cfg

}
log-dir() {
    cd oic_conn_agent_installer/agenthome/logs
    ll
}

_start() {
    cd oic_conn_agent_installer
    nohup java -jar connectivityagent.jar &>>nohup.out &
    cd -
}

_stop() {
    pid=$(ps -fC "java" | grep "connectivityagent.jar" | awk '{ print $2; }')

    if [ -n "$pid" ]; then
        kill $pid
    fi

}
_restart() {
    _stop
    echo "Waiting for 45 seconds is required before next start..."
    sleep 45
    _start
}

$1
