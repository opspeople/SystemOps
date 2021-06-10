! Configuration File for keepalived
#全局定义块
global_defs {
    #邮件通知配置，用于服务有故障时发送报警邮件，可选配置
   notification_email {
     z0ukun@163.com
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   #通知邮件从哪里发出
   notification_email_from Alexandre.Cassen@firewall.loc
   #通知邮件的SMTP地址
   smtp_server 192.168.200.1
   #连接SMTP服务器的超时时间
   smtp_connect_timeout 30
   # 标识本节点的字符串，通常为hostname，但不一定非得是hostname。故障发生时，邮件通知会用到。
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
   #将严格遵守vrrp协议这一项关闭，否则会因为不是组播而无法启动keepalived
   #vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}
#VRRP实例块
vrrp_instance VI_1 {
    # 标识当前节点的状态，可以是MASTER或BACKUP，当其他节点keepalived启动时会将priority比较大的节点选举为MASTER。
    state MASTER
    # 节点固有IP（非VIP）的网卡，用来发VRRP包
    interface eth0
    # 取值在0-255之间，用来区分多个instance的VRRP组播。同一网段中virtual_router_id的值不能重复，否则会出错。
    virtual_router_id 51
    # 用来选举master的，要成为master，那么这个选项的值最好高于其他机器50个点，该项取值范围是[1-254]（在此范围之外会被识别成默认值100）。
    priority 100
    # 发VRRP包的时间间隔，即多久进行一次master选举（可以认为是健康查检时间间隔）。
    advert_int 1
    # 认证区域，认证类型有PASS和HA（IPSEC），推荐使用PASS（密码只识别前8位）。
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    # 非抢占模式，与state BACKUP 同用
    #nopreempt
   
    #preempt_delay 60s
    # 单播模式，需事先关闭全局 vrrp_strict 选项，否则报错。
    unicast_src_ip 192.168.38.7 # 本机IP
    # 其他keepalived主机IP
    unicast_peer {
              192.168.38.37
   }
    # 允许一个priority比较低的节点作为master，即使有priority更高的节点启动。nopreemt必须在state为BACKUP的节点上才生效（因为是BACKUP节点决定是否来成为MASTER的）。
    nopreempt
    # 启动多久之后进行接管资源（VIP/Route信息等），前提是没有nopreempt选项。
    preempt_delay 300
    #虚拟IP地址
    virtual_ipaddress {
        192.168.200.16
        192.168.200.17
        192.168.200.18
    }
}
virtual_server 192.168.200.100 443 {
    delay_loop 6
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP
    real_server 192.168.201.100 443 {
        weight 1
        SSL_GET {
            url {
              path /
              digest ff20ad2481f97b1754ef3e12ecd3a9cc
            }
            url {
              path /mrtg/
              digest 9b3a0c85a887a256d6939da88aabd8cd
            }
            connect_timeout 3
            retry 3
            delay_before_retry 3
        }
    }
}
#虚拟服务定义块
virtual_server 10.10.10.2 1358 {
    # 延迟轮询时间（单位秒）
    delay_loop 6
    # 后端调试算法
    lb_algo rr
    # LVS调度类型NAT/DR/TUN
    lb_kind NAT
    # NAT掩码
    nat_mask 255.255.255.0
    # 持久化超时时间，保持客户端的请求在这个时间段内全部发到同一个真实服务器，解决客户连接的相关性问题。
    persistence_timeout 50
    # 传输协议
    protocol TCP
    sorry_server 192.168.200.200 1358
    # 真实服务器的地址和端口
    real_server 192.168.200.2 1358 {
        # 权重
        weight 1
        # 设置健康检查方式，可以设置HTTP_GET | SSL_GET
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl3/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            # 超时时间（秒），如果在这个时间内没有返回，则说明一次监测失败
            connect_timeout 3
            # 设置多少次监测失败，就认为这个真实节点死掉了
            retry 3
            # 重试间隔
            delay_before_retry 3
        }
    }
    real_server 192.168.200.3 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334c
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334c
            }
            connect_timeout 3
            retry 3
            delay_before_retry 3
        }
    }
}
virtual_server 10.10.10.3 1358 {
    delay_loop 3
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP
    real_server 192.168.200.4 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl3/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            retry 3
            delay_before_retry 3
        }
    }
    real_server 192.168.200.5 1358 {
        weight 1
        HTTP_GET {
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            url {
              path /testurl3/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            retry 3
            delay_before_retry 3
        }
    }
}