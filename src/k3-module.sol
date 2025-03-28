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

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Executed(address indexed to, uint256 value, bytes data, Enum.Operation operation);

    error NotOwner();
    error NotSafe();
    error InvalidAddress();

    /// @notice Initializes the module with a Safe address.
    /// @param _safe The address of the safe contract.
    constructor(address _safe) {
        if (_safe == address(0)) revert InvalidAddress();
        owner = msg.sender;
        safe = ISafe(_safe);
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier onlySafe() {
        if (msg.sender != address(safe)) revert NotSafe();
        _;
    }

    /// @notice Allows the safe to update the owner.
    /// @param _owner The new owner address.
    function setOwner(address _owner) external onlySafe {
        if (_owner == address(0)) revert InvalidAddress();
        address previousOwner = owner;
        owner = _owner;
        emit OwnershipTransferred(previousOwner, _owner);
    }

    /// @notice Executes a transaction from the safe.
    /// @param to The destination address.
    /// @param value The Ether value to send.
    /// @param data The data payload for the transaction.
    /// @param operation The operation type (Call or DelegateCall).
    function execute(
        address payable to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation
    ) external onlyOwner {
        require(to != address(safe), "K3-Safe-Module: To can't be safe address");
        require(to != address(this), "K3-Safe-Module: To can't be module address");
        bool success = safe.execTransactionFromModule(to, value, data, operation);
        require(success, "K3-Safe-Module: Transaction Failed");
        emit Executed(to, value, data, operation);
    }
}
