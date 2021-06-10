# 在爬取网站之前，需要对目标站点的规模和结构进行一定了解。
# 网站自身的robots.txt和Sitemap文件可以提供帮助

1.检查roboots.txt文件 
https://www.baidu.com/roboots.txt 

2.检查网站地图
# 网站提供的Sitemap文件可以帮助爬虫定位最新的内容，而无须爬取每一个网页
http://www.sitemaps.org/protocol.html

3.估算网站大小
http://www.google.com/advanced_search

4.识别网站所用技术
detectem模块

该模块需要python3.5+环境以及Docker
安装完成docker之后
docker pull scrapinghub/splash
pip install detectem 
$ det http://example.python-scraping.com
[('jquery', '1.11.0')]

docker pull wappalyzer/cli
docker run wappalyzer/cli http://example.python-scraping.com
可以通过json解析，查看到包含的很多库信息

5.寻找网站所有者
# 查看网站的所有者是谁
pip install python-whois
>>> import whois 
>>> print(whois.whois('appspot.com'))
{
  "domain_name": [
    "GOOGLE.COM",
    "google.com"
  ],
  "registrar": "MarkMonitor, Inc.",
  "whois_server": "whois.markmonitor.com",
  "referral_url": null,
  "updated_date": [
    "2019-09-09 15:39:04",
    "2019-09-09 08:39:04-07:00"
  ],
  "creation_date": [
    "1997-09-15 04:00:00",
    "1997-09-15 00:00:00-07:00"
  ],
  "expiration_date": [
    "2028-09-14 04:00:00",
    "2028-09-13 00:00:00-07:00"
  ],
  "name_servers": [
    "NS1.GOOGLE.COM",
    "NS2.GOOGLE.COM",
    "NS3.GOOGLE.COM",
    "NS4.GOOGLE.COM",
    "ns1.google.com",
    "ns2.google.com",
    "ns3.google.com",
    "ns4.google.com"
  ],
  "status": [
    "clientDeleteProhibited https://icann.org/epp#clientDeleteProhibited",
    "clientTransferProhibited https://icann.org/epp#clientTransferProhibited",
    "clientUpdateProhibited https://icann.org/epp#clientUpdateProhibited",
    "serverDeleteProhibited https://icann.org/epp#serverDeleteProhibited",
    "serverTransferProhibited https://icann.org/epp#serverTransferProhibited",
    "serverUpdateProhibited https://icann.org/epp#serverUpdateProhibited",
    "clientUpdateProhibited (https://www.icann.org/epp#clientUpdateProhibited)",
    "clientTransferProhibited (https://www.icann.org/epp#clientTransferProhibited)",
    "clientDeleteProhibited (https://www.icann.org/epp#clientDeleteProhibited)",
    "serverUpdateProhibited (https://www.icann.org/epp#serverUpdateProhibited)",
    "serverTransferProhibited (https://www.icann.org/epp#serverTransferProhibited)",
    "serverDeleteProhibited (https://www.icann.org/epp#serverDeleteProhibited)"
  ],
  "emails": [
    "abusecomplaints@markmonitor.com",
    "whoisrequest@markmonitor.com"
  ],
  "dnssec": "unsigned",
  "name": null,
  "org": "Google LLC",
  "address": null,
  "city": null,
  "state": "CA",
  "zipcode": null,
  "country": "US"
}


