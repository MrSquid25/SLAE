import sys

if __name__ == "__main__":
	print "[*] Usage: python bind_shell.py PORT_NUMBER\n"
	print "[*] Example: python bind_shell.py 8888\n"
	try:
		lport = int(sys.argv[1]) #sys.argv[0] is filename
		if lport <= 1024:	
			print "Port number must be greater than 1024 (root privileges needed instead)"
		elif (1024<lport and lport<=65535):
			main()
		else:
			print "Port number must be between 1024 and 65535 NOOB!"
	except (IndexError, ValueError): 
		print "Introduce the port!"
		print "Quitting!"
