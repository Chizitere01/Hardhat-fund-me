# Fund Me Smart Contract

Welcome to the Fund Me Smart Contract project! This decentralized application (DApp) allows users to fund the contract by sending Ethereum (ETH) and withdraw funds when needed. The contract also ensures that a minimum funding amount in USD is met before accepting contributions.

## Features

1. **Funding:** Users can fund the contract by sending Ethereum (ETH) to the contract's address.

2. **Minimum Funding Amount:** The contract sets a minimum funding value in USD, and users must send enough ETH to meet this requirement for their contribution to be accepted.

3. **Withdrawal:** The contract owner (deployer) can withdraw the accumulated funds from the contract to their account.

## Smart Contract Details

The smart contract for Fund Me is written in Solidity and is designed to accept funding from users and allow the contract owner to withdraw funds. The contract utilizes the Chainlink Price Feed to convert the contributed ETH amount to USD for the minimum funding amount check.

### Contract Functions

The following are the main functions provided by the smart contract:

1. `fund()`: Allows users to fund the contract by sending the specified amount of ETH. The function checks if the contribution meets the minimum funding value in USD before accepting it.

2. `withdraw()`: Allows the contract owner (deployer) to withdraw the accumulated funds from the contract. It transfers the ETH balance of the contract to the owner's address.

3. `getFunder(uint256 index)`: View function that returns the address of a user who has funded the contract based on the given index in the funders array.

4. `getAddressToAmountFunded(address funder)`: View function that returns the amount of ETH funded by a specific user.

5. `getPriceFeed()`: View function that returns the address of the Chainlink Price Feed used in the contract.

### Deployment

To deploy the Fund Me smart contract on your local development environment or the Ethereum mainnet/testnet, you will need:

1. A compatible Ethereum wallet (e.g., MetaMask) to interact with the smart contract.

2. The Solidity contract source code, which can be found in the `contracts` directory.

3. The address of a funded Chainlink Price Feed contract.

### Running the DApp

To run the decentralized application:

1. Ensure you have the required dependencies installed and the smart contract deployed on the desired network.

2. Navigate to the `frontend` directory.

3. Install the necessary dependencies using `npm install`.

4. Update the `contractAddress` in the `fundme.js` file with the deployed smart contract address.

5. Run the DApp using `npm start`.

6. Visit `http://localhost:3000` in your web browser to access the DApp.

## Security Considerations

While efforts have been made to ensure the security and reliability of the smart contract, it is essential to perform a thorough security audit before deploying the contract on the Ethereum mainnet or any other public network.

## Disclaimer

This project is for educational and informational purposes only. Use it at your own risk. The developers of this project are not responsible for any losses or damages that may occur from using this application or the underlying smart contract.

## License

This Fund Me Smart Contract project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the code as per the terms of the license.

For any questions, feedback, or contributions, please contact [Your Contact Email]. Happy funding!
