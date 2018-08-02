pragma solidity ^0.4.18;

import "./Token.sol";

contract AssetManager {

    struct Asset {
        uint256 id;
        address owner;
        uint256 price;
        uint8 totalShare;
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
        assets[_id].owningShareOf[msg.sender] = 100;
        assetsOf[msg.sender].push(_id);
    }

    function getAsset(address _account, uint256 _id) public view returns (uint256 id,
                                                                        address owner,
                                                                        uint256 price,
                                                                        uint8 totalShare,
                                                                        uint8 owningShare) {
        Asset storage asset = assets[_id];
        return (
            asset.id,
            asset.owner,
            asset.price,
            asset.totalShare,
            asset.owningShareOf[_account]
        );
    }

    function getAssetsOf(address _owner) public view returns (uint256[]) {
        return assetsOf[_owner];
    }
    
    function trade(uint256 _id, address _owner, uint8 _amount) public payable returns (bool) {
        // price might be changed. (unstable)
        Asset storage asset = assets[_id];
        if (asset.owningShareOf[_owner] < _amount) return false;
        asset.owningShareOf[_owner] -= _amount;
        if (asset.owningShareOf[_owner] == 0) {
            uint8 index;
            for (index = 0; index < assetsOf[_owner].length; index++) {
                if (assetsOf[_owner][index] == _id) break;
            }
            for (index = index+1; index < assetsOf[_owner].length; index++) {
                assetsOf[_owner][index-1] = assetsOf[_owner][index];
            }
            assetsOf[_owner].length--;
        }
        if (asset.owningShareOf[msg.sender] == 0) assetsOf[msg.sender].push(_id);
        asset.owningShareOf[msg.sender] += _amount;
        bool result = tokenReward.transfer(msg.sender, _owner, asset.price * _amount);
        if (result == false) revert();
        return result;
    }
}