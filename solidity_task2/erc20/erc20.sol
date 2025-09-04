// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ecr20{
    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowedBalance;

    event Transfer(address indexed from,address indexed to, uint256 value,uint256 account);
    event Approve(address indexed from,address indexed to,uint256 value);
    
    address public owner;
    constructor(){
        owner = msg.sender;
    }


    function balanceOf (address account) public view returns (uint256){
        return balances[account];
    } 

    function transfer (address to, uint256 amount) external returns (bool){
        require(msg.sender != address(0),"Transfer from address cant be null!");
        require(to != address(0),"Transfer to address cant be null!");
        require(balances[msg.sender] >= amount,"no enough money to transfer!");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount,balances[msg.sender]);
        return true;
    }

    function TransferFrom(address from, address to, uint256 amount) external returns (bool){
        require(from != address(0) && to != address(0),"address cant be null!");
        require(balances[from] >= amount,"no enough money to transfer!");
        require(allowedBalance[from][msg.sender] >= amount,"Allowance exceded");

        balances[from] -= amount;
        balances[to] += amount;
        allowedBalance[from][msg.sender] -= amount;
        emit Transfer(from, to, amount,balances[from]);
        return true;
    }
    
    function approve(address allow,uint256 amount) external returns(bool){
        require(allow != address(0),"address cant be null!");
        require(msg.sender != address(0),"");
        
        allowedBalance[msg.sender][allow] = amount;
        emit Approve(msg.sender,allow,amount);
        return true;
    }

    function mint(address to ,uint256 amount) external returns(bool){
        require(msg.sender == owner,"Only owner can mint");
        require(to != address(0),"address cant be null");
        balances[to] += amount;
        emit Transfer(address(0), to, amount,balances[to]);
        return true;
    }



}