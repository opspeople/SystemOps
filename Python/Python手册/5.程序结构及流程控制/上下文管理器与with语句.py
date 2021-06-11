with open("debuglog", "a") as f:
	f.write("Degugging\n")
	statements
	f.write("Done\n")

import threading
lock = threading.Lock()
with lock:
	statements