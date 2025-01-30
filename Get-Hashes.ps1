##################################################################################
# Get-Hashes.ps1
# Version: 1.3
# Author: S Kodz
# Last Updated 30 Jan 2025 by S Kodz
#
# Version History
#   Version 1.3 - 30 Jan 2025 by S Kodz
#     Added command executed into the logging output.
#   Version 1.2 - 07 Oct 2019 by S Kodz
#     Added | Format-String -Width 4096 as long file paths were still being
#     truncated in the output file to the console width.
#   Version 1.1 - 30 Aug 2019 by S Kodz
#      Added | Format-Table -Autosize to prevent the file path being
#      truncated in the output file.  WIth this parameter the width
#      console is a limiting factor
#
#   Version 1.0 - 28 Aug 2019 by S Kodz
#      Original Version
#
# This script will create a hash for all files in the path provided and output the
# results into the file. This script has 2 mandatory parameters and 1 optional.
# 
# -Directory <path>
#   This parameter can be a drive letter or UNC path to the directory containing
#   files to be hashed.
#
# -OutFile <path>
#   This is the file to write the hashes to. If this file exists you will be
#   prompted to either Overwrite (O), Append (A) or Exit (E)
#
# -Algorithm {MD5 | SHA1 | SHA256}
#   Optionally choose a hashing algorithm - default is MD5
#
##################################################################################

Param( 
  [Parameter(Mandatory=$true)] [string]$Directory,
  [Parameter(Mandatory=$true)] [string]$OutFile,
  [Parameter(Mandatory=$false)] [string]$Algorithm = 'MD5'
)
  if ("MD5", "SHA1", "SHA256" -NotContains $Algorithm) { Throw "$($Algorithm) is not a valid Algorithm. Please use MD5, SHA1 or SHA256" }
  if ( -not (Test-Path -Path $Directory -PathType Container ) ) {Throw "$($Directory) is not a valid directory." }
  $StartTime = Get-Date -UFormat %Y%m%d-%H%M%S
  if ( Test-Path -Path $OutFile -PathType Leaf ) {
    Write-Host   "$OutFile already exists, would you like to Overwrite (O), Append (A) or Exit (E)?"
    $KeyOption = 'A','E','O'
    while ( $KeyOption -notcontains $KeyPress.Character ) {
      $KeyPress = $host.UI.RawUI.ReadKey( "NoEcho,IncludeKeyDown" )
    }
  }

  if ( $($KeyPress.Character) -eq 'E' ) { Exit 0 }
    
  if ( $($KeyPress.Character) -eq 'O' ) { "$StartTime : Script Starting" | Out-File -FilePath $OutFile }
  elseif ( ( $($KeyPress.Character) -eq 'A' ) -or ( $($KeyPress.Character) -eq $null ) )
    { "$StartTime : Script Starting`nCommand Executed: Get-Hashes.ps1 -Algorithm $Algorithm -Directory $Directory -OutFile $OutFile" | Out-File -FilePath $OutFile -Append }
  else
    { Throw "ERROR: Unknown value detected - terminating." }

  Write-Host "About to calculate file hashes. This may take a long time if there are large files or a large number of files"
  Get-ChildItem -LiteralPath $Directory -Recurse -File | Get-FileHash -Algorithm $Algorithm | Format-Table -Autosize | Out-String -Width 4096 | Out-File -FilePath $OutFile -Append
  $EndTime = Get-Date -UFormat %Y%m%d-%H%M%S
  "$EndTime : Script complete" | Out-File -FilePath $OutFile -Append
  "---------------------------------------------------------------------------------------------------------" | Out-File -FilePath $OutFile -Append
