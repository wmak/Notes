# Symmetric Crytography
- Shift Ciphers
	- Replace each letter with the letter x letters down.
- Monoalphabetic cipher
	- Single substitution alphabet
		- 4x10^26 keys
	- Frequency Analysis
		- Statistical Cryptanalysis in general
- Vingenère Cipher
	- Use a keyword
	- Repeat the keyword and use that as shift
	- Obscures against frequency analysis
- OTP
	- Theoretically unbreakable
- Playfair Block Cipher
	- Create a 5x5 matrix of letters
	- I == J
- Feistel Cipher
	- do n rounds, on L and R halves of input
	- Encrypt one half, and use that to encrypt other half
	- Repeat.
- DES
	- Type of Feistel cipher
	- 16 rounds
	- 56 bit keys
	- 64 bit blocks
- 2DES
	- Use 2 56 bit keys (112 bits)
	- Increases key space to 112 bit keys
	- Meet-In-The-Middle Attack
		- C = E(K2, E(K1, P))
		- P = D(K1, D(K2, C))
		- E(K1, P) = X = D(K2, C)
- 3DES
	- Use 2 Keys
		- C = E(K1, D(K2, E(K1,P)))
		- EDE provides DES compatibility, set K1 = K2.
	- 168 bit key
	- Slow implementations (DES was old)
- AES
	- 128/192/256 bit keys
	- 128 bit block
	- 4 steps, each reversible:
		- Byte Substitution
			- one S-box used on every byte
		- Shift Rows
			- permute bytes between columns
			- A circular left byte-shift
		- Mix Columns
			- permutation using matrix multiply
		- Add Round Key
			- XOR state with key material
	- all arithmetic done in GF(2^8)

# Block Mode
- ECB (Electronic Code Book)
  - Break text into blocks
  - Each block is then independently encrypted
  - Can rearrange blocks
- CBC (Cipher Block Chaining)
  - Break text into blocks
  - Ci = AES(K,(Pi XOR Ci-1))
    - XOR with previous(or IV) then encrypt
  - Pros
    - Tampering only works for first block
  - Cons
    - Needs entire sequence to encrypt
- CFB (Cipher FeedBack)
  - Ci = Pi XOR AES(K, Ci-1)
    - Encrypt the previous block then xor with plaintext
  - Pros
    - Parallelizable decryption
  - Cons
    - Error in transmission will propagate.
    - Needs entire sequence to encrypt
- OFB (Output FeedBack)
  - Ci= PiXOR Oi
  - Oi= AES(K, Oi-1)
    - Encrypt IV over and over
    - XOR encrypted values with plaintext
  - Pros
    - Can precompute all of the cipherbits
    - Errors will not propagate across blocks
  - Cons
    - Vulnerable to stream modification
    - If attacker knows plaintext Pi
    - Ci’ = Pi XOR Pi’ XOR Ci  
    - Never reuse a key.
    - XOR the cipher texts together and you get the xor of the
      plaintexts.
- CTR (Counter)
  - Ci = Pi XOR Oi
  - Oi = AES(K,i)
    - Encrypt some counter
    - Xor result with plaintext
  - Pros
    - Efficient, encryption and decryption can be parallelized
    - Allows for out of order encryption/decryption
  - Cons
    - Never reuse keys.

# Stream Cipher
- RC4
  - Fast and simple implementation
  - Never reuse keys
  - used in SSL/TLS, WEP
  - Key Scheduling
    - Maintain a state array of numbers from 0-255
    - Shuffle the state array using Key
  - Encryption
    - XOR state value with next byte to encrypt

# Public Key Cryptography
- Each user has 2 keys
  - Secret key
  - Public key
- Rely on one-way functions that are reverible given some key.
  - aka Trap Door functions
- Diffie-Hellman
  - DH setup
    - Agree in advance on
    - p(rime)
    - g(enerator)
    - Each user create
    - random private key (a < p)
    - computed public key (y_a = g^a mod p)
  - Shared key is then
    - g^{a x b} mod p
    - which is just y_a^{b} mod p or y_b^{a} mod p
    - both of these can be computed by Alice and Bob
  - Vulnerable to Man in the Middle attack
- RSA
  - Block cipher
  - Choose large primes p & q, n = p x q
  - Fermat's Theorem
    - a ^ p = a mod p
    - if a < p and p is prime
    - Test for compositeness, primeness is not necessarily true
    - can know a number is probably prime. or not prime.
  - Euler's Theorem
    - Totient function φ(n), phi(n), number of positive integers less than n
    - a^{φ(n)} mod n = 1
    - given two primes p and q where n = p x q
    - φ(n)=(p-1)(q-1) 

# Secure Hash Algorithms, Message Authentication, Digital Signatures

## Hashing
- Requirements for a secure hash function
 1. Works for abritrary length messages
 2. easy/fast to compute hash
 3. produces a fixed length output
 4. given *hash* it's infeasible to find *original* message
   - Pre-image resistance
 5. given *original* message it's infeasible to find *another* message with the
 same hash
   - 2nd-pre-image resistance
 6. finding any two messages with the same hash is infeasible
   - strong ocllision resistance
- Hashing is weak to the birthday attack
- As we know MD5 is a pile of crap
 - SHA-1
  - 160 bit hashes
 - SHA-2
  - 224, 256, 384 or 512 bits

## Message Authentication
- protect the **integrity** of a message
 - Implemented with encryption, MAC or secure hash function
- validate the **identity** of the originator
 - Implemented with encryption, MAC or digital signature
- know the **origin** of the message
 - Implemented with digital signature
- MACs
 - Message Authentication Codes
 - Checksum
 - Provides assurance that message is unaltered.
 - Requirements (Let m = Message, M = MAC)
  1. knowing m and M cannot find m' with the same M
  2. M should be uniformly distributed.
  3. M should depend equally on all bits of m
 - AES-CBC is the standard MAC
- Digital Signatures
 - Properties
  - Must use information unique to the sender
  - Relatively easy to make
  - Relatively easy to recognize and verify
  - computationally infeasible to forge
  - Signature associated with a message

# Network Attacks
- LAN translation from IP to link-layer addresses 
 - ARP cache poisoning by violating protocol assumptions
 - Address Resolution Protocol
 - Maps IP to Mac Address
 - There is no authentication
 - ARP always trusts everyone
- Network packets pass by/through untrusted hosts
 - eavesdropping (packet sniffing)
- IP addresses are public
 - smurfattacks
  - send ICMP requests pretending to come from target
  - Every host on the network generates a seply to target
 - Ping of Death
  - Until '97 ICMP packets larger than 64K would cause a machine to crash
- TCP connection requires state
 - SYN flooding, port-scanning
- TCP state is easy to guess
 - TCP spoofing and connection hijacking
- User Datagram Protocol(UDP)
 - Connectionless transport layer protocol
 - just send datagram to application process at specified IP
 - DOS by UDP flood
- Transmission Control Protocl(TCP)
 - Divide datastream into packets
 - each packet gets a sequence number
 - Receiver reassemples packets and acknowledges receipt
 - 3-Way Handshake
  - Ask server for sync
  - Server asks client for sync and acknowledgement
  - client respons with acknowledgement
 - LAND DoS Attack
  - Single packet with source/port equal to destination
  - Triggers infinite loop to itself.
 - SYN-flooding DoS attack
  - DDoS attack.
  - Mitigating the attack
   - SYN cookies 
    - return a secure token to clien
    - no server state is allocated until client completes the handshake
   - Random Deletion
    - If queue is full randomly delete an entry
 - DoS connection reset
  - if attacker can figure out someone elses sequence number
  - send packet with reset flag
- Domain Name System (DNS)
 - Map symbolic names to IP addresses
 - Vulnerabilities
  - Users/hosts trust mapping provided by DNS
  - Interception of DNS
   - I can say my site is google now

# HTTPS
- Most widely used security protocol
- Works at transport layer
- Works for anything TCP based
- Use a MAC with shared secret key
- Use a symmetric encryption with a shared secret key
- compressed then encrypted
- Operations
 - Fragment
 - Compress
 - Add MAC
 - Encrypt
 - Append SSL Header
- 4 phases for handskae
  1. Hello
    - Client tells server what it can do
    - Server decides on options that work for both
    - Random bytes to be used as session key
  2. Server sends certificates, key excahnge
    - Clien uses certificate to verify server
  3. Client sends certificates, key exchange
  4. Change cipher suite and finish handshake
- OVerhead
 - 2-10 times slower than unsecure TCP
 - handshake involves client encryption, server decryption
 - Data transfer
- Vulnerabilities
 - Mixed content sites, http -> https
 - SSL stripping
  - When user switches from http to https attacker imposes MITM

# Authenticating Humans
- How to determine you are who you say you are
- Passwords are a poor candidate for this
- Salt
 - Append random string to the end of password before hashing
 - Ensures attacker can't pre-compute hashes of passwords
- Password Phishing
 - Malicious website could try using your password on another site

# Buffer Overflows
- Required for attack
 - no \0 character
 - should not crash program before attack program exits
- Details vary between CPU’s and OS’s:
 - little vs big endian
 - stack frame structure
 - direction of stack growth
- return-to-libc exploit
 - set ret-addr to some libc function
- Canary 
 - Embed a random string into every stack frame
 - Verify canary string is unchanged before moving on
 - PointGuard
  - protects function pointers and setjmp buffers by placing canaries with them
  - affects performance
- Libsafe
 - Intercepts calls to common buffer overflow functions
 - checks that there's sufficient space to copy over
 - otherwise says no

# SQL injection
- Prevention
 - black/white list
 - Prepared Statements
  - use static queries
  - bind the variables
 - Blacklisting doesn't work
  - can miss some characters
  - accidently prevent good input
 - Prepared statements only works in certain situations
  - SELECT, INSERT, UPDATE, DELETE
  - Nto applicable if user does something that varies the table

# Spam + Phishing
- Email
 - SMTP was designed for trusting world
 - Received headers are inserted by relays
  - don't trust any but the top one
  - and only trust it's IP
  - domain can be forged
 - From header is completely untrustworthy
- Spam
 - incentives
  - ads
  - phishing
  - scams
  - Recruiting crooks
  - recruiting bots
  - Pump and dump (stocks
 - prevention
  - Spam blacklists
   - blocks servers or ISPs that generate lots of spam
 - Thin-thick pipe method
  - Have a high speed connection and low speed zombies
  - low speed zombies get blocked but high speed connection remains okay
 - Graylists
  - keep triples of sender, recipient, peer ip
  - if triple not in DB reply busy
  - second time allow email to pass
  - works well?
 - Whitelisting
  - fill in captcha to email me
- Phishing
 - image authentication
  - use image as second factor 
  - show image decided by user, if not what htey wanted
  - they'll know it's phishing

# Web Security
- HTTP is stateless.
- bad ideas to get around this
 - Encoding state in url
  - Easy to eavesdrop
  - URL is not private at all
  - Unstable
 - Form based session state
  - ... easily modified
   - people actually used this?!
  - don't point hidden variable to file and then display it's content
   - change it to password file
   - GG
- C IS FOR COOKIE
 - used for:
  - Authentication
  - Personalization
  - Transaction processing
  - tracking
 - add a MAC to every cookie so user can't edit them
- Same-Origin policy
 - Only the site that read/modifed information it creates
 - does not apply to scripts themselves
 - scripts can modify other scripts on the same page
- Top 3 Web app vulnerabilities
 - SQL injection
 - CSRF
  - Take cookies from other scripts
  - Web apps should refreshe *nonce* in every *form* and check in every *request*
  - cookie auth is not enough
   - Secret Validation tokens
   - Referer Validation
   - Custom HTTP header
 - XSS
  - even with Same-Origin Policy sometimes web applications embed user input
  - Reflection Attack
   - Code in web page executes arbitrary operations
   - Steps:
    1. User visits website
    2. Receives a malicious link
    3. Click on valid link
    4. echo users input
    5. This causes them to send valuable data to the bad server
   - Major issue, failure to sanitize untrusted input
  - Persistent (stored XSS)
   - Relies on users downloading malicious scripts

# Malware
- Three ideas
- Trojan
 - **Undesired Functionality
 - Hidden in code**
 - Trick users into running your code
 - Do not self replicate
- Worm
 - **Undesired Functionality
 - Propagates**
 - Self contained
- Virus
 - **Undesired Functionality
 - Propagates
 - Hidden in code**
 - Inserts itself into a host program
- AntiVirus
 - Signature based
 - look for bit patterns
 - To combat this bad people encrypt the code
  - To combat that use decryptor as signature
 - Polymorphic virus, mutate the decryptor code
  - sandbox
  - Wait for virus to decrypt
  - Bam you got it.
