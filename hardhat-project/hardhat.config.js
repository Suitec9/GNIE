require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(".env");

module.exports = {
		solidity: "0.8.10",
		defaultNetwork: "sepolia",
		networks: {
			sepolia: {
						url: process.env.ALCHEMY_API_KEY_URL,
						accounts: [process.env.SEPOLIA_PRIVATE_KEY],
				},
		},
		etherscan: {
				apiKey: {
				sepolia: process.env._PRIVATE_KEY,
				},
		},
};

// Configuration
/*
		solidity - The version of solidity compiler
		defaultNetwork - The Default network to run (Without running --network-name)
		networks - Object which contains the network information
		etherscan - Object to fill in EtherScan Information for contract verification
*/

module.exports = {
		solidity: "0.8.10",
		defaultNetwork: "sepolia",
		networks: {
				sepolia: {
						url: process.env.ALCHEMY_API_KEY_URL,
						accounts: [process.env.SEPOLIA_PRIVATE_KEY],
				},
		},
};

