import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import './ExampleUsdcCoin.sol';
import './ExamplePaxCoin.sol';
import './ExampleTusdCoin.sol';
import './ExampleDaiCoin.sol';

import './DSMath.sol';

pragma solidity ^0.5.8;

contract WUSD is DSMath {
    string public name     = "Wrapped Stablecoins";
    string public symbol   = "WUSD";
    uint8  public decimals = 18;

    ExampleDaiCoin public dai;
    ExampleUsdcCoin public usdc;
    ExampleTusdCoin public tusd;
    ExamplePaxCoin public pax;

    address public _dai;
    address public _usdc;
    address public _tusd;
    address public _pax;



    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;

    uint public totalSupply;

    constructor(ExampleDaiCoin dai_, ExampleUsdcCoin usdc_, ExampleTusdCoin tusd_, ExamplePaxCoin pax_, address dai__, address usdc__, address tusd__, address pax__) public {
      dai = dai_;
      usdc = usdc_;
      tusd = tusd_;
      pax = pax_;
      _dai = dai__;
      _usdc = usdc__;
      _tusd = tusd__;
      _pax = pax__;
      initialDeposit();
    }

    function initialDeposit() internal {
        dai.mint(address(this), 12020000000000000000000);
        usdc.mint(address(this), 12020000000000000000000);
        tusd.mint(address(this), 12020000000000000000000);
        pax.mint(address(this), 12020000000000000000000);

    }

    function deposit(address id, uint wad) public {
        uint mweiAmt = div(wad, SZABO);
        uint wadAmt  = mul(mweiAmt, SZABO);

        if (id == _dai) {
            require(checkDepositPercentOfTotal(id), "Too much DAI in contract");
            require(dai.transferFrom(msg.sender, address(this), wadAmt), "balance insufficient");

        }

        else if (id == _usdc) {
            require(checkDepositPercentOfTotal(id), "Too much usdc in contract");
            require(usdc.transferFrom(msg.sender, address(this), mweiAmt), "balance insufficient");

        }
        else if (id == _tusd) {
            require(checkDepositPercentOfTotal(id), "Too much tsdc in contract");
            require(tusd.transferFrom(msg.sender, address(this), wadAmt), "balance insufficient");

        }
        else if (id == _pax) {
            require(checkDepositPercentOfTotal(id), "Too much pax in contract");
            require(pax.transferFrom(msg.sender, address(this), wadAmt), "balance insufficient");

        }
        else {
           revert("Token not supported");
        }
        balanceOf[msg.sender] = add(balanceOf[msg.sender], wad);
        totalSupply = add(totalSupply, wad);
        emit Deposit(msg.sender, wad);
    }

    function withdraw(address id, uint wad) public {
        require(balanceOf[msg.sender] >= wad);
        uint mweiAmt = div(wad, SZABO);
        uint wadAmt  = mul(mweiAmt, SZABO);
        if (id == _dai) {
            require(checkWithdrawlPercentOfTotal(id), "Too little DAI in contract");
            require(dai.transfer(msg.sender, wadAmt), "insuffucient Dai");
        }

        else if (id == _usdc) {
            require(checkWithdrawlPercentOfTotal(id), "Too little usdc in contract");
            require(usdc.transfer(msg.sender, mweiAmt), "insuffucient usdc");

        }
        else if (id == _tusd) {
            require(checkWithdrawlPercentOfTotal(id), "Too little tsdc in contract");
            require(tusd.transfer(msg.sender, wadAmt), "insuffucient tusd");

        }
        else if (id == _pax) {
            require(checkWithdrawlPercentOfTotal(id), "Too little pax in contract");
            require(pax.transfer(msg.sender, wadAmt), "insuffucient pax");

        }
        else {
           revert("Token not supported");
        }
        balanceOf[msg.sender] = sub(balanceOf[msg.sender], wadAmt);
        totalSupply = sub(totalSupply, wadAmt);
        emit Withdrawal(msg.sender, wad);
    }

    function checkDepositPercentOfTotal(address id) public view returns (bool) {
        if (id == _dai && dai.balanceOf(address(this)) / 4 < 30) {
            return true;
        } else if (id == _usdc && usdc.balanceOf(address(this)) / 4 < 30) {
            return true;
        } else if (id == _tusd && tusd.balanceOf(address(this)) / 4 < 30) {
            return true;
        }
        else if (id == _pax && pax.balanceOf(address(this)) / 4 < 30) {
            return true;
        }
        else {
            return false;
        }
    }

    function checkWithdrawlPercentOfTotal(address id) public view returns (bool) {
        if (id == _dai && dai.balanceOf(address(this)) / 4 > 20) {
            return true;
        } else if (id == _usdc && usdc.balanceOf(address(this)) / 4 > 20) {
            return true;
        } else if (id == _tusd && tusd.balanceOf(address(this)) / 4 > 20) {
            return true;
        }
        else if (id == _pax && pax.balanceOf(address(this)) / 4 > 20) {
            return true;
        }
        else {
            return false;
        }
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
