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
	cipher_shell = "string_to_be_replaced" #Here, main.sh will inject the encrypted shellcode to be deciphered	
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

