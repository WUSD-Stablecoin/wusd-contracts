import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import './DSMath.sol';

pragma solidity ^0.5.8;

contract WUSD is DSMath {
    string public name     = "Wrapped Stablecoins";
    string public symbol   = "WUSD";
    uint8  public decimals = 18;

    ERC20 public dai;
    ERC20 public usdc;
    ERC20 public tusd;
    ERC20 public pax;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;

    uint public totalSupply;

    constructor(ERC20 dai_, ERC20 usdc_, ERC20 tusd_, ERC20 pax_) public {
      dai  = dai_;
      usdc = usdc_;
      tusd = tusd_;
      pax  = pax_;
    }

    function deposit(uint wad) public {
        uint mweiAmt = div(div(wad, MWEI), 4);
        uint wadAmt  = mul(mweiAmt, MWEI);
        wad = mul(wadAmt, 4);
        require(dai.transferFrom(msg.sender, address(this), wadAmt));
        require(usdc.transferFrom(msg.sender, address(this), mweiAmt));
        require(tusd.transferFrom(msg.sender, address(this), wadAmt));
        require(pax.transferFrom(msg.sender, address(this), wadAmt));
        balanceOf[msg.sender] = add(balanceOf[msg.sender], wad);
        totalSupply = add(totalSupply, wad);
        emit Deposit(msg.sender, wad);
    }
    function withdraw(uint wad) public {
        require(balanceOf[msg.sender] >= wad);
        uint mweiAmt = div(div(wad, MWEI), 4);
        uint wadAmt  = mul(mweiAmt, MWEI);
        wad = mul(wadAmt, 4);
        balanceOf[msg.sender] = sub(balanceOf[msg.sender], wad);
        totalSupply = sub(totalSupply, wad);
        require(dai.transfer(msg.sender, wadAmt));
        require(usdc.transfer(msg.sender, mweiAmt));
        require(tusd.transfer(msg.sender, wadAmt));
        require(pax.transfer(msg.sender, wadAmt));
        emit Withdrawal(msg.sender, wad);
    }

    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad);

        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
        }

        balanceOf[src] = sub(balanceOf[src], wad);
        balanceOf[dst] = add(balanceOf[dst], wad);

        emit Transfer(src, dst, wad);

        return true;
    }
}
