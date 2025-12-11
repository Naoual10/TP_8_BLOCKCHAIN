pragma solidity ^0.8.0;


contract HelloWorld {

    // 4. Variable publique
    string public yourName;

    // 5. Constructeur
    constructor() public {
        yourName = "Unknown";
    }

    // 6. Fonction setName
    function setName(string memory nm) public {
        yourName = nm;
    }
}
