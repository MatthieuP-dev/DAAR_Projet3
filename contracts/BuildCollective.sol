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

  function signUp(string memory username) {
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
      companies[companyName].owner = users[msg.sender];
      companies[companyName].balance = 0;
    }
    emit CreateCompany(companyName, users[msg.sender], companies[companyName]);

    return companies[companyName];
  }

 function addEmployee(string memory companyName, address newEmployee) {
    require(users[msg.sender].registered); 
    require(users[newEmployee].registered);
    require(companies[companyName].registered); 
    members[newEmployee] = companies[companyName];// To add a new Employee it need to be already registered
  } 


  
struct Project {
  uint id;
  string projectName;
  bool registered;
  uint256 balance;
  User[] contributor;
  Company companyOwner;
  User userOwner;
}

mapping(string => Project) private projects;
mapping(address => string[]) private contributors;

event CreateProject(string indexed projectName, Project indexed projet);

function getProjects(string memory projectName) public view returns (Project memory) {

  return projects[projectName];
}

function getContributors(address userAddress) public view returns (Project memory){

  return contributors[userAddress];
}

function addContributors(string memory projectName, address newContributor) public returns (Project memory){
    require(users[msg.sender].registered); 
    require(users[newContributor].registered);
    require(projects[projectName].registered); 
    contributors[newContributor] = projects[projectName];// Same as Employee, the contributors needs to be registered

    return contributors[newContributor];  
  }

    function sponsoring(uint projectId, address POAdress, uint256 amount) external payable{
    require(users[msg.sender].registered && users[msg.sender].balance >= amount);
    require(users[POAdress].registered);
    for(uint k = 0; k <= projects[POAdress].length;k++){
      if(projects[POAdress][k].id == projectId){
        users[msg.sender].balance -= amount;
        projects[POAdress][k].balance += amount;
      }
    }
  }

function createProject(string memory projectName, bool companyProject) public view returns (Project memory){
  if(projects[projectName].registered == false){
    require(users[msg.sender].registered);
    require(employee[msg.sender].registered);

    projects[projectName].registered = true;
    projects[projectName].balance = 0;

    if(companyProject == true){
      projects[projectName].companyOwner = employee[msg.sender];
    } else {
      projects[projectName].userOwner = user[msg.sender];
    }
  }
  emit CreateProject(projectName, projects[projectName]);
  
  return projects[projectName];
}

  struct Bounty{
    uint id;
    string bountyName;
    uint256 cashprize;
    bool rewarded;
  }

  mapping(uint => Bounty[]) public bounties;

  event BountyCreated(uint indexed founder, Bounty indexed bounty);

  function bounties(uint projectId) public view returns (Bounty[] memory) {

    return bounties[projectId];
  }

  function createBounty(string memory bountyName, uint256 cashprize, uint projectId) public returns(Bounty memory){
    require(users[msg.sender].registered);
    bountyCount++;
    bounties[projectId].push(Bounty(bountyName, cashprize, false));
    emit(projectId, bounties[projectId]);

    return bounties[projectId][bountyCount - 1];
  }

  function bugFix(uint projectId, uint bountyId, address payable hunter) external payable{
    for (uint k = 0; k < bounties[projectId].length; k++){
      if (bounties[projectId][k].id == bountyId) {
        users[hunter].balance += bounties[projectId][k].cashprize;
        bounties[projectId][k].rewarded = true;
        bounties[projectId][k].cashprize = 0;
      }
    }
  }


}
