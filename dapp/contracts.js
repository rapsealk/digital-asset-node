const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8545'));

const NetworkId = '5777';

const Token = require('../truffle/build/contracts/Token.json');
const TokenContract = new web3.eth.Contract(Token.abi, Token.networks[NetworkId].address);
const AssetManager = require('../truffle/build/contracts/AssetManager.json');
const AssetManagerContract = new web3.eth.Contract(AssetManager.abi, AssetManager.networks[NetworkId].address);

const AIRDROP_ = 10;
const PASSWORD = 'password_hanium_123';

exports.getCoinbase = async (req, res) => {
    res.json({ succeed: true, coinbase: await web3.eth.getCoinbase() });
};

exports.createAccount = async (req, res) => {

    const account = await web3.eth.personal.newAccount(PASSWORD/*
        @password
    */);
    console.log('account:', account);
    /*
    const account = await web3.eth.accounts.create(
        // @entropy: at least 32 characters
    );
    */
   const etherTransaction = await web3.eth.sendTransaction({
       from: await web3.eth.getCoinbase(),
       to: account,
       value: web3.utils.toWei('10', 'ether'),
       gas: web3.utils.toWei('6000000', 'wei')
   });
   console.log('etherTransaction:', etherTransaction);
   /*
    const balance = await TokenContract.methods.airdrop(account, AIRDROP_).send({
        from: await web3.eth.getCoinbase(),
        gas: web3.utils.toWei('6000000', 'wei')
    });
    */
    res.json({ succeed: true, address: account });
};

exports.airdrop = async (req, res) => {
    const { address } = req.body;
    const transaction = await TokenContract.methods.airdrop(address, AIRDROP_).send({
        from: await web3.eth.getCoinbase(),
        gas: web3.utils.toWei('6000000', 'wei')
    });
    console.log('tx:', transaction);
    const balance = await TokenContract.methods.balanceOf(address).call();
    res.json({ succeed: true, balance });
};

exports.balanceOf = async (req, res) => {
    const { address } = req.query;
    const balance = await TokenContract.methods.balanceOf(address).call();
    res.json({ succeed: true, balance });
};

exports.etherBalanceOf = async (req, res) => {
    const { address } = req.query;
    const balance = await web3.eth.getBalance(address);
    res.json({ succeed: true, balance });
};

exports.registerAsset = async (req, res) => {
    const { address } = req.body;
    const assetId = Date.now();
    console.log(`address: ${address}, asset: ${assetId}`);
    await web3.eth.personal.unlockAccount(address, PASSWORD);
    const transaction = await AssetManagerContract.methods.registerAsset(assetId).send({
        from: address,
        gas: web3.utils.toWei('6000000', 'wei')
    });
    console.log('transaction:', transaction);
    res.json({ succeed: true });
};

/*
exports.buyAsset = async (req, res) => {
    const { address, assetId, amount } = req.body;
    console.log('address:', address);
    console.log('asset ID:', assetId);
    console.log('amount:', amount);

    const asset = await AssetManagerContract.methods.getAsset(address, assetId).call();
    console.log('asset:', asset);

    try {
    const transaction = await AssetManagerContract.methods.buyAsset(assetId, 0).send({
        from: address,
        gas: web3.utils.toWei('6000000', 'wei')
    });
    console.log('transaction:', transaction);
    res.json({ succeed: true });
    }catch(error) {
        console.log('error:', error);
        res.json({ succeed: false });
    }
};
*/

exports.getAssetsOf = async (req, res) => {
    const { address } = req.query;
    const assets = await AssetManagerContract.methods.getAssetsOf(address).call();
    const promise = await assets.map(async (id, index) => {
        assets[index] = await AssetManagerContract.methods.getAsset(address, id).call();
        // remove duplicated values
        Object.keys(assets[index]).forEach(key => {
            if (!isNaN(key)) delete assets[index][key];
        });
    });
    await Promise.all(promise);
    res.json({ succeed: true, assets });
};