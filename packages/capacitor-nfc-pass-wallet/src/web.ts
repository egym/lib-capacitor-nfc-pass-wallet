import type {
  ReadPassFromWalletOptions,
  ReadPassFromWalletResult,
  SavePassToWalletOptions,
  WalletAvailabilityResult,
} from '@egym/nfc-pass-wallet-contracts';
import { WebPlugin } from '@capacitor/core';

import type { CapacitorNFCPassWalletPlugin } from './definitions.js';

export class CapacitorNFCPassWalletWeb extends WebPlugin implements CapacitorNFCPassWalletPlugin {
  async savePassToWallet(_options: SavePassToWalletOptions): Promise<void> {
    throw this.toUnavailableError('Wallet operations require native iOS/Android implementation.');
  }

  async readPassFromWallet(_options: ReadPassFromWalletOptions): Promise<ReadPassFromWalletResult> {
    return { result: false };
  }

  async isWalletAvailable(): Promise<WalletAvailabilityResult> {
    return { result: false };
  }

  private toUnavailableError(message: string): Error {
    return new Error(`UNAVAILABLE: ${message}`);
  }
}
