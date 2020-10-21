const path = require('path');
const fs = require('fs');
const solc = require('solc');

const kickstarterPath = path.resolve(__dirname, 'contracts', 'Kickstarter.sol');
const source = fs.readFileSync(kickstarterPath, 'utf8');

var input = {
    language: 'Solidity',
    sources: {
        'Kickstarter.sol' : {
            content: source
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': [ '*' ]
            }
        }
    }
}; 

// console.log(JSON.parse(solc.compile(JSON.stringify(input))).contracts['Kickstarter.sol']);
module.exports = JSON.parse(solc.compile(JSON.stringify(input))).contracts['Kickstarter.sol'];
