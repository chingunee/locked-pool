// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

/// @title Locked Pool Interface
/// @notice An interface containing externally accessible functions of the LockedPool contract
/// @dev The automatically generated public view functions for the state variables and mappings are not included in the interface
interface ILockedPool {
    /*//////////////////////////////////////////////////////////////
                            Errors
    //////////////////////////////////////////////////////////////*/

    error TokenCannotBeZeroAddress(); // Thrown when the specified token is the zero address
    error DepositAmountCannotBeZero(); // Thrown if staker attempts to call deposit() with zero amount
    error WithdrawAmountCannotBeZero(); //Thrown if staker attempts to call withdraw() with zero amount
    error TokenNotAllowedForStaking(); // Thrown if staker attempts to stake unsupported token (or token disabled for staking)
    error CannotDepositForZeroAddress(); //Thrown if caller tries to deposit on behalf of the zero address

    /*//////////////////////////////////////////////////////////////
                            Staker Events
    //////////////////////////////////////////////////////////////*/

    ///@notice Emitted when a staker deposits/stakes a supported token into the Locked Pool
    ///@param depositor The address of the depositer/staker transfering funds to the Locked Pool
    ///@param token The address of the token deposited/staked into the pool
    ///@param amount The amount of token deposited/staked into the pool
    event Deposit(
        address indexed depositor, 
        address indexed token, 
        uint256 amount
    );

    ///@notice Emitted when a staker withdraws a previously staked tokens from the Locked Pool
    ///@param withdrawer The address of the staker withdrawing funds from the Locked Pool
    ///@param token The address of the token being withdrawn from the pool
    ///@param amount The amount of tokens withdrawn the pool
    event Withdraw(address indexed withdrawer, address indexed token, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////*/

    ///@notice Pause further staking through the deposit function.
    ///@dev Only callable by the owner. Withdrawals and migrations will still be possible when paused
    function pause() external;

    ///@notice Unpause staking allowing the deposit function to be used again
    ///@dev Only callable by the owner
    function unpause() external;
}