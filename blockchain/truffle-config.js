module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost
      port: 7545,            // Port Ganache (à vérifier dans ton Ganache)
      network_id: "*",       // Tout réseau
    },
  },

  contracts_build_directory: "./src/artifacts/",

  compilers: {
    solc: {
      version: "0.8.21",    // Version de Solidity utilisée
      evmVersion: "byzantium",
      optimizer: {
        enabled: false,
        runs: 200
      }
    }
  }
};
