// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Enum {
    enum Operation {
        Call,
        DelegateCall
    }
}

interface ISafe {
    /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction.
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation
    ) external returns (bool success);
}


contract K3Module {
    address public owner;
    ISafe public immutable safe;

    constructor(address _safe) {
        owner = msg.sender;
        safe = ISafe(_safe);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "K3Module: Sender not owner");
        _;
    }

    modifier onlySafe() {
        require(msg.sender == address(safe), "K3Module: Sender not safe");
        _;
    }

    function setOwner(address _owner) external onlySafe() {
        owner = _owner;
    }

    function execute(address payable to, uint256 value, bytes calldata data, Enum.Operation operation) external onlyOwner() {
        require(to != address(safe), "K3Module: To can't be safe address");
        require(safe.execTransactionFromModule(to, value, data, operation), 'K3Module: Transaction Failed');
    }
}
