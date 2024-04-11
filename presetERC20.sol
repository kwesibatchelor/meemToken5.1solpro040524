// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ticker {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isMinter;
    mapping(address => bool) public isPauser;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event RoleGranted(bytes32 indexed role, address indexed account);
    event RoleRevoked(bytes32 indexed role, address indexed account);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        isAdmin[msg.sender] = true;
        isMinter[msg.sender] = true;
        isPauser[msg.sender] = true;
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Not an admin");
        _;
    }

    modifier onlyMinter() {
        require(isMinter[msg.sender], "Not a minter");
        _;
    }

    modifier onlyPauser() {
        require(isPauser[msg.sender], "Not a pauser");
        _;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid recipient");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0) && _to != address(0), "Invalid addresses");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function grantAdmin(address _account) public onlyAdmin {
        isAdmin[_account] = true;
        emit RoleGranted("ADMIN", _account);
    }

    function revokeAdmin(address _account) public onlyAdmin {
        isAdmin[_account] = false;
        emit RoleRevoked("ADMIN", _account);
    }

    function grantMinter(address _account) public onlyAdmin {
        isMinter[_account] = true;
        emit RoleGranted("MINTER", _account);
    }

    function revokeMinter(address _account) public onlyAdmin {
        isMinter[_account] = false;
        emit RoleRevoked("MINTER", _account);
    }

    function grantPauser(address _account) public onlyAdmin {
        isPauser[_account] = true;
        emit RoleGranted("PAUSER", _account);
    }

    function revokePauser(address _account) public onlyAdmin {
        isPauser[_account] = false;
        emit RoleRevoked("PAUSER", _account);
    }

    function mint(address _to, uint256 _value) public onlyMinter {
        totalSupply += _value;
        balanceOf[_to] += _value;
        emit Transfer(address(0), _to, _value);
    }

    function burn(uint256 _value) public {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        totalSupply -= _value;
        balanceOf[msg.sender] -= _value;
        emit Transfer(msg.sender, address(0), _value);
    }

    function pause() public onlyPauser {
        // Additional logic for pausing the contract
    }

    function unpause() public onlyPauser {
        // Additional logic for unpausing the contract
    }
}


/*
// 3 errors re:
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender()); 
        _setupRole(MINTER_ROLE, _msgSender()); 
        _setupRole(PAUSER_ROLE, _msgSender()); 
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract Ticker is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("Ticker Token", "TICK") {
        mint(msg.sender, 1_000_000_010 * 10**18);
    }
}
*/

/*
// 1 error received re: @openzeppelin/contracts/access/Context.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/access/Context.sol";

contract Ticker is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("Ticker Token", "TICK") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender()); // Access _setupRole function from ERC20PresetMinterPauser
        _setupRole(MINTER_ROLE, _msgSender()); // Access _setupRole function from ERC20PresetMinterPauser
        _setupRole(PAUSER_ROLE, _msgSender()); // Access _setupRole function from ERC20PresetMinterPauser
        
        _mint(_msgSender(), 1_000_000_010 * 10**18); // Use _msgSender() to get the address of the caller
    }
}
*/

/*
// 3 errors received re: 
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender()); 
        _setupRole(MINTER_ROLE, _msgSender()); 
        _setupRole(PAUSER_ROLE, _msgSender()); 
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/utils/Context.sol"; // Import Context.sol to access _msgSender()

contract Ticker is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("Ticker Token", "TICK") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender()); // Access _setupRole function from ERC20PresetMinterPauser
        _setupRole(MINTER_ROLE, _msgSender()); // Access _setupRole function from ERC20PresetMinterPauser
        _setupRole(PAUSER_ROLE, _msgSender()); // Access _setupRole function from ERC20PresetMinterPauser
        
        mint(msg.sender, 1_000_000_010 * 10**18);
    }
}
*/