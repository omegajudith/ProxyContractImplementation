// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract SelfDestruct {
    address payable public etherVault;

    constructor(address payable _etherVault) payable {
        require(msg.value == 0.0005 ether, "Must send exactly 0.0005 ether");
        etherVault = _etherVault;
    }

    function destroy() external {
        (bool sent, ) = etherVault.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}
