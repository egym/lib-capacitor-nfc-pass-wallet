import type {
  NFCPassWallet,
  ReadPassFromWalletOptions,
  ReadPassFromWalletResult,
  SavePassToWalletOptions,
  WalletAvailabilityResult,
} from '@egym/nfc-pass-wallet-contracts';

export type {
  SavePassToWalletOptions,
  ReadPassFromWalletOptions,
  ReadPassFromWalletResult,
  WalletAvailabilityResult,
};

export interface CapacitorNFCPassWalletPlugin extends NFCPassWallet {
  savePassToWallet(options: SavePassToWalletOptions): Promise<void>;
  readPassFromWallet(options: ReadPassFromWalletOptions): Promise<ReadPassFromWalletResult>;
  isWalletAvailable(): Promise<WalletAvailabilityResult>;
}
