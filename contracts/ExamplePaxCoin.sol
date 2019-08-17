import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

pragma solidity ^0.5.8;

contract ExamplePaxCoin is ERC20 {
  string public name = "ExamplePAXCoin"; 
  string public symbol = "PAX";
  uint public decimals = 18;

  constructor () public {
    _mint(msg.sender, 12020000000000000000000);
  }
   function mint(address to, uint amount) public {
    _mint(to, amount);
  } 
}