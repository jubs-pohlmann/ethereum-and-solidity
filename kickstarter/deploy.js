const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { Kickstarter } = require('./compile');

let abi = Kickstarter.abi;
let bytecode = Kickstarter.evm.bytecode.object;

const provider = new HDWalletProvider(
    'cover impulse rich already year valve okay quick insect spoil indicate pair',
    'https://rinkeby.infura.io/v3/abd31e97fa294e35914a7d595bc7dcb2'
);
const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract((abi))
        .deploy({ data: bytecode })
        .send({ from: accounts[0], gas: '1000000' });

    console.log('Contract deployed to', result.options.address);
};

deploy();