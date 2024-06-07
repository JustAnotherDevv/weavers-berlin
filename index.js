import { connect } from "@permaweb/aoconnect";
import fs from 'fs';
import path from 'node:path';
import { fileURLToPath } from 'url';

import { PACKAGE_REGISTRY_PROCESS } from './constants.js';
import { createEmptyFileIfNotExists, createFolderIfNotExists, getDependencyVersion } from './utils.js';

const { result, results, message, spawn, monitor, unmonitor, dryrun } = connect(
  {
    MU_URL: "https://mu.ao-testnet.xyz",
    CU_URL: "https://cu.ao-testnet.xyz",
    GATEWAY_URL: "https://arweave.net",
  },
);

function loadDependencies(packageName) {
  try {
    const __dirname = path.dirname(fileURLToPath(import.meta.url));

    const packageData = JSON.parse(fs.readFileSync('package.json', 'utf-8'));
    const dependencies = packageData.dependencies || {};
    console.log(dependencies);

    const aosPackagesPath = path.join(__dirname, 'aos_packages');
    createFolderIfNotExists(aosPackagesPath);

    const dependencyVersion = getDependencyVersion(aosPackagesPath);
    const packageFolderPath = path.join(aosPackagesPath, `${packageName}-${dependencyVersion}`);
    createFolderIfNotExists(packageFolderPath); 

    const mainFilePath = path.join(packageFolderPath, 'main.lua');
    createEmptyFileIfNotExists(mainFilePath);

    return dependencies;
  } catch (error) {
    console.error('Error loading dependency:', error.message);
    return null;
  }
}

async function main() {
    const myDependency = loadDependencies('some-package-name');
    // TODO
    // Example pkg name, change later to dynamic loading from project dependencies

    if (myDependency) {
    console.log('Dependency loaded successfully:', myDependency);

    const result = await dryrun({
        process: PACKAGE_REGISTRY_PROCESS,
        data: 'ping',
        tags: [{name: 'Action', value: 'Balance'}],
        anchor: '1234',
      });
      
      console.log(result.Messages[0]);
    }
}

main();
