// SPDX-License-Identifier: MIT

pragma solidity >= 0.6.0;

/**
 * @title TRC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from TRC721 asset contracts.
 */
interface ITRC721Receiver {
    /**
     * @dev Whenever an {ITRC721} `tokenId` token is transferred to this contract via {ITRC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `ITRC721.onTRC721Received.selector`.
     */
    function onTRC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
