// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Base64} from "./libraries/Base64.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract VoxelVerseMC is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIds;

    struct CharacterAttributes {
        string name;
        string imageURI;
        uint happiness;
        uint thirst;
        uint hunger;
        uint xp;
        uint daysSurvived;
        uint characterLevel;
        uint health;
        uint heat;
        string animation_url;

    }

    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    mapping(uint256 => bool) private _tokenMinted;

    event CharacterUpdated(uint256 tokenId, CharacterAttributes attributes);
    event CharacterNFTMinted(address indexed recipient, uint256 indexed tokenId, CharacterAttributes attributes);

    constructor() Ownable() ERC721("VoxelVerseMC", "VVMC") {

    }
    /**
     * @dev Mints a new character NFT to the specified recipient address with predefined attributes.
     * Can only be called by the contract owner.
     * @param recipient Address to receive the newly minted NFT.
     */
    function mintCharacterNFT(address recipient) public onlyOwner {
        uint256 newItemId = _tokenIds.current();

        CharacterAttributes memory attributes = CharacterAttributes({
            name: "VoxelVerseMC",
            imageURI: "https://harlequin-leading-egret-2.mypinata.cloud/ipfs/Qmd7NWbw2JdUqnJk7rg1w2X79L36dbrbQ5QbESVzHYt3SH",
            happiness: 50,
            thirst: 100,
            hunger: 100,
            xp: 1,
            daysSurvived: 1,
            characterLevel: 1,
            health: 100,
            heat:50,
            animation_url: string.concat("https://erc6551-iframe-ruddy.vercel.app","/",Strings.toHexString(uint256(uint160(address(this)))),"/",newItemId.toString(),"/","11155111")

        });

        require(!_tokenMinted[newItemId], "Character already minted");

        _safeMint(recipient, newItemId);
        nftHolderAttributes[newItemId] = attributes;
        _tokenMinted[newItemId] = true;

        _tokenIds.increment();

        emit CharacterNFTMinted(recipient, newItemId, attributes);
    }

    /**
     * @dev Updates the attributes of a specific character NFT.
     * Can only be called by the contract owner.
     * @param tokenId The ID of the NFT whose attributes are to be updated.
     * @param attributes The new attributes to assign to the NFT.
     */
    function updateCharacterAttributes(uint256 tokenId, CharacterAttributes memory attributes) public onlyOwner {
        nftHolderAttributes[tokenId] = attributes;
        emit CharacterUpdated(tokenId, attributes);
    }

    /**
     * @dev Returns the URI for a given token ID. The URI points to a JSON file that conforms to the "ERC721 Metadata JSON Schema".
     * @param tokenId The ID of the token that the URI will be returned for.
     * @return A string representing the URI to the metadata for the given token ID.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        CharacterAttributes memory charAttributes = nftHolderAttributes[tokenId];

        string memory json = string(abi.encodePacked(
            '{"name":"', charAttributes.name, '","description":"This is your beta character in the VoxelVerseMC game!","image":"',
            charAttributes.imageURI,  '""animation_url":"', charAttributes.animation_url, '","attributes":[',
            '{"trait_type":"Happiness","value":"', charAttributes.happiness.toString(), '"},',
            '{"trait_type":"Health","value":"', charAttributes.health.toString(), '"},',
            '{"trait_type":"Hunger","value":"', charAttributes.hunger.toString(), '"},',
            '{"trait_type":"XP","value":"', charAttributes.xp.toString(), '"},',
            '{"trait_type":"Days","value":"', charAttributes.daysSurvived.toString(), '"},',
            '{"trait_type":"Level","value":"', charAttributes.characterLevel.toString(), '"},',
            '{"trait_type":"Heat","value":"', charAttributes.heat.toString(), '"},',
            '{"trait_type":"Thirst","value":"', charAttributes.thirst.toString(), '"}',
            "]}"));

        string memory encodedJson = Base64.encode(bytes(json));

        return string(abi.encodePacked("data:application/json;base64,", encodedJson));
    }
}
