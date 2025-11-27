// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TrustBlockFramework
 * @dev A minimal trust-verification framework where users can create identities
 *      and assign trust scores to others based on interactions.
 */
contract Project {
    struct Identity {
        string name;
        uint256 trustScore;
        bool exists;
    }

    mapping(address => Identity) public identities;

    event IdentityCreated(address indexed user, string name);
    event TrustScoreUpdated(address indexed target, uint256 newScore);

    /**
     * @notice Register a new on-chain identity.
     * @param _name The display name of the identity.
     */
    function createIdentity(string calldata _name) external {
        require(!identities[msg.sender].exists, "Identity already created");

        identities[msg.sender] = Identity({
            name: _name,
            trustScore: 0,
            exists: true
        });

        emit IdentityCreated(msg.sender, _name);
    }

    /**
     * @notice Increase the trust score of another identity.
     * @param _user The address of the identity to be rated.
     * @param _points Number of trust points to add.
     */
    function increaseTrust(address _user, uint256 _points) external {
        require(identities[_user].exists, "Target identity does not exist");
        require(_points > 0, "Points must be greater than zero");

        identities[_user].trustScore += _points;

        emit TrustScoreUpdated(_user, identities[_user].trustScore);
    }

    /**
     * @notice Retrieve identity details of a user.
     * @param _user Address of the user.
     * @return Identity struct.
     */
    function getIdentity(address _user) external view returns (Identity memory) {
        require(identities[_user].exists, "Identity does not exist");
        return identities[_user];
    }
}

