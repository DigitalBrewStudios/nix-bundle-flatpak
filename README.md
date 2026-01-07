# nix-bundle-appstores
A Bundler for appstores.

# Compatibility with Appstores
| Appstores | Build/Works |
| -------------- | --------------- |
| .Flatpak (Uses Arx, FlatHub) | ⚠️ [1][1.] |
| .Snap (SnapStore) | ❌ (In progress) |
| .Apk (Android) | ❌ (See #4) |
| .Ipa (IOS) | ❌ (See #4)|

1. Flatpaks haven't been fully tested yet if they work, we are actively looking for testers. Please join our [developers channel in our discord and help us test](https://discord.gg/XaKhU6KpM6)

# Development/Testing

1. Have [nix installed](https://nixos.org/download) with experimential features `nix-command` & `flakes` enabled!
2. Do `nix bundle --bundler . <drv>` while on a linux system.

