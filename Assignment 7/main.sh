#!/bin/bash
#Filename: main.sh
#Author:  MrSquid
#Purpose: Cipher or Decipher a selected shellcode 

shellcode="\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"; #Execve-nasm shellcode. Introduce whatever shellcode you want

echo "[+] Shellcode introduced: " $shellcode #Original shellcode is printed
echo ""
cp aes_shellcode_cipher.py temp1.py  #The original cipher is copied 

replace "string_to_be_replaced" "$shellcode" -- temp1.py &>/dev/null #The string "string_to_be_replaced" is substitued with the shellcode 

echo "[+] Ciphering the shellcode..."
sleep 2
output=$(python temp1.py) #The cipher shellcode is saved on this variable

rm temp1.py 

echo "" 
echo "[+] Ciphered shellcode: " $output #Encrypted shellcode is printed

cp aes_shellcode_decipher.py temp2.py #We do the same with the decipher phase. Copy the main script

replace "string_to_be_replaced" "$output" -- temp2.py &>/dev/null #he string "string_to_be_replaced" is substitued with the encrypted shellcode 
echo ""
echo "[+] Deciphering the shellcode..."
sleep 2
output2=$(python temp2.py) #The decipher shellcode is saved on this variable

rm temp2.py 

echo "" 
echo "[+] Deciphered shellcode: " $output2 #The shellcode encrypted is printed after deciphering 
