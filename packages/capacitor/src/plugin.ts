import { registerPlugin } from '@capacitor/core';

import type { CapacitorNFCPassWalletPlugin } from './definitions.js';

const CapacitorNFCPassWallet = registerPlugin<CapacitorNFCPassWalletPlugin>('CapacitorNFCPassWallet', {
  web: () => import('./web.js').then(m => new m.CapacitorNFCPassWalletWeb()),
});

export * from './definitions.js';
export { CapacitorNFCPassWallet };
