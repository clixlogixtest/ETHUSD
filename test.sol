pragma solidity ^0.6.0;
import "remix_tests.sol";


import "../Eth2Usd.sol";


contract Test_Eth2Usd {
   
    Eth2Usd eth = Eth2Usd(0x883AFeA0e5033ba89A20cf1Fa384031e9Cbc161c); // import deployed contract
    
    function test_get() public {
        (uint a, uint b, uint c) = eth.getData();   // call getData function in Eth2Usd contract
        Assert.notEqual(uint(a),0,'Price_a not fetched or deleted');    // checks if Price_a is non zero
        Assert.notEqual(uint(b),0,'Price_b not fetched or deleted');    // checks if Price_b is non zero
        Assert.notEqual(uint(c),0,'Price_c not fetched or deleted');    // checks if Price_c is non zero
    }
}