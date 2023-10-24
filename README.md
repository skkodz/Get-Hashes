# Get-Hashes
PowerShell script for hashing all files within a directory structure.

This script will create a hash for all files in the path provided and output the results into the file provided.

`-Directory <path>`

This parameter can be a drive letter or UNC path to the directory containing files to be hashed. This is a mandatory parameter.

`-OutFile <path>`

This is the file to write the hashes to. If this file exists you will be prompted to either Overwrite (O), Append (A) or Exit (E).  This is a mandatory parameter.

`-Algorithm {MD5 | SHA1 | SHA256}`

Optionally choose a hashing algorithm - default is MD5.
