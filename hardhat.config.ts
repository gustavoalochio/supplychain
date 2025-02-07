import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337, // Configuração para a rede local
    },
    sepolia: {
      gas: 12000000, // Defina um valor maior para gasLimit
      gasPrice: 20000000000, // Preço do gás em wei (20 gwei)
      url: process.env.SEPOLIA_RPC_URL || "", // URL do nó RPC da rede Sepolia
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [], // Conta privada
      chainId: 11155111, // Identificador único da rede Sepolia
    }
  },
};

export default config;