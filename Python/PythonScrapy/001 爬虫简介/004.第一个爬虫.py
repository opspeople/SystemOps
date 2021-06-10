#!/usr/bin/python3
# 为了爬取网站，我们首先需要下载包含有感兴趣数据的网页，该过程一般称为爬取(crawling)
# 爬取网站的常见方法：
	# 爬取网站地图
	# 使用数据库ID遍历每个网页
	# 跟踪网页链接
# 001 抓取和爬取对比
	# 抓取 指针对特定网站，并在这些站点上获取指定信息。
	# 网络抓取用于访问这些特定的页面，如果站点发生变化或者站点中的信息位置发生变化的话，需要进行修改

	# 爬取 以通用的方式构建，目标是一系列顶级域名的网站或是整个网络。
	# 爬取可以用来收集具体的信息，不过更常见的是爬取网络，从许多不同的站点或页面中获取小而通用的信息，然后跟踪链接到其他页面中。


# 002 下载网页
# 使用 urllib 模块
import urllib.request
def download(url):
	return urllib.request.urlopen(url).read()

# 上面脚本不具备处理异常的能力
import urllib.request
from urllib.error import URLError, HTTPError, ContentTooShortError

def download(url):
	print('Downloading:', url)
	try:
		html = urllib.request.urlopen(url).read()
	except (URLError, HTTPError, ContentTooShortError) as e:
		print('Download error:', e.reason)
		html = None
	return html

# 重试下载
# 下载时遇到错误时临时性的。
def download(url, num_retries=2):
	print('Downloading:', url)
	try:
		html = urllib.request.urlopen(url).read()
	except (URLError, HTTPError, ContentTooShortError) as e:
		print('Download error:', e.reason)
		html = None
		if num_retries > 0:
			if hasattr(e, 'code') and 500 <= e.code < 600:
				# recursively retry 5xx HTTP errors
				return download(url, num_retries - 1 )
	return html

# 设置用户代理
def download(url, user_agent='wswp', num_retries=2):
	print('Downloading:', url)
	request = urllib.request.Request(url)
	request.add_header('User-agent', user_agent)
	try:
		html = urllib.request.urlopen(url).read()
	except (URLError, HTTPError, ContentTooShortError) as e:
		print('Download error:', e.reason)
		html = None
		if num_retries > 0:
			if hasattr(e, 'code') and 500 <= e.code < 600:
				# recursively retry 5xx HTTP errors
				return download(url, num_retries - 1 )
	return html

# 网站地图爬虫
import re 

def download(url, user_agent='wswp', num_retries=2, charset='utf-8'):
	print('Downloading:', url)
	request = urllib.request.Request(url)
	request.add_header('User-agent', user_agent)
	try:
		resp = urllib.request.urlopen(request)
		cs = resp.headers.get_content_charset()
		if not cs:
			cs = charset
		html = resp.read().decode(cs)
	except (URLError, HTTPError, ContentTooShortError) as e:
		print('Download error:', e.reason)
		html = None
		if num_retries > 0:
			if hasattr(e, 'code') and 500 <= e.code < 600:
				# recursively retry 5xx HTTP errors
				return download(url, num_retries - 1 )
	return html


def crawl_sitemap(url):
	# download the sitemap file
	sitemap = download(url)
	# extract the sitemap links
	links = re.findall('<loc>(.*?)</loc>', sitemap)
	# download each link
	for link in links:
		html = download(link)
		# scrape html here
		# ...

# ID遍历爬虫
import itertools

def crawl_site(url, max_errors=5):
	for page in itertools.count(1):
		pg_url = '{}{}'.format(url, page)
		html = download(pg_url)
		if html is None:
			num_errors += 1
			if num_errors == max_errors:
				break
				# success - can scrape the result
			else:
				num_errors = 0
				# success - can scrape the result
				