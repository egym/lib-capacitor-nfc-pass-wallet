export type SavePassToWalletOptions = {
  iosPkPassBase64?: string;
  androidPassJwt?: string;
  saveToGooglePayUrl?: string;
  googlePayJwt?: string;
};

export type ReadPassFromWalletOptions = {
  iosPkPassBase64?: string;
};

export type WalletAvailabilityResult = {
  result: boolean;
};

export type ReadPassFromWalletResult = {
  result: boolean;
};

export type WalletErrorCode =
  | "UNAVAILABLE"
  | "INVALID_PAYLOAD"
  | "NOT_SUPPORTED"
  | "USER_CANCELED"
  | "NATIVE_ERROR";

export type WalletError = {
  code: WalletErrorCode;
  message: string;
  cause?: unknown;
};

export type NFCPassWallet = {
  savePassToWallet(options: SavePassToWalletOptions): Promise<void>;
  readPassFromWallet(
    options: ReadPassFromWalletOptions,
  ): Promise<ReadPassFromWalletResult>;
  isWalletAvailable(): Promise<WalletAvailabilityResult>;
};

export interface CapacitorNFCPassWalletPlugin extends NFCPassWallet {
  savePassToWallet(options: SavePassToWalletOptions): Promise<void>;
  readPassFromWallet(
    options: ReadPassFromWalletOptions,
  ): Promise<ReadPassFromWalletResult>;
  isWalletAvailable(): Promise<WalletAvailabilityResult>;
}
