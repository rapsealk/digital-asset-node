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
        assets[_id].id = _id;
        assets[_id].owner = msg.sender;
        assets[_id].price = 1;
        assets[_id].totalShare = 100;
        assets[_id].buyableShare = 100;
        assets[_id].owningShareOf[msg.sender] = 100;
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