
//ABC:
//Attacker take advantage of the way how EVM deal with sendCoin's parameters. Ideally, attacker construct one address belongs to himself(eg: 0x1234567890123456789012345678901234567800). So attacker invoke sendCoin like this: sendCoin(0x12345678901234567890123456789012345678, 1), which makes EVM left shift "to" and "value"(to<<8/value<<8). So EVM constructs an address belongs to attacker(0x1234567890123456789012345678901234567800), and value = (1<<8) = 256. So finally, attacker get 256 tokens from token contract address.

// some clues:
// https://www.dasp.co/index.html#item-9
// https://github.com/OpenZeppelin/zeppelin-solidity/issues/261

pragma solidity ^0.4.11;

contract VictimToken {

	mapping (address => uint) balances;
	event Transfer(address _from, address _to, uint256 value);

	function VictimToken() {
		balances[tx.origin] = 100000;
	}

	function sendCoin (address to, uint256 value) returns (bool) {
		if (balances[msg.sender] < value) 
			return false;
		balances[msg.sender] -= value;
		balances[to] += value;
		Transfer(msg.sender, to, value);
		return true;
	}

	function getBalance (address addr) constant returns (uint) {
		return balances[addr];
	}
}
