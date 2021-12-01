// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './TRC721Enumerable.sol';

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[TRC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {TRC721Enumerable}.
 */
contract ExonCenterTRC721 is TRC721Enumerable {
     
    constructor (string memory name_, string memory symbol_) TRC721(name_, symbol_) {
       
    }

}