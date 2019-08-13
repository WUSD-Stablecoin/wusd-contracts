import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

pragma solidity ^0.5.8;

contract ExampleTusdCoin is ERC20 {
  string public name = "ExampleTUSDCoin"; 
  string public symbol = "TUSD";
  uint public decimals = 18;

  constructor () public {
    _mint(msg.sender, 12020000000000000000000);
  }
}