// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;


struct UnsignedTransactionData {
  uint256 amount;
  uint256 expiry;
  bytes32 digest;
}

interface ITransactionManager {
  // Structs
  struct TransactionData {
    address user;
    address router;
    uint256 amount;
    address sendingAssetId;
    address receivingAssetId;
    uint24 sendingChainId;
    uint24 receivingChainId;
    address receivingAddress; // if calling fails, or isnt used, this is the address the funds are sent to
    bytes callData;
    // TODO: consider using global nonce instead of transactionId
    bytes32 transactionId;
    uint256 expiry;
  }

  struct SignedTransactionData {
    address user;
    address router;
    address sendingAssetId;
    address receivingAssetId;
    uint24 sendingChainId;
    uint24 receivingChainId;
    address receivingAddress;
    bytes callData;
    // TODO: consider using global nonce instead of transactionId
    bytes32 transactionId;
  }

  // Liquidity events
  event LiquidityAdded(
    address router,
    address assetId,
    uint256 amount
  );

  event LiquidityRemoved(
    address router,
    address assetId,
    uint256 amount,
    address recipient
  );

  // Transaction events
  // TODO: structure
  event TransactionPrepared(
    TransactionData txData,
    address caller
  );

  event TransactionFulfilled(
    TransactionData txData,
    bytes signature,
    address caller
  );

  event TransactionCancelled(
    TransactionData txData,
    address caller
  );

  // Getters

  // Router only methods
  function addLiquidity(uint256 amount, address assetId) external payable;

  function removeLiquidity(uint256 amount, address assetId, address payable recipient) external;

  // Transaction methods
  function prepare(TransactionData calldata txData) external payable returns (bytes32);

  function fulfill(TransactionData calldata txData, bytes calldata signature) external;

  function cancel(TransactionData calldata txData) external;
}