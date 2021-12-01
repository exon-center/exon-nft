// SPDX-License-Identifier: MIT

pragma solidity >= 0.6.0;

import "../interfaces/ITRC165.sol";

/**
 * @dev Implementation of the {ITRC165} interface.
 *
 * Contracts that want to implement TRC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {TRC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract TRC165 is ITRC165 {
    /**
     * @dev See {ITRC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(ITRC165).interfaceId;
    }
}
