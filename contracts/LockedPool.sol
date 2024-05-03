// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import "./interface/ILockedPool.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/// @title Locked Pool
/// @notice A staking pool for employments and market.
contract LockedPool is ILockedPool, Pausable, Ownable2Step{
    uint256 public unlockTimePoolOfMarket;
    uint256 public unlockTimePoolOfEmployments;

    // (tokenAddress => isAllowedForStaking)
    mapping(address => bool) public tokenAllowlist;

    // (tokenAddress => stakerAddress => stakedAmount)
    mapping(address => mapping(address => uint256)) public balanceOfMarket;

    // (tokenAddress => stakerAddress => stakedAmount)
    mapping(address => mapping(address => uint256)) public balanceOfEmployments;

    constructor(address _owner, uint256 _unlockTimePoolOfMarket, uint256 _unlockTimePoolOfEmployments) Ownable(_owner) {
        require(
            block.timestamp < _unlockTimePoolOfMarket && block.timestamp < _unlockTimePoolOfEmployments,
            "Unlock time should be in the future"
        );
        unlockTimePoolOfMarket = _unlockTimePoolOfMarket;
        unlockTimePoolOfEmployments = _unlockTimePoolOfEmployments;
        // uint256 length = _tokensAllowed.length;
        // for(uint256 i; i < length; ++i){
        //     if (_tokensAllowed[i] == address(0)) revert TokenCannotBeZeroAddress();
        //     tokenAllowlist[_tokensAllowed[i]] = true;
        // }
    }

    function addTokenAllowlist(address[] memory _tokensAllowed) onlyOwner public{
        uint256 length = _tokensAllowed.length;
                for(uint256 i; i < length; ++i){
            if (_tokensAllowed[i] == address(0)) revert TokenCannotBeZeroAddress();
            tokenAllowlist[_tokensAllowed[i]] = true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                            Staker Functions
    //////////////////////////////////////////////////////////////*/

    function depositForMarketPool(address _token, address _for, uint256 _amount) whenNotPaused external {
        if (_amount == 0) revert DepositAmountCannotBeZero();
        if (_for== address(0)) revert CannotDepositForZeroAddress();
        if (!tokenAllowlist[_token]) revert TokenNotAllowedForStaking();

        balanceOfMarket[_token][_for] += _amount;

        emit Deposit(_for, _token, _amount);

        IERC20(_token).transferFrom(msg.sender, address(this), _amount);   
    }

    function depositForEmploymentPool(address _token, address _for, uint256 _amount) whenNotPaused external {
        if (_amount == 0) revert DepositAmountCannotBeZero();
        if (_for== address(0)) revert CannotDepositForZeroAddress();
        if (!tokenAllowlist[_token]) revert TokenNotAllowedForStaking();

        balanceOfEmployments[_token][_for] += _amount;

        emit Deposit(_for, _token, _amount);

        IERC20(_token).transferFrom(msg.sender, address(this), _amount);   
    }

    function withdrawMarketPool(address _token, uint256 _amount) public {
        if (_amount == 0) revert WithdrawAmountCannotBeZero();
        require(block.timestamp >= unlockTimePoolOfMarket, "You can't withdraw yet");
        
        // Check if the user has sufficient balance to withdraw
        require(balanceOfMarket[_token][msg.sender] >= _amount, "Insufficient balance");
        
        balanceOfMarket[_token][msg.sender] -= _amount;
        emit Withdraw(msg.sender, _token, _amount);

        IERC20(_token).transfer(msg.sender, _amount);       
    }

    function withdrawEmploymentPool(address _token, uint256 _amount) public {
        if (_amount == 0) revert WithdrawAmountCannotBeZero();
        require(block.timestamp >= unlockTimePoolOfEmployments, "You can't withdraw yet");
        
        // Check if the user has sufficient balance to withdraw
        require(balanceOfEmployments[_token][msg.sender] >= _amount, "Insufficient balance");
        
        balanceOfEmployments[_token][msg.sender] -= _amount;
        emit Withdraw(msg.sender, _token, _amount);

        IERC20(_token).transfer(msg.sender, _amount);
    }

    /**
     * @inheritdoc ILockedPool
     */
    function pause() external onlyOwner whenNotPaused {
        _pause();
    }

    /**
     * @inheritdoc ILockedPool
     */
    function unpause() external onlyOwner whenPaused{
        _unpause();
    }
}