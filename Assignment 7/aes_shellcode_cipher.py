#!/usr/bin/python

#Filename: aes_shellcode_cipher.py 
#Author:  MrSquid
#Purpose: Aes shellcode cipher


from Crypto.Cipher import AES
import base64

BS = 16
pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS) 
unpad = lambda s : s[0:-ord(s[-1])]

def cipher_message(key, message, iv): #Cipher function
	message=pad(message) #Add padding to the message
	key = base64.b64decode(key) #Decode Key
	obj = AES.new(key, AES.MODE_CBC, iv)
	ciphertext = obj.encrypt(message)
	#ciphertext = base64.b64encode(ciphertext)
	ciphertext = ciphertext.encode("hex")
	return ciphertext

def main():
	iv= "166fe2294df5d0f3"
	key= "N2FlMjE4ZmYyOTI4ZjZiMg==" #Key length must be 24 due to AES-192
	shell_to_cipher = "string_to_be_replaced" #Here, main.sh will inject the shellcode to cipher
	shellcode = ""	
	for x in bytearray(shell_to_cipher): #Shellcode format is set to string --> \x32 is set as x32 for example 
		shellcode += 'x'
		shellcode += '%02x' % x
	cipher_shellcode = cipher_message(key,shellcode,iv) #Cipher_message output is set to cipher_shellcode
	byte_shell = "" 
	counter = 0
	var = ""
	for x in cipher_shellcode: #Cipher shell format is set to byte format 
		var += x
		counter += 1
		if counter == 2:
			byte_shell += "\\x"
			byte_shell += var
			var = ""
			counter = 0
	return byte_shell 

if __name__ == "__main__":
	print main()	

