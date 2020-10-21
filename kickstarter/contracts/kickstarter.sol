// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0;

//USE DOUBLE QUOTES WHEN SETTING STRING PARAMETERS!!

contract Campaign{
    struct Request{
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
        //reference type n precisa ser inicializado
        //  por isso approvals n aaprece na struct em createRequest()
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint minimum) public{
        manager = msg.sender;
        minimumContribution = minimum;
    }
    
    function contribute() public payable{
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true; 
        //acrescenta esse endereco ao mapa e da o valor de true
        
        approversCount++;
    }
    
    function createRequest (string memory description, uint value, address payable recipient)
        public restricted{
            Request memory newRequest = Request({
               description: description,
               value: value,
               recipient: recipient,
               complete: false,
               approvalCount: 0
            });
            
            // pode ser construido como uma funcao recebendo parametros ex:
            //     Request(description, value, recipient, false);
            // a ordem define onde cada valor vai entrar
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public{
        //colocamos em storage pois estamos alterando a variavel de fato
        //  e NAO uma copia
        Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        
        //dentro do array requests no index especificado
        //  procuramos  o usuario dentro do mapping aprovvals dessa struct 
        //  se estiver presente, ja votou e nao e permitido votar novamente
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted{
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }

}