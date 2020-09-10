# saifu sip_2
"*Dart/Flutter application capable of a PGP signing a text message of the arbitrary length and extend previously created web application mocking the logic to propagate and verify signed message.*" [here](https://github.com/KiraCore/docs/blob/master/spec/kira-signer/sip_2.md) 

**Warning:** This is build using Flutter SDK, which is fairly new and hasn't achieved full web support yet, however we are still adapting it and make it very useful.

Web implementation for generating & scanning multiple bar-code and verifying signed bar-code from mobile.  This also currently a working solution for barcode-scanning until Flutter SDK has full support for it on the web. 
![Web implementation](https://imgur.com/qGuwXsP.png)

This requires:
Latest version of Flutter SDK, with web support and perhaps {beta channel}. The project is able to run, however be wary of https://github.com/flutter/flutter/issues/41563 . 
This is to do with the analyser, once you run and build the project, it will run completely fine. 

### Getting started with this product

Ensure you are running the latest stable flutter sdk, setup the editor and installed packages. References:

-   [Online documentation](https://flutter.dev/docs)
-   [Installing Flutter](https://flutter.dev/docs)

Upgrade flutter and diagnosis

```
flutter upgrade
flutter doctor
flutter doctor -v -more detailed

```

Enable web support

```
flutter config --enable-web

```

Download dependencies

```
flutter pub get

```

 Run it

    flutter run -d chrome

