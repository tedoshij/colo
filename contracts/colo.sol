// Exists simply to exist.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract COLO is ERC20 {

    constructor() ERC20("COLO", "COLO") payable {
        _mint(msg.sender, 888888888888 * 10 ** decimals());              
    }
    event BatchTransferCOLO(address indexed _caller, uint256 _recipientCount, uint256 _totalTokensSent);    
	 
    function sendBatchCOLO(address[] calldata walletAddresses, uint256[] calldata sendAmounts) payable external returns (bool) {
        uint256 walletCount = walletAddresses.length;
        require(walletCount == sendAmounts.length, "Check length of walletAddresses / sendAmounts arrays.");
        uint256 senderBalance = balanceOf(msg.sender);
        uint256 totalSentCOLO = 0;
        uint256 sendAmount;
        uint256 decimalPlaces = 10 ** 18;
        for(uint i = 0; i < walletCount; i++) {
            sendAmount = sendAmounts[i] * decimalPlaces;
            require(sendAmount <= senderBalance, "Sending more then sender has remaining.");
            _transfer(msg.sender, walletAddresses[i], sendAmount);
            totalSentCOLO = totalSentCOLO + sendAmount;
            senderBalance = senderBalance - sendAmount;
        }
        emit BatchTransferCOLO(msg.sender, walletAddresses.length, totalSentCOLO);
        return true;
    } 
    function sendBatchCOLOSameValue(address[] calldata walletAddresses, uint256 sendValue) payable external returns (bool) {
        uint256 walletCount = walletAddresses.length;
        uint256 senderBalance = balanceOf(msg.sender);
        uint256 totalSentCOLO = 0;
        uint256 sendAmount = sendValue * 10 ** 18;
        
        for(uint i = 0; i < walletCount; i++) {
            require(sendAmount <= senderBalance, "Sending more then sender has remaining.");
            _transfer(msg.sender, walletAddresses[i], sendAmount);
            totalSentCOLO = totalSentCOLO + sendAmount;
            senderBalance = senderBalance - sendAmount;
        }
        emit BatchTransferCOLO(msg.sender, walletAddresses.length, totalSentCOLO);
        return true;
    }     

}
