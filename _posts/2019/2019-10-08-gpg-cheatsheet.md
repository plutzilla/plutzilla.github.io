---
layout: post
title: GPG cheatsheet
---

## What is GPG

GPG (GNU Privacy Guard) is the open source utility - the implementation of [OpenPGP](https://tools.ietf.org/html/rfc4880) protocol used for signing and encrypting data. The protocol utilizes both public-key and symmetric cryptography which ensures the confidentiality and integrity of the data, and also provides the services for key management and discovery.

The verbose documentation can be found in the 20 year old [GPG Handbook](https://www.gnupg.org/gph/en/manual/book1.html). This page is a quick summary of the most commonly used commands.

## Key management functions

### Creating a keypair

OpenPGP private/public key pair is created using the command:
```sh
$ gpg --gen-key
```

During the process you will need to provide the `Real name` (full name), `Email address`, (optionally) a `Comment` and a `Passphrase` to secure the access to your Private Key (Secret Key).

The public key will be stored in your OpenPGP keychain, most likely in `~/.gnupg`.

The **private** key will be used to `sign` and `decrypt` data and must NOT be disclosed, while the **public** key can be freely distributed and will be used to `verify` the data signed by you and to `encrypt` the data which needs to be securely transferred to you.

### Listing keys

The GPG keys that are stored in the GPG keychain are listed using command:

```sh
$ gpg --list-keys
```

### Exporting a public key

To export the public key from the keychain to the ASCII-armored file, use command:

```sh
$ gpg --armor --output <FILENAME>.asc --export <User ID>
```
or `gpg -a -o <FILENAME>.asc -e <User ID>` as a shorthand.

Email address is used as the Key ID.

`.asc` extension is used for ASCII-armored GPG data. Binary GPG data is usually stored in `.gpg` files.

### Uploading a public key to a OpenPGP key server

The public key can be exported to the OpenPGP keyserver for easier discovery and sharing:

```sh
$ gpg --keyserver <KEYSERVER> --send-keys <KEY HEX FINGERPRINT>
```
for example `gpg --keyserver keyserver.ubuntu.com --send-keys 0x01CECB1C27D919EEC25DDAA56948635145E59E2`

### Retrieving and importing a public key

To import the public key **from the file** to the keychain use command:

```sh
$ gpg --import <FILENAME>.asc
```

To import the public key from the keyserver by searching it, use command:

```sh
$ gpg --keyserver <KEYSERVER> --search-key <KEY FINGERPRINT or USER ID>
```
for example: `gpg --keyserver keyserver.ubuntu.com --search-key 0x01CECB1C27D919EEC25DDAA56948635145E59E24` or `$ gpg --keyserver keyserver.ubuntu.com --search-key paulius.lescinskas@gmail.com`.

### Backing-up the private key

The list of private keys can be retrieved by the command:

```sh
$ gpg --list-secret-keys
```

The `sec` section contains the cryptography algorithm, expiration date and the key ID.

The following commands exports the ASCII-armored private key (secret key) with the id `<KEY ID>` to the file `<FILENAME>.asc`:

```sh
$ gpg --armor --output <FILENAME>.asc --export-secret-keys <KEY ID>
```
or `gpg -ao <FILENAME>.asc --export-secret-keys <KEY ID>` as a shorthand.

The file can then be backed up, and imported to another machine via the aforementioned key import command:

```sh
$ gpg --import <FILENAME>.asc
```

## Data encryption and decryption

### Data encryption

To encrypt the file, use the following command:
```sh
$ gpg --encrypt --recipient <RECIPIENT USER ID> <FILENAME>
```
or `gpg -e -r <RECIPIENT USER ID> <FILENAME>` as a shorthand.

This will encrypt the `<FILENAME>` file using the key of a user with a `<RECIPIENT USER ID>`. The recipient's public key needs to be imported to the keychain beforehand. The USER ID is usually a user's email.

The `<FILENAME>.gpg` will be created with the encrypted data. The `--output <FILENAME>` can be used to override the file name. The `--armor` key can be used to create the ASCII-armored version of the file. In such case the default file extension will be `.asc`.

### Data decryption

The encryped file is decrypted by the owner of the private key using the following command:

```sh
$ gpg --output <DECRYPTED OUTPUT FILE NAME> --decrypt <ENCRYPTED FILE NAME>
```
or `gpg -o <DECRYPTED OUTPUT FILE NAME> -d <ENCRYPTED FILE NAME>` as a shorthand.

You will be asked to provide the Passphrase of your private key to decrypt the file.

## Signing ang verifying data

### Signing

ASCII-armored signature of the file `<FILENAME>` is generated using a command:

```sh
$ gpg --sign --armor <FILENAME>
```
or `gpg -sa <FILENAME>` as a shorthand.

This will generate a signature file `<FILENAME>.asc`.

### Verifying signature

The signature can be verified using a command:

```sh
$ gpg --verify <SIGNATURE FILE>
```
