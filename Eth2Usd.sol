// SPDX-License-Identifier: GPL-3.0

// address = 0x883AFeA0e5033ba89A20cf1Fa384031e9Cbc161c

pragma solidity ^0.6.0;

import "https://raw.githubusercontent.com/smartcontractkit/chainlink/master/evm-contracts/src/v0.6/ChainlinkClient.sol";

contract Eth2Usd is ChainlinkClient {
  
    
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

// structure to record prices 

struct Prices{
    uint price_a;
    uint price_b;
    uint price_c;
}

Prices prices;

    /**
     * Network: Kovan
     * Chainlink - 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
     * Chainlink - 29fa9aa13bf1468788b7cc4a500a45b8
     * Fee: 0.1 LINK
     */
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        prices.price_a = 0 ;
        prices.price_b = 0 ;
        prices.price_c = 0 ;
    }
    
    // function to display data 

    function getData() public view returns(uint,uint,uint){
        return(prices.price_a, prices.price_b, prices.price_c);
    }
    
    // function to get mean

    function getMean() public view returns(uint){
        return(prices.price_a + prices.price_b + prices.price_c)/3;
    }

    // function to deleteData 

    function deleteData() public {
        prices.price_a = 0 ;
        prices.price_b = 0 ;
        prices.price_c = 0 ;
    }


    /**
     
     ************************************************************************************
     *                                    STOP!                                         * 
     *         THIS FUNCTION WILL FAIL IF THIS CONTRACT DOES NOT OWN LINK               *
     *         ----------------------------------------------------------               *
     *         Learn how to obtain testnet LINK and fund this contract:                 *
     *         ------- https://docs.chain.link/docs/acquire-link --------               *
     *         ---- https://docs.chain.link/docs/fund-your-contract -----               *
     *                                                                                  *
     ************************************************************************************/

    // Request price_a from kracken api 

    function requestPrice_a() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.updatePrice_a.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", "https://api.kraken.com/0/public/Ticker?pair=ETHUSD");
        
        // Set the path to find the desired data in the API response, where the response format is:
     
        request.add("path", "result.XETHZUSD.c.0");
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 100000;
        request.addInt("times", timesAmount);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
   function updatePrice_a(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        prices.price_a = _price;
    }

    // Request price_b from coingecko api
    
    function requestPrice_b() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.updatePrice_b.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd");
        
        // Set the path to find the desired data in the API response, where the response format is:
       
        request.add("path", "ethereum.usd");
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 100000;
        request.addInt("times", timesAmount);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function updatePrice_b(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        prices.price_b = _price;
    }
    
    // Request price_c from coinbase pro api

    function requestPrice_c() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.updatePrice_c.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", "https://api.pro.coinbase.com/products/ETH-USD/ticker");
        
        // Set the path to find the desired data in the API response, where the response format is:
        
        request.add("path", "price");
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 100000;
        request.addInt("times", timesAmount);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function updatePrice_c(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        prices.price_c = _price;
    }
    
    /**
     * Withdraw LINK from this contract
     * 
     * NOTE: DO NOT USE THIS IN PRODUCTION AS IT CAN BE CALLED BY ANY ADDRESS.
     * THIS IS PURELY FOR EXAMPLE PURPOSES ONLY.
     */
    function withdrawLink() external {
        LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
        require(linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))), "Unable to transfer");
    }
}