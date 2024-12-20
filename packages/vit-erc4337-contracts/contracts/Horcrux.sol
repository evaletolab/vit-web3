pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

// FIXME use upgrade contracts
// https://docs.openzeppelin.com/learn/upgrading-smart-contracts
// https://medium.com/coinmonks/upgrading-smart-contracts-with-openzeppelin-upgrades-plugins-in-typescript-hardhat-dd5ca6d01585
contract Horcrux {
  //01 0x8312c1d40a7417364d711fe93578dee347da4553106f2a0ac8563950
  struct Vault {
    bytes1 id;
    bytes28 sss;
  }

  mapping (bytes32 => uint256) public onetime;


  // (to be validated)
  // using log instead memory to preserve gas cost 
  event HorcruxVault(uint block, uint horcrux);

  constructor() {
  }

  //
  // Source is the destination place of the Horcrux
  // Horcrux is the encrypted shamir secret part
  function create(bytes32 secret, uint horcrux ) external {
    require((onetime[secret]) == 0 ,"Horcrux: this destination is not available"); // cost 47 gas
    onetime[(secret)] = uint256(horcrux);
  }

  //
  // The Seed and the Nonce are elements that becomes the destination place of the Horcrux
  function recovery(bytes32 seed, bytes32 salt) external view returns(bool) {
    bytes32 hash = (keccak256(abi.encodePacked(seed,salt)));
    bytes32 secret =bytes32(keccak256(abi.encodePacked(hash)));
    // bool ok = bool(onetime[secret]);
    // delete onetime[secret];
    // return ok;
  }

  //
  // fallback is mandatory to exec relayer
  fallback() external isWallet{   
  }  

  modifier isWallet() {
    uint x;
    // This opcode returns the size of the code on an address. If the size is larger than zero, the address is a contract
    // https://ethereum.stackexchange.com/questions/45095/how-could-msg-sender-tx-origin-and-extcodesizecaller-0-be-true/45111
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }
}

