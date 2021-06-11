class Account(object):
	num accounts = 0
	def __init__(self, name, balance):
		self.name = name
		self.balance = balance
		Account.num_accounts += 1
	def __del__(self):
		Account.num_accounts -= 1
	...

