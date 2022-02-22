export const SHA256 = "SHA-256"
export const SHA1 = "SHA-1"
export const EXPORT_PUB_KEY_FORMAT = "spki"
export const EXPORT_PRIV_KEY_FORMAT = "pkcs8"

export let crypt: Crypto

if (typeof window !== 'undefined') {
  crypt = window.crypto
} else if (typeof WorkerGlobalScope !== 'undefined' ) {
  crypt = global.crypto
} else {
  crypt = require("crypto")
}

export interface IPubCipher {
  generatePair(): Promise<CryptoKeyPair>
  importPrivKey(key: Uint8Array): Promise<CryptoKey>
  decrypt(key: CryptoKey, data: Uint8Array): Promise<Uint8Array>
}

export interface IDerive {
  generate(password: Uint8Array, salt: Uint8Array, iterations: number, bytes: number): Promise<Uint8Array>
}
