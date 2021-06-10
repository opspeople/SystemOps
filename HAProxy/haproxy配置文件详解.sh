# 1.配置文件格式
global
defaults
listen
frontend
backend

# 2.环境变量
# 调用环境变量
bind "fd@${FD_APP1}"
log "${LOCAL_SYSLOG}:514" local0 notice
user "$HAPROXY_USER"

# 环境变量中可以用"_"，但是不能用数字开头。

# 3.时间格式
us 微妙 1 microsecond = 1/1000000 second
ms 毫秒 1 millisecond = 1/1000 second
s 秒 1s = 1000ms
m 分 1m = 60s
h 小时
d 天

# 4.global 参数
	# 4.1 进程管理机安全
   - ca-base
   - chroot
   - crt-base
   - cpu-map
   - daemon
   - description
   - deviceatlas-json-file
   - deviceatlas-log-level
   - deviceatlas-separator
   - deviceatlas-properties-cookie
   - external-check
   - gid
   - group
   - hard-stop-after
   - h1-case-adjust
   - h1-case-adjust-file
   - log
   - log-tag
   - log-send-hostname
   - lua-load
   - lua-prepend-path
   - mworker-max-reloads
   - nbproc
   - nbthread
   - node
   - pidfile
   - presetenv
   - resetenv
   - uid
   - ulimit-n
   - user
   - set-dumpable
   - setenv
   - stats
   - ssl-default-bind-ciphers
   - ssl-default-bind-ciphersuites
   - ssl-default-bind-options
   - ssl-default-server-ciphers
   - ssl-default-server-ciphersuites
   - ssl-default-server-options
   - ssl-dh-param-file
   - ssl-server-verify
   - unix-bind
   - unsetenv
   - 51degrees-data-file
   - 51degrees-property-name-list
   - 51degrees-property-separator
   - 51degrees-cache-size
   - wurfl-data-file
   - wurfl-information-list
   - wurfl-information-list-separator
   - wurfl-cache-size
   - strict-limits
   # 4.2 Performance tuning （性能调优）
      - busy-polling
   - max-spread-checks
   - maxconn
   - maxconnrate
   - maxcomprate
   - maxcompcpuusage
   - maxpipes
   - maxsessrate
   - maxsslconn
   - maxsslrate
   - maxzlibmem
   - noepoll
   - nokqueue
   - noevports
   - nopoll
   - nosplice
   - nogetaddrinfo
   - noreuseport
   - profiling.tasks
   - spread-checks
   - server-state-base
   - server-state-file
   - ssl-engine
   - ssl-mode-async
   - tune.buffers.limit
   - tune.buffers.reserve
   - tune.bufsize
   - tune.chksize
   - tune.comp.maxlevel
   - tune.h2.header-table-size
   - tune.h2.initial-window-size
   - tune.h2.max-concurrent-streams
   - tune.http.cookielen
   - tune.http.logurilen
   - tune.http.maxhdr
   - tune.idletimer
   - tune.lua.forced-yield
   - tune.lua.maxmem
   - tune.lua.session-timeout
   - tune.lua.task-timeout
   - tune.lua.service-timeout
   - tune.maxaccept
   - tune.maxpollevents
   - tune.maxrewrite
   - tune.pattern.cache-size
   - tune.pipesize
   - tune.rcvbuf.client
   - tune.rcvbuf.server
   - tune.recv_enough
   - tune.runqueue-depth
   - tune.sndbuf.client
   - tune.sndbuf.server
   - tune.ssl.cachesize
   - tune.ssl.lifetime
   - tune.ssl.force-private-cache
   - tune.ssl.maxrecord
   - tune.ssl.default-dh-param
   - tune.ssl.ssl-ctx-cache-size
   - tune.ssl.capture-cipherlist-size
   - tune.vars.global-max-size
   - tune.vars.proc-max-size
   - tune.vars.reqres-max-size
   - tune.vars.sess-max-size
   - tune.vars.txn-max-size
   - tune.zlib.memlevel
   - tune.zlib.windowsize

   # 4.3 调试
   - debug
   - quiet
   