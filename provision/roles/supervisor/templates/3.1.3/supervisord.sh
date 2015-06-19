#!/bin/sh
#
# /etc/rc.d/init.d/supervisord
#
# Supervisor is a client/server system that
# allows its users to monitor and control a
# number of processes on UNIX-like operating
# systems.
#
# chkconfig: - 64 36
# description: Supervisor Server
# processname: supervisord

. /etc/init.d/functions

DAEMON=/usr/bin/supervisord
PIDFILE=/var/run/supervisord.pid

[ -x "$DAEMON" ] || exit 0

start() {
        echo -n "Starting supervisord: "
        if [ -f $PIDFILE ]; then
                PID=`cat $PIDFILE`
                echo supervisord already running: $PID
                exit 2;
        else
                daemon  $DAEMON --pidfile=$PIDFILE -c /etc/supervisord.conf
                RETVAL=$?
                echo
                [ $RETVAL -eq 0 ] && touch /var/lock/subsys/supervisord
                return $RETVAL
        fi

}

stop() {
        echo -n "Shutting down supervisord: "
        echo
        killproc -p $PIDFILE supervisord
        echo
        rm -f /var/lock/subsys/supervisord
        return 0
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status supervisord
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage:  {start|stop|status|restart}"
        exit 1
        ;;
esac
exit $?