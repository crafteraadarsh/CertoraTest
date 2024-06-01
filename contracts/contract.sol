pragma solidity ^0.8.0


/**
 * @notice Takes tokens
 * @dev Only the current locker can call this function
 */
function take(bool isQuoteAsset, address to, uint256 amount) external onlyByLocker {
  globalData.take(isQuoteAsset, to, amount);
}


modifier onlyByLocker() {
  address locker = globalData.lockData.locker;
  if (msg.sender != locker) revert LockedBy(locker);
  _;
}
function trade(GlobalDataLibrary.GlobalData storage globalData, IPredyPool.TradeParams memory tradeParams, bytes memory settlementData) external returns (IPredyPool.TradeResult memory tradeResult) {
  DataType.PairStatus storage pairStatus = globalData.pairs[tradeParams.pairId];

  // update interest growth
  ApplyInterestLib.applyInterestForToken(globalData.pairs, tradeParams.pairId);

  // update rebalance interest growth
  Perp.updateRebalanceInterestGrowth(pairStatus, pairStatus.sqrtAssetStatus);

  tradeResult = Trade.trade(globalData, tradeParams, settlementData);

  globalData.vaults[tradeParams.vaultId].margin += tradeResult.fee + tradeResult.payoff.perpPayoff + tradeResult.payoff.sqrtPayoff;

  (tradeResult.minMargin, , , tradeResult.sqrtTwap) = PositionCalculator.calculateMinDeposit(pairStatus, globalData.vaults[tradeParams.vaultId], DataType.FeeAmount(0, 0));

  // The caller deposits or withdraws margin from the callback that is called below.
  callTradeAfterCallback(globalData, tradeParams, tradeResult);

  // check vault safety
  tradeResult.minMargin = PositionCalculator.checkSafe(pairStatus, globalData.vaults[tradeParams.vaultId], DataType.FeeAmount(0, 0));

  emit PositionUpdated(tradeParams.vaultId, tradeParams.pairId, tradeParams.tradeAmount, tradeParams.tradeAmountSqrt, tradeResult.payoff, tradeResult.fee);
}