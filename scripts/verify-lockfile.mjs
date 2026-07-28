import { readFile } from "node:fs/promises";

const packageJson = JSON.parse(await readFile("package.json", "utf8"));
const packageLock = JSON.parse(await readFile("package-lock.json", "utf8"));
const rootPackage = packageLock.packages?.[""];

const errors = [];

if (packageLock.version !== packageJson.version || rootPackage?.version !== packageJson.version) {
  errors.push(
    `package version ${packageJson.version} does not match package-lock.json versions ` +
      `${packageLock.version ?? "missing"}/${rootPackage?.version ?? "missing"}`,
  );
}

const missingRegistryMetadata = Object.entries(packageLock.packages ?? {})
  .filter(([path, metadata]) => path && metadata.version && !metadata.link)
  .filter(([, metadata]) => !metadata.resolved || !metadata.integrity)
  .map(([path]) => path);

if (missingRegistryMetadata.length > 0) {
  errors.push(
    `${missingRegistryMetadata.length} locked packages lack resolved/integrity metadata: ` +
      missingRegistryMetadata.slice(0, 10).join(", "),
  );
}

if (errors.length > 0) {
  throw new Error(errors.join("\n"));
}

console.log(`Verified ${Object.keys(packageLock.packages).length - 1} locked packages.`);
