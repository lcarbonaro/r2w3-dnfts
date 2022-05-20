// SPDX-License-Identifier: MIT

// DynamicNFTMulti deployed to: 0xC58070e6C461Bf5A979ca4a72D15B111669dCA35

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicNFTMulti is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    struct Multi {
        uint256 level;
        uint256 diplomacy;
        uint256 communication;
        uint256 empathy;
    }

    mapping(uint256 => Multi) public tokenIdToMulti;

    constructor() ERC721("DynamicNFTMulti", "DNFTM") {}

    // generate a dynamic nft e.g. representing a character in a game
    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<defs>",
            '<linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="0%">',
            '<stop offset="0%" style="stop-color:cyan;stop-opacity:1"/>',
            '<stop offset="100%" style="stop-color:purple;stop-opacity:1"/>',
            "</linearGradient>",
            "</defs>",
            "<style>.base { font-family: verdana; font-size: 16px; font-weight: bold;}</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "PeaceKeeper",
            "</text>",
            '<text x="50%" y="55%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Level: ",
            getLevel(tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Empathy: ",
            getEmpathy(tokenId),
            "</text>",
            '<text x="50%" y="65%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Communication: ",
            getCommunication(tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad)">',
            "Diplomacy: ",
            getDiplomacy(tokenId),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    } // function generateCharacter

    function getLevel(uint256 tokenId) public view returns (string memory) {
        Multi memory _multi = tokenIdToMulti[tokenId];
        return _multi.level.toString();
    }

    function getEmpathy(uint256 tokenId) public view returns (string memory) {
        Multi memory _multi = tokenIdToMulti[tokenId];
        return _multi.empathy.toString();
    }

    function getCommunication(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        Multi memory _multi = tokenIdToMulti[tokenId];
        return _multi.communication.toString();
    }

    function getDiplomacy(uint256 tokenId) public view returns (string memory) {
        Multi memory _multi = tokenIdToMulti[tokenId];
        return _multi.diplomacy.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Peace Mission #',
            tokenId.toString(),
            '",',
            '"description": "On-Chain Peace Missions",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    } // function getTokenURI

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        Multi storage _multi = tokenIdToMulti[newItemId];
        _multi.level = 1;
        _multi.empathy = 3;
        _multi.communication = 5;
        _multi.diplomacy = 2;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    } // function mint

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "You must use an existing token!");
        require(
            ownerOf(tokenId) == msg.sender,
            "You can only train a token you own!"
        );

        Multi storage _multi = tokenIdToMulti[tokenId];

        uint256 currentLevel = _multi.level;
        _multi.level = currentLevel + 1;

        uint256 r = random( _multi.level );

        uint256 currentEmpathy = _multi.empathy;
        _multi.empathy = currentEmpathy + r;

        uint256 currentCommunication = _multi.communication;
        _multi.communication = currentCommunication + r;

        uint256 currentDiplomacy = _multi.diplomacy;
        _multi.diplomacy = currentDiplomacy + r;

        _setTokenURI(tokenId, getTokenURI(tokenId));
    } // function train

    function random(uint256 number) public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            ) % number;
    }
}
