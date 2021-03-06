// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Contract Imports */
import { MyERC20 } from "./MyERC20.sol";

/* Library Imports */
import { Abs_L2DepositedToken } from "@eth-optimism/contracts/build/contracts/OVM/bridge/tokens/Abs_L2DepositedToken.sol";

/**
 * @title MyL2DepositedERC20
 * @dev The L2 Deposited ERC20 is an ERC20 implementation which represents L1 assets deposited into L2.
 * This contract mints new tokens when it hears about deposits into the L1 ERC20 gateway.
 * This contract also burns the tokens intended for withdrawal, informing the L1 gateway to release L1 funds.
 *
 * Compiler used: optimistic-solc
 * Runtime target: OVM
 */
contract MyL2DepositedERC20 is Abs_L2DepositedToken, MyERC20 {

    uint32 public constant MY_FINALIZE_WITHDRAWAL_L1_GAS = 100000;

    constructor(
        address _l2CrossDomainMessenger,
        uint8 _decimals,
        string memory _name,
        string memory _symbol
    )
        Abs_L2DepositedToken(_l2CrossDomainMessenger)
        MyERC20(_decimals, _name, _symbol, 0)
    {}

    function _handleInitiateWithdrawal(
        address _to,
        uint _amount
    )
        internal
        override
    {
        _burn(msg.sender, _amount);
    }

    function _handleFinalizeDeposit(
        address _to,
        uint _amount
    )
        internal
        override
    {
        _mint(_to, _amount);
    }
}