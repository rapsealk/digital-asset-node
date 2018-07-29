pragma solidity ^0.4.18;

import "./Token.sol";

contract AssetManager {

    struct Asset {
        uint256 id;
        address owner;
        uint256 price;
        uint8 totalShare;
        uint8 buyableShare;
        mapping (address => uint8) owningShareOf;
    }

    Token public tokenReward;
    
    mapping (uint256 => Asset) public assets;
    mapping (address => uint256[]) public assetsOf;

    constructor(address tokenAddress) public {
        tokenReward = Token(tokenAddress);
    }

    function registerAsset(uint256 _id) public {
        Asset storage asset;
        asset.id = _id;
        asset.owner = msg.sender;
        asset.price = 1;
        asset.totalShare = 100;
        asset.buyableShare = 100;
        asset.owningShareOf[msg.sender] = 100;
        assets[_id] = asset;
        assetsOf[msg.sender].push(_id);
    }

    function getAsset(address _account, uint256 _id) public view returns (uint256 id,
                                                                        address owner,
                                                                        uint256 price,
                                                                        uint8 totalShare,
                                                                        uint8 buyableShare,
                                                                        uint8 owningShare) {
        Asset storage asset = assets[_id];
        return (
            asset.id,
            asset.owner,
            asset.price,
            asset.totalShare,
            asset.buyableShare,
            asset.owningShareOf[_account]
        );
    }

    function getAssetsOf(address _owner) public view returns (uint256[]) {
        return assetsOf[_owner];
    }
    
    /*
    function buyAsset(uint256 _id, uint8 _amount) public payable {
        Asset storage asset = assets[_id];
        if (asset.buyableShare < _amount) revert();
        asset.buyableShare -= _amount;
        if (asset.owningShareOf[msg.sender] == 0) assetsOf[msg.sender].push(_id);
        asset.owningShareOf[msg.sender] += _amount;
        tokenReward.transfer(msg.sender, asset.owner, asset.price * _amount);
    }
    */
}