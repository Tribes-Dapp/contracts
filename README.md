# Contracts 📚

Welcome to the project documentation! This repository contains essential documentation to guide you through the setup and usage of the project. Follow the steps below to get started:

## 1. Setting Up Environment 🌍

- Before you begin, make sure you have the required environment variables properly configured. Create an environment by executing the following command:

    ```bash
    $ make env
    ```

- Ensure you provide the necessary parameters in the generated environment file.

### 2.1 Deploy on testnet 🌐

- To implement the plugin contract (Proxy) in testnet, run the command below:

> [!IMPORTANT]
> Before deploying the above contract, it is necessary to modify the salt contained in [path](https://github.com/Tribes-Dapp/contracts/blob/main/script/utils/Helper.sol). Behind this implementation, we have a deterministic deployment; if the salt is not changed, the transaction will be reverted by the network.

    ```bash
    $ make plugin
    ```

 
- To call the Tribe contract bytecode, run the command bellow:

> [!IMPORTANT]
> Before call this script, it is necessary to modify the dapp address contained in [path](https://github.com/Tribes-Dapp/contracts/blob/main/script/TribeBytecode.s.sol).

    ```bash
    $ make bytecode
    ```

## 3. System Architecture 📐

```mermaid
graph TD
    classDef core fill:#ffe95a,color:#000
    classDef external fill:#85b4ff,color:#000
    classDef hasLink text-decoration: underline

    InputBox[Input Box]:::core
    CartesiDApp[Cartesi DApp]:::core
    CartesiDAppFactory[Cartesi DApp Factory]:::core
    EtherPortal[Ether Portal]:::core
    ERC20Portal[ERC-20 Portal]:::core
    ERC721Portal[ERC-721 Portal]:::core
    ERC1155SinglePortal[ERC-1155 Single Transfer Portal]:::core
    ERC1155BatchPortal[ERC-1155 Batch Transfer Portal]:::core
    DAppAddressRelay[DApp Address Relay]:::core
    Consensus:::external

    ERC20[Any ERC-20 token]:::external
    ERC721[Any ERC-721 token]:::external
    ERC1155[Any ERC-1155 token]:::external
    DAppOwner[Cartesi DApp Owner]:::external
    Anyone1[Anyone]:::external
    Anyone2[Anyone]:::external
    Anyone3[Anyone]:::external

    Anyone1 -- executeVoucher --> CartesiDApp
    Anyone1 -. validateNotice .-> CartesiDApp
    Anyone1 -- newApplication --> CartesiDAppFactory
    DAppOwner -- migrateToConsensus ---> CartesiDApp
    CartesiDApp -. getClaim .-> Consensus
    CartesiDApp -- withdrawEther --> CartesiDApp
    CartesiDAppFactory == creates ==> CartesiDApp
    Anyone2 -- addInput -------> InputBox
    Anyone2 -- depositEther ---> EtherPortal
    EtherPortal -- "Ether transfer" ----> Anyone3
    EtherPortal -- addInput -----> InputBox
    Anyone2 -- depositERC20Tokens ---> ERC20Portal
    ERC20Portal -- transferFrom ----> ERC20
    ERC20Portal -- addInput -----> InputBox
    Anyone2 -- depositERC721Token ---> ERC721Portal
    ERC721Portal -- safeTransferFrom ----> ERC721
    ERC721Portal -- addInput -----> InputBox
    Anyone2 -- depositSingleERC1155Token ---> ERC1155SinglePortal
    ERC1155SinglePortal -- safeTransferFrom ----> ERC1155
    ERC1155SinglePortal -- addInput -----> InputBox
    Anyone2 -- depositBatchERC1155Token ---> ERC1155BatchPortal
    ERC1155BatchPortal -- safeBatchTransferFrom ----> ERC1155
    ERC1155BatchPortal -- addInput -----> InputBox
    Anyone2 -- relayDAppAddress ---> DAppAddressRelay
    DAppAddressRelay -- addInput -----> InputBox

    class ERC20,ERC721,ERC1155 hasLink
    click ERC20 href "https://eips.ethereum.org/EIPS/eip-20"
    click ERC721 href "https://eips.ethereum.org/EIPS/eip-721"
    click ERC1155 href "https://eips.ethereum.org/EIPS/eip-1155"
```

## 4. Contracts Addresses 🔍

- Deployer Plugin():``
- KYCVerifier():``
- Cartesi Dapp():``

## 5. Viewing Documentation Locally 💻

View the generated documentation locally by serving it on a local server at port 4002. Use:

```bash
$ forge doc --serve --port 4002
```

Access the documentation through your web browser by navigating to <http://localhost:4002>.
