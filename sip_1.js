//#region Require packages Setup
const cosmosjs = require("@cosmostation/cosmosjs"); // npm install @cosmostation/cosmosjs
const bip39 = require("bip39"); // npm install bip39
const blake = require("blakejs"); //  npm i blakejs
const CryptoJS = require("crypto-js"); //  npm i crypto-js
const aes256 = require("aes256"); //  npm i aes256
const SHA256 = require("crypto-js/sha256");
//#endregion

//#region Cosmos and Mnemonic Setup
const chainId = "cosmoshub-3";
const lcdUrl = "https://lcd-cosmos-free.cosmostation.io";
const cosmos = cosmosjs.network(lcdUrl, chainId);
cosmos.setPath("m/44'/118'/0'/0/0");
const mnemonic =
  "apology accuse kiwi fringe argue hamster sail sense speed clown hockey upon"; // bip39.generateMnemonic();
const address = cosmos.getAddress(mnemonic);
const memo = "memo message";
const ecpairPriv = cosmos.getECPairPriv(mnemonic);
//#endregion Cosmos
const stdMsgData = [];
var checksum = "";

//  Encrypted passphrase
var passphrase = blake.blake2bHex("abc");
//  Encrypted mnemonic
var encrypted = aes256.encrypt(passphrase, mnemonic); // var decrypt = aes256.decrypt(passphrase, encrypted);

//#region Example of as Cosmos Msg
cosmos.getAccounts(address, memo).then((data) => {
  let stdSignMsg = cosmos.newStdMsg({
    msgs: [
      {
        type: "cosmos-sdk/MsgSend",
        value: {
          amount: [
            {
              amount: String(100000),
              denom: "uatom",
            },
          ],
          from_address: address,
          to_address: "cosmos18vhdczjut44gpsy804crfhnd5nq003nz0nf20v",
        },
      },
    ],
    chain_id: chainId,
    fee: {
      amount: [{ amount: String(5000), denom: "uatom" }],
      gas: String(200000),
    },
    memo: memo,
    account_number: String(data.result.value.account_number),
    sequence: String(data.result.value.sequence),
  });

  // Serialize to convert it from object to string
  var serializedSignedTx = JSON.stringify(stdSignMsg);
  //console.log(serializedSignedTx);

  // Shorten the data into smaller size using base64
  base64encode(serializedSignedTx);
});
//#endregion
function base64encode(serializedSignedTx) {
  let objJsonB64 = Buffer.from(serializedSignedTx).toString("base64"); // another way is to use btoa()
  //console.log(objJsonB64);
  //  Generate a checksum of the data
  checksum = SHA256(objJsonB64).toString();
  //console.log(checksum);
  //  Generate frames and is split by n character lengths e.g. 120
  createFrames(objJsonB64, 120);
}

function createFrames(value, splitValue) {
  //  Split into frames using Regular Expressions
  let frames = value.match(RegExp(".{1," + splitValue + "}", "g"));

  // The structure for the barcode
  for (let i = 0; i < frames.length; i++) {
    let pageCount = i + 1;
    //  Add the header information
    if (i == 0) {
      let headerMsg = {
        version: "v0.0.1",
        type: "cosmos",
        algorithm: "secp256k1",
        network_id: "kira-1",
        path: "m/44/118/0/0/0",
        prefix: "kira",
        checksum: checksum,
        data: frames[i],
        page: pageCount,
      };
      stdMsgData.push(headerMsg);
    } else {
      //  Format the next structure after the heading
      let framesData = {
        data: frames[i],
        page: pageCount + "/" + frames.length,
      };
      stdMsgData.push(framesData);
    }
    //console.log(stdMsgData);
  }

  //  Here you can decide, how you handle each frame and how you want to generate QRcodes
  //  Whether it's terminal, saving locally as SVG or PNG file
  //  or having it shown once and disposed of on the run.
  //  Depending on which, and how you communicate it to the Web, APP e.g.

  stdMsgData.forEach(function (element) {
    //  Creating a series of QR codes representing data that must be signed
    //  Once generated, display them.
  });

  //  Once QRcode is done, shown and signed, it is decoded
  decodeQRCode(stdMsgData);
}

function decodeQRCode(value) {
  var retrievedData = "";

  // Sort's the frames in ascending order of page number
  value.sort(function (a, b) {
    return b.page - a.page;
  });

  // Once it is sorted, data about transcation is retrieved
  for (i = 0; i < value.length; i++) {
    // console.log(value[i].page);
    retrievedData = retrievedData + value[i].data;
  }

  //  Verify the integrity of the data via Checksum
  verifyChecksum = SHA256(retrievedData).toString();

  if (checksum == verifyChecksum) {
    // Decoded from base 64 to string
    let decodebase64 = Buffer.from(retrievedData, "base64").toString();
    // Converted back into an JSON object
    let dataObject = JSON.parse(decodebase64);
    // Retrieve Signature from mobile here
    const signedTx = cosmos.sign(dataObject, ecpairPriv);
    //  Propogate to the blockchain over RPC : broadCastStd{}
    cosmos.broadcast(signedTx).then((response) => console.log(response));
  } else {
    // Data has been modified as checksum doesn't match
  }
}
