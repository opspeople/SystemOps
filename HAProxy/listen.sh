#!/bin/bash
listen fileserver
   mode tcp
   balance     leastconn
   bind 0.0.0.0:31080
   server fileserver01 202.9.34.153:31080 check inter 10000 rise 3 fall 3
   server fileserver02 202.9.34.154:31080 check inter 10000 rise 3 fall 3
   server fileserver03 202.9.34.155:31080 check inter 10000 rise 3 fall 3 