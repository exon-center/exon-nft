// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/ITRC721.sol";
import "./interfaces/ITRC721Receiver.sol";
import "./interfaces/ITRC721Metadata.sol";
import "./utils/Address.sol";
import "./utils/Context.sol";
import "./utils/Strings.sol";
import "./TRC721/TRC165.sol";
import "./interfaces/IFabric.sol";


contract TRC721 is Context, TRC165, ITRC721, ITRC721Metadata {
    using Address for address;
    using Strings for uint256;
    
    address admin;
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Upliner NFT

    uint public tokenID;

    uint public currentAdminID;

    uint public adminAccountAmount;

    address public FabricStorage;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from token Id to upliner id

    mapping(uint256 => uint256) public Upliners;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    mapping (uint => mapping(uint8 => uint64)) public ReferalAmount;

    mapping (uint => uint[]) public FistLine;

    mapping(uint => bool) public AdminAccounts;

    
     
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        admin = msg.sender;
        Upliners[1] = 1;
        mint(msg.sender, 1);
        mint(msg.sender,1);
        currentAdminID = 2;
        adminAccountAmount = 20;
        AdminAccounts[1] = true;
        AdminAccounts[2] = true;
        FistLine[1].push(tokenID);
    }



    function setFabticAddress(address _address) public {
        require(msg.sender == admin, "Only admin");
        FabricStorage = _address;
    }

    function setAdminAccountAmount(uint _amount) public {
        require(msg.sender == admin, "Only admin");
        adminAccountAmount = _amount;
    }

    function callFabric(uint _id) internal {
        if (FabricStorage != address(0)) {
          IFabric _fabric = IFabric(FabricStorage);
          _fabric.changeOwner(_id);
        }
    }

    function checkAdminFirstLine() internal returns(uint _adminId) {
        if (FistLine[currentAdminID].length > adminAccountAmount) {
            mint(admin,1);
            currentAdminID = tokenID;
            AdminAccounts[tokenID] = true;
            FistLine[1].push(tokenID);
            return tokenID;
        } else {
            return currentAdminID;
        }
    }

    function signIn(uint _refId) public {
        require(balanceOf(msg.sender) == 0, "User signed in");
        if (Upliners[_refId] == 0 || AdminAccounts[_refId]) {
            uint refCurrent = checkAdminFirstLine();
            mint(msg.sender, refCurrent);
            FistLine[refCurrent].push(tokenID);
            addReferalAmount(tokenID);
        } else {
            mint(msg.sender, _refId);
            FistLine[_refId].push(tokenID);
            addReferalAmount(tokenID);
        }
    }

    function getFirstLine(uint _id) public view returns(uint[] memory) {
        return FistLine[_id];
    }

    function addReferalAmount(uint _nftId) internal  {
        uint  _current_ref_id = Upliners[_nftId];
        for(uint8 i=0; i < 6; i++) {
            ReferalAmount[_current_ref_id][i] += 1;
            _current_ref_id = Upliners[_current_ref_id];
        }
    }
   
    function supportsInterface(bytes4 interfaceId) public view virtual override(TRC165, ITRC165) returns (bool) {
        return
            interfaceId == type(ITRC721).interfaceId ||
            interfaceId == type(ITRC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "TRC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {ITRC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "TRC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {ITRC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {ITRC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
      * @dev See {ITRC721Metadata-upliner}
    */

    /**
     * @dev See {ITRC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "TRC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "https://exoncenter.com/nft/";
    }

    /**
     * @dev See {ITRC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = TRC721.ownerOf(tokenId);
        require(to != owner, "TRC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "TRC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {ITRC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "TRC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {ITRC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "TRC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {ITRC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {ITRC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "TRC721: transfer caller is not owner nor approved");
        
        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {ITRC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {ITRC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "TRC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the TRC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {ITRC721Receiver-onTRC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnTRC721Received(from, to, tokenId, _data), "TRC721: transfer to non TRC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "TRC721: operator query for nonexistent token");
        address owner = TRC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {ITRC721Receiver-onTRC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-TRC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {ITRC721Receiver-onTRC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnTRC721Received(address(0), to, tokenId, _data),
            "TRC721: transfer to non TRC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "TRC721: mint to the zero address");
        require(!_exists(tokenId), "TRC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = TRC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(TRC721.ownerOf(tokenId) == from, "TRC721: transfer of token that is not own");
        require(to != address(0), "TRC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        AdminAccounts[tokenId] = false;
        callFabric(tokenId);
        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(TRC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Internal function to invoke {ITRC721Receiver-onTRC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnTRC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (msg.sender == tx.origin) {
            try ITRC721Receiver(to).onTRC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == ITRC721Receiver.onTRC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("TRC721: transfer to non TRC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    function mint(address to, uint _upliner) internal {
        require(Upliners[_upliner] != 0 ,"Not correct upliner");
        tokenID += 1;
        _mint(to, tokenID);
        Upliners[tokenID] = _upliner;
    }
}
