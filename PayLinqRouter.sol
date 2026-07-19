// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title PayLinqRouter
/// @notice Payment router for PayLinq (https://paylinq.vercel.app) on Arc.
///         Routes native USDC payments and records every payment onchain
///         with an event containing payer, recipient, amount and invoice memo.
///         Holds no funds — value is forwarded to the recipient atomically.
/// @dev    On Arc, USDC is the native gas token (18 decimals for native value).
contract PayLinqRouter {
    /// @notice Emitted for every successful payment routed through PayLinq.
    event PaymentSent(
        uint256 indexed paymentId,
        address indexed payer,
        address indexed recipient,
        uint256 amount,
        string memo
    );

    /// @notice Total number of payments routed through this contract.
    uint256 public totalPayments;

    /// @notice Total native USDC volume (18 decimals) routed through this contract.
    uint256 public totalVolume;

    error ZeroAmount();
    error ZeroAddress();
    error SelfPayment();
    error TransferFailed();

    /// @notice Pay `recipient` the attached native USDC value, recording `memo` onchain.
    /// @param recipient The address receiving the payment.
    /// @param memo      Invoice memo / reference (max ~120 chars recommended).
    /// @return paymentId Sequential id of this payment.
    function pay(address recipient, string calldata memo)
        external
        payable
        returns (uint256 paymentId)
    {
        if (msg.value == 0) revert ZeroAmount();
        if (recipient == address(0)) revert ZeroAddress();
        if (recipient == msg.sender) revert SelfPayment();

        unchecked {
            paymentId = ++totalPayments;
            totalVolume += msg.value;
        }

        (bool ok, ) = recipient.call{value: msg.value}("");
        if (!ok) revert TransferFailed();

        emit PaymentSent(paymentId, msg.sender, recipient, msg.value, memo);
    }
}
