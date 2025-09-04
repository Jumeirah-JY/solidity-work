// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BeggingContract{
    address payable public owner;

    uint256 public donationStartTime;

    //捐赠期为7天
    uint256 public constant DONATION_PERIOD = 30 days;

    constructor(){
        owner = payable (msg.sender);
        donationStartTime = block.timestamp;
    }

    event donated(address indexed from,uint256 amount,uint timestamp);

    mapping(address => uint256) public DonationAmount;

    //捐赠金额排行榜
    Donor[3] public TopDonors;

    struct Donor{
        address donorAddress;
        uint amount;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"you are not owner!");
        _;
    }

    modifier onlyTime(){
        require(block.timestamp >= donationStartTime && block.timestamp <= donationStartTime + DONATION_PERIOD,"donation time is out!");
        _;
    }

    function donate() external payable onlyTime{
        require(msg.value > 0 ,"donation amount must greater than 0!");
        DonationAmount[msg.sender] += msg.value;
        updateTopDonors(msg.sender);
        emit donated(msg.sender,msg.value,block.timestamp);
    }

    function withdraw() external onlyOwner{
        uint256 balance = address(this).balance;
        require(balance > 0 , "no found to withdraw");
        owner.transfer(balance);
    }

    function getDonation(address donator) external view returns (uint256 amount){
        return DonationAmount[donator];
    }

    function updateTopDonors(address donor) internal {
        uint256 currentDonation = DonationAmount[donor];
        //检查是否应该进入排行榜
        for(uint256 i = 0;i < 3;i++){
            if(currentDonation > TopDonors[i].amount){
                for(uint j=2;j>i;j--){
                   TopDonors[j] =  TopDonors[j-1];
                }
                TopDonors[i] = Donor(donor,currentDonation);
                break;
            }
        }
    }
}