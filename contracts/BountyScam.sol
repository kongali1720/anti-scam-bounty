// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BountyScam {
    struct Report {
        address reporter;
        string description;
        uint256 votes;
        bool approved;
    }

    address public owner;
    uint public reward = 0.01 ether;
    Report[] public reports;

    mapping(uint => mapping(address => bool)) public voted;

    constructor() {
        owner = msg.sender;
    }

    function submitReport(string memory _description) public {
        reports.push(Report(msg.sender, _description, 0, false));
    }

    function voteReport(uint _index) public {
        require(!voted[_index][msg.sender], "You already voted");
        reports[_index].votes++;
        voted[_index][msg.sender] = true;

        if (reports[_index].votes >= 3) {
            reports[_index].approved = true;
            payable(reports[_index].reporter).transfer(reward);
        }
    }

    receive() external payable {}
}
