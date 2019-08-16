import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

pragma solidity ^0.5.8;

contract ExampleUsdcCoin is ERC20 {
  string public name = "ExampleUSDCCoin"; 
  string public symbol = "USDC";
  uint public decimals = 6;

  constructor () public {
    _mint(msg.sender, 12020000000000000000000);
  }
   function mint(address to, uint amount) public {
    _mint(to, amount);
  } 
}