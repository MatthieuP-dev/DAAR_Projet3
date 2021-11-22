pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  struct Company {
    string companyName;
    uint256 balance;
    User owner;
    User[] employee;
    bool registered;
  }

  mapping(address => User) private users;

  event UserSignedUp(address indexed userAddress, User indexed user);

  function user(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, 0, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }
  mapping(string => Company) private companies;
  mapping(address => Company) private employee;

event CreateCompany(string indexed companyName, User indexed owner, Company indexed comp);

  function createCompany(string memory companyName) public returns (Company memory) {
    if(companies[companyName].registered == false){
      companies[companyName].registered = true;
      companies[companyName].name = companyName;
      companies[companyName].owner = User.username;
      companies[companyName].balance = 0;
    }
    emit CreateCompany(companyName, User.username, companies[companyName]);

    return companies[companyName];
  }

 function addEmployee(string memory companyName, address newEmployee) public returns (Company memory){
    require(users[msg.sender].registered); // If user aldready registred
    require(users[newEmployee].registered); // If user aldready registred
    require(companies[companyName].registered); // If company aldready registred
    require(compareString(companies[companyName].owner.username, users[msg.sender].username)); // If user is company's owner

    members[newEmployee] = companies[companyName];
  }


}
