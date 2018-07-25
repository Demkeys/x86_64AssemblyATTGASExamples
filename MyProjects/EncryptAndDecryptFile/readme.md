# Encrypt and Decrypt files
These are two programs I wrote to Encrypt and Decrypt files using a (max. 8 character) pass key.
Both programs are written in x86_64 Assembly using AT&T GAS syntax. Also, both programs only use System Calls.

_DISCLAIMER: This is not necessarily example code. This is a small project I worked on, and I wanted to share the code, for whoever it helps. This code has not been optimized at all._

Optimization wasn't the goal. The goal was to write assembly programs to encrypt and decrypt files.
I tried my best to add comments in the source code for both programs so that you can understand what's going on in the program.

To assemble and link [encryptprog.s](https://github.com/Demkeys/x86_64AssemblyATTGASExamples/blob/master/MyProjects/EncryptAndDecryptFile/encryptprog.s):

`as encryptprog.s -o encryptprog.o; ld encryptprog.o -o encryptprog`

To assembly and link [decryptprog.s](https://github.com/Demkeys/x86_64AssemblyATTGASExamples/blob/master/MyProjects/EncryptAndDecryptFile/decryptprog.s):

`as decryptprog.s -o decryptprog.o; ld decryptprog.o -o decryptprog`

### Instructions
_NOTES:_
* _Before encrypting or decrypting, make a backup, so that, at the offchance that something goes wrong during encryption or decryption, no data is lost._
* _Also, the programs look for a file named __testtext02__ in the current directory. So either rename the file you plan to encrypt and decrypt, or change the filename in the code for both programs to a name of your choice before assembling._
* _Also, the programs read and write max of 4096 bytes. If you want to increase that, change the size mentioned at __f_data__ in both programs' source code._
#### To encrypt:
* Run __encryptprog__ using `./encryptprog`. 
* Program will prompt you to enter a passkey of max. 8 characters. The program accepts upto 1024 characters, but only uses the first 8 characters.
* Program will use the entered passkey to encrypt the file data.

_NOTE: Once the file has been encrypted, the data in the file also contains non-printable characters, so use something like hexdump to read the file._

#### To decrypt (this must be a previously encrypted file):
* Run __decryptprog__ using `./decryptprog`. 
* Program will prompt you to enter the passkey used to encrypt the file. 
* Program will use the entered passkey to decrypt. If you enter the wrong passkey, the file will not decrypt properly.
* Once the file has been decrypted, you can use it for it's intended purpose.

![picture alt](https://github.com/Demkeys/x86_64AssemblyATTGASExamples/blob/master/MyProjects/EncryptAndDecryptFile/screencap01.png)
![picture alt](https://github.com/Demkeys/x86_64AssemblyATTGASExamples/blob/master/MyProjects/EncryptAndDecryptFile/screencap02.png)
![picture alt](https://github.com/Demkeys/x86_64AssemblyATTGASExamples/blob/master/MyProjects/EncryptAndDecryptFile/screencap03.png)
