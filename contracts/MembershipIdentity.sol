// work in progress, starting from a simple solidity example, comment and suggest edits.
// TODO make Owned?
contract MemberIdentityRegistry {

    address owner = msg.sender;
    address wallet; // wallet to receive membership fees
    mapping(address => mapping(bytes32 => uint256)) verified;
    mapping(address => mapping(bytes32 => uint256)) claimed;  
    mapping(address => mapping(bytes32 => uint256)) code;
    mapping(address => address) uPortAddress; // future use
    
    event Registered(uint256 hash);
    event Verified(uint256 hash);

    function claimIdHash(bytes32 factor, uint256 hash) {
        // receive eth coop membership fee
	    if(msg.value != 1 ether) throw;
	    if ( ! wallet.send(msg.value) ) throw;
        claimed[msg.sender][factor] = hash;
        Registered(hash);
    }

    function verifyCode(bytes32 factor,uint256 key) {
        uint256 encrypted = code[msg.sender];
        // TODO decode encrypted with key better than product of primes
        bool decoded = encrypted == (key % 1000000) * (key/1000000);
        if ( decoded ) {
            int256 hash = claimed[msg.sender][factor];
            verified[msg.sender][factor] = hash;
            verified[msg.sender]["email"] = hash;
            Verified(hash);
            return true;
        }
        return false;
    }

    function setCode(address who, int256 encrypted) {
        if(owner != msg.sender) throw;
        code[who] = encrypted;
    }

    function verifyIdentity(address who,bytes32 factor, uint256 hash) constant returns(bool) {
        return verified[who][factor] == hash;
    }
    function bringuPort(address uPortId) {   // for future
        // TODO verify address belongs to uPortId
   // corroborate address in uPort ID
        uPortAddress[msg.sender] = uPortId;
    }

    function revoke(bytes32 factor,address who) {
        if(owner != msg.sender) throw;
        delete verified[who][factor];
    }
    function revokeMyId(bytes32 factor) { 
       delete verified[factor][msg.sender];
    }
    function revokeAll(bytes32 factor, address who) {
        if(owner != msg.sender) throw;
        delete verified[who];
    }
    function revokeAllMyId() { 
       delete verified[msg.sender];
    }
}