// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// First implementation contract with basic functionality
contract LogicV1 {
    // Storage variable for a number (stored in the proxy via delegatecall)
    uint256 public number;

    // Function to update the number
    function updateNumber(uint256 _value) public {
        number = _value;
    }

    // Function to get the current version of the logic contract
    function getVersion() public pure returns (string memory) {
        return "V1";
    }
}

// Second implementation contract with upgraded functionality
contract LogicV2 {
    // Storage variable for a number (must match LogicV1's layout to avoid collisions)
    uint256 public number;

    // Function to update the number (same as V1)
    function updateNumber(uint256 _value) public {
        number = _value;
    }

    // Updated function to get the new version
    function getVersion() public pure returns (string memory) {
        return "V2";
    }

    // New function added in V2
    function incrementNumber() public {
        number = number + 1;
    }
}

// Proxy contract implementing the Transparent Proxy Pattern
contract TransparentProxy {
    // Address of the current implementation contract
    address public implementation;

    // Address of the admin who can perform upgrades
    address public admin;

    // Constructor to set the initial implementation and admin
    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender; // Deployer is the admin
    }

    // Modifier to restrict functions to the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Function to upgrade the implementation contract (admin only)
    function upgradeImplementation(address _newImplementation) public onlyAdmin {
        implementation = _newImplementation;
    }

    // Fallback function to delegate calls to the implementation contract
    fallback() external payable {
        // Get the current implementation address
        address impl = implementation;

        // Ensure the implementation is set
        require(impl != address(0), "Implementation not set");

        // Delegate the call to the implementation contract
        (bool success, ) = impl.delegatecall(msg.data);

        // Ensure the delegatecall was successful
        require(success, "Delegatecall failed");
    }

    // Receive function to handle plain ETH transfers
    receive() external payable {}
}