pragma solidity ^0.5.0;

contract UserSettings {

    struct UserMessage
    {
        bool   isSet;
        string userName;
        string method;
        string account;
        string bankName;
        string accountUrl;
        string contact;
    }

    mapping(address => UserMessage) public users;
    address[] public userLists;
    mapping(address => address[]) public trustLists;

    //事件日志   
    event SetUser(address user, uint256 settingTime);
    event AddTrustPeople(address user,address trustPeople, uint256 addTime);
    event DelPeople(address user,address untrustPeople, uint256 delTime);

    //用户设置
    function setUser(string memory _userName, string memory _method, string memory _account, 
                    string memory _bankName, string memory _accountUrl, string memory _contact)
        public 
    {       
        if(users[msg.sender].isSet == false){
            users[msg.sender].isSet = true;
            userLists.push(msg.sender);
        }
        users[msg.sender].userName = _userName;
        users[msg.sender].method = _method;
        users[msg.sender].account = _account;
        users[msg.sender].bankName = _bankName;
        users[msg.sender].accountUrl = _accountUrl;
        users[msg.sender].contact = _contact;

        emit SetUser(msg.sender, now);
    }

    //判断是否我的信任名单内
    function inMyTrustLists(address _user, address _people) 
        public 
        view 
        returns(bool)
    {
        require(_people != address(0));
        for(uint i = 0; i < trustLists[_user].length; i ++){
            if(trustLists[_user][i] == _people){
                return true;
            }     
        }
        return false;
    }

    //增加信任名单
    function addTrustPeople(address _people) 
        public 
    {
        require(_people != address(0));
        require(!inMyTrustLists(msg.sender, _people));
        trustLists[msg.sender].push(_people);

        emit AddTrustPeople(msg.sender,_people, now);
    }

    //删除信任名单
    function delPeople(address _people)
        public
    {
        require(_people != address(0));
        require(inMyTrustLists(msg.sender, _people));
        
        for(uint i = 0; i < trustLists[msg.sender].length; i ++ )
        {
            if(trustLists[msg.sender][i] == _people)
            {
                delete trustLists[msg.sender][i];
            }
        }

        emit DelPeople(msg.sender, _people, now);
    }
    
    //判断是否在信任名单内
    function inTrustLists(address _user, address _people) 
        public 
        view 
        returns(bool)
    {
        require(_people != address(0));

        //直接信任名单
        for(uint i = 0; i < trustLists[_user].length; i ++){
            if(trustLists[_user][i] == _people){
                return true;
            }     
        }
        // 拓展信任名单
        for(uint j = 0; j < trustLists[_user].length; j ++){
            for(uint k = 0; k < trustLists[trustLists[_user][j]].length; k ++){
                if(trustLists[trustLists[_user][j]][k] == _people){
                    return true;
                }
            }
        }
        return false;
    }

    function getTrustListsLength(address _user) public view returns(uint256){
        return trustLists[_user].length;
    } 
    
    function getUserListsLength() public view returns(uint256){
        return userLists.length;
    } 
}