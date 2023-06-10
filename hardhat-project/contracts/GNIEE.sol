// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IConnectlist.sol";

contract GNIE is ERC721Enumerable, Ownable {
    /**
     * @dev _baseTokenURI  for computing {tokenURI} . If set, the resulting URI for each
     * token will be the concatenation of the'BaseURI' and the 'tokenId'
     */
    string _basetokenURI;

    // _price is the price of one Crypto Dev NFT
    uint256 public _price = 0.01 ether;

    // _pause is used to pause the contract in case of an emergancy
    bool public _pause;

    // max number of GNIE tokens
    uint256 public maxTokenIds = 5;

    // total number of tokenIds minted
    uint256 public tokenIds;

    // connectlist contract instance 
    IConnectlist whitelist;

    // boolean to keep track of whether presale started or not
    bool public presaleStarted;

    // timestamp for when presale would end 
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_pause, "Contract currently paused");
        _;    
    }
    /**
     * @dev ECR721 constructor takes in a `name` and a `symbol` to the token collection.
     * name in our case is `GNIE` and symbol is `GNIE`.
     * Constructor for GNIE tokes in the baseURI to set _baseTokenURI for the collection.
     * IT also initializes an instance of the connectlist interface.
     */
    constructor (string memory baseURI, address connectlistContract) ERC721("GNIE", "GNIE") {
      _basetokenURI = baseURI;
      whitelist = IConnectlist(connectlistContract);  
    }

    /**
     * @dev startPresale starts a presale for the whitelisted addresses
     */
    function startPresale() public onlyOwner{
        presaleStarted = true;
        // Set presaleEnded time as current timestamp + 5 minutes 
        // Solidity has cool syntax for timestamp (seconds, minutes, hours, days, years,)
        presaleEnded = block.timestamp + 5 minutes; 
    }

    /**
     * @dev presaleMint allows a user to mint one NFT per transaction during the presale.
     */
    function presaleMint()public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds < maxTokenIds, "Exceeded maximum GNIE token supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        // _safeMint is a safer version of the _mint function as it ensures that
        // if the address the being minted to is a contract, then it knows how to deal with ERC721 tokens
        // if the address being minted to is not a contract, it works the same way as _mint
        _safeMint(msg.sender, tokenIds);
    } 
    /**
     * @dev mint allows a user to mint one NFT per transaction after the presale has ended.
     */
    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >=  presaleEnded, "Presale has not ended yet");
        require(tokenIds < maxTokenIds, "Exceeded maximum GNIE tokens supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }
    /**
     * @dev _baseURI overides the Openzppelin's ERC721 implementation which by default
     * returns an empty string for the baseURI
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _basetokenURI;
    }

    /**
     * @dev setPaused makes the contract paused or unpaused
     */
    function setPaused(bool val) public onlyOwner{
        _pause = val;
    }

    /** 
     * @dev withdraw sends all the ether in the contract
     * to the owner of the contract 
     */
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call {value: amount} ("");
        require(sent, "Failed to send Ether");
    }

    // Function to recieve Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable{}
}