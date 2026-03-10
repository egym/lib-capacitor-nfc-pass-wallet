import { describe, expect, it } from 'vitest';

import { CapacitorNFCPassWalletWeb } from './web.js';

describe('CapacitorNFCPassWalletWeb', () => {
  it('throws UNAVAILABLE error for savePassToWallet', async () => {
    const plugin = new CapacitorNFCPassWalletWeb();

    await expect(plugin.savePassToWallet({})).rejects.toThrow(
      'UNAVAILABLE: Wallet operations require native iOS/Android implementation.',
    );
  });

  it('returns false for readPassFromWallet', async () => {
    const plugin = new CapacitorNFCPassWalletWeb();

    await expect(plugin.readPassFromWallet({})).resolves.toEqual({ result: false });
  });

  it('returns false for isWalletAvailable', async () => {
    const plugin = new CapacitorNFCPassWalletWeb();

    await expect(plugin.isWalletAvailable()).resolves.toEqual({ result: false });
  });
});
