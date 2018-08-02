const restify = require('restify');

const server = restify.createServer();

server.use(restify.plugins.queryParser());
server.use(restify.plugins.bodyParser());

const contracts = require('./dapp/contracts');

server.use((req, res, next) => {
    console.log(`GET/POST [${req.method}] ${req.href()}`);
    return next();
});

server.get('/', contracts.getCoinbase);
server.post('/', (req, res) => {
    console.log('req.body:', req.body);
    res.json(req.body);
})

server.post('/accounts/create', contracts.createAccount);
server.get('/accounts/balance', contracts.balanceOf);
server.get('/accounts/balance/ether', contracts.etherBalanceOf);
server.post('/accounts/airdrop', contracts.airdrop);
server.get('/assets', contracts.getAssetsOf);
server.post('/assets/register', contracts.registerAsset);
server.post('/assets/trade', contracts.trade);

const portNumber = 3000;

server.listen(portNumber, () => {
    console.log('%s listening at %s (port: %d)', server.name, server.url, portNumber);
});