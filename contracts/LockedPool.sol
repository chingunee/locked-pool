// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import "./interface/ILockedPool.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// @title Locked Pool
/// @notice A staking pool for employments and market.
contract LockedPool is ILockedPool, Pausable, Ownable2Step, ReentrancyGuard {
    using SafeERC20 for IERC20;
    uint256 public unlockTimePoolOfMarket;
    uint256 public unlockTimePoolOfEmployments;
    IERC20 public immutable token;

    // (tokenAddress => stakerAddress => stakedAmount)
    mapping(address => mapping(address => uint256)) public balanceOfMarket;

    // (tokenAddress => stakerAddress => stakedAmount)
    mapping(address => mapping(address => uint256)) public balanceOfEmployments;

    constructor(address _owner, address _tokenAddress, uint256 _unlockTimePoolOfMarket, uint256 _unlockTimePoolOfEmployments) Ownable(_owner) {
        require(_tokenAddress != address(0), "Token address cannot be zero");
        require(
            block.timestamp < _unlockTimePoolOfMarket && block.timestamp < _unlockTimePoolOfEmployments,
            "Unlock time should be in the future"
        );
        token = IERC20(_tokenAddress);
        unlockTimePoolOfMarket = _unlockTimePoolOfMarket;
        unlockTimePoolOfEmployments = _unlockTimePoolOfEmployments;
    }

    /*//////////////////////////////////////////////////////////////
                            Staker Functions
    //////////////////////////////////////////////////////////////*/

    function depositForMarketPool(address _for, uint256 _amount) whenNotPaused external {
        if (_amount == 0) revert DepositAmountCannotBeZero();
        if (_for== address(0)) revert CannotDepositForZeroAddress();

        address tokenAddress = address(token);
        balanceOfMarket[tokenAddress][_for] += _amount;
        emit Deposit(_for, tokenAddress, _amount);

        token.safeTransferFrom(msg.sender, address(this), _amount);
    }

    function depositForEmploymentPool(address _for, uint256 _amount) whenNotPaused external {
        if (_amount == 0) revert DepositAmountCannotBeZero();
        if (_for== address(0)) revert CannotDepositForZeroAddress();
        
        address tokenAddress = address(token);
        balanceOfEmployments[tokenAddress][_for] += _amount;
        emit Deposit(_for, tokenAddress, _amount);

        token.safeTransferFrom(msg.sender, address(this), _amount);
    }

    function withdrawMarketPool(uint256 _amount) public nonReentrant whenNotPaused {
        require(_amount > 0, "WithdrawAmountCannotBeZero");
        require(block.timestamp >= unlockTimePoolOfMarket, "You can't withdraw yet");
        
        address tokenAddress = address(token);
        require(balanceOfMarket[tokenAddress][msg.sender] >= _amount, "Insufficient balance");
        
        balanceOfMarket[tokenAddress][msg.sender] -= _amount;
        emit Withdraw(msg.sender, tokenAddress, _amount);

        token.safeTransfer(msg.sender, _amount);
    }

    function withdrawEmploymentPool(uint256 _amount) public nonReentrant whenNotPaused {
        require(_amount > 0, "WithdrawAmountCannotBeZero");
        require(block.timestamp >= unlockTimePoolOfEmployments, "You can't withdraw yet");

        address tokenAddress = address(token);
        require(balanceOfEmployments[tokenAddress][msg.sender] >= _amount, "Insufficient balance");

        balanceOfEmployments[tokenAddress][msg.sender] -= _amount;
        emit Withdraw(msg.sender, tokenAddress, _amount);

        token.safeTransfer(msg.sender, _amount);
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