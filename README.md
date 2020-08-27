# saifu
Saifu is universal key-keep app that enables user to turn their mobile device into a hardware wallet. Milestone road-map can be found [here:](https://github.com/KiraCore/docs/blob/master/spec/kira-signer/sip_1.md) 

SIP_1 is the JS Mock Library that can be imported by any front application. It allows for flexibility so that third parties can decide how they handle the Qr-code generating and scanning. Whether it's coded on html, or you decide to use a different package or whether they want to store the Qr-codes or not at all. 

Examples of a range of JS libraries that can be used as a good reference point:

-   [https://github.com/node-a-team/cosmosjs](https://github.com/node-a-team/cosmosjs) to create transaction across varies hubs (Cosmos, Iris, Kava, Band, IOV).
- Experiment with different transcation types : [https://github.com/cosmostation/cosmosjs/tree/master/docs/msg_types](https://github.com/cosmostation/cosmosjs/tree/master/docs/msg_types)
- Qr-code handling: [html5-qrcode](https://github.com/mebjas/html5-qrcode) , more available at: [https://www.npmjs.com/search?q=QRcode](https://www.npmjs.com/search?q=QRcode) 

#### To get started:

    npm install packages
    
 Run it

    node sip_1.js

Be sure to read the comments, it's readable and explains the flow.  Un-comment (the console.logs) to see how the data is handled and transferred through the library. 
