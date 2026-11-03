# CC26 (iOS 12)
Build locally: install Theos + iOS SDK, then `make package`.
Or push this folder to a GitHub repo, run the "Build deb" action, download the .deb artifact.
Install: copy .deb to device, `dpkg -i file.deb && killall -9 SpringBoard` (or open in Filza).
Assumes a rootful jailbreak (/Library/MobileSubstrate). Rootless-style jailbreaks need `THEOS_PACKAGE_SCHEME = rootless`.
