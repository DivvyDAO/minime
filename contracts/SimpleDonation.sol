//import "MiniMeToken.sol";
contract Donate {
    address public owner;
    uint public totalCollected; 
    uint price = 1;
    address token; // minime token contract address
    
    function donate() {
        if (msg.value > 0) {
            // TODO why is transferFrom not found.
            token.transferFrom(token, msg.sender, msg.value*price);
        }
    }
}