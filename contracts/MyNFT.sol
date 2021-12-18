// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

//ownable은 누가 만들었느냐에 대한거고 배포할떄 누가 배포했느냐 , 이컨트랙트의 주인

contract MyNFT is Ownable,ERC721Enumerable{
    //1. minting : name , symbol, decimal , tokenURI, description, owner (msg.sender)  ->  metadata need to tokenURI(토큰정보)
    //2. tokenURI 랑 tokenID 연결  : 각 토큰마다 고유한 tokenID 갖고있어야한다, tokenID(contract가 만드는것)
    //3. 각 token마다 URI , 주인
    uint256 public tokenID;
    mapping(uint256 =>string) public _tokenURIs;
    //mapping(uint256 => address) _owners; //tokenID로 
    //_nft_tokens[tokenID]=address; 
    mapping(address=>uint256[]) public _tokenOwners; // uint256[]은 tokenID
    mapping(uint256 => address[]) public participants; //가격이 매겨진 토큰, 참가자들
    mapping(uint256 => uint256[]) public participateTokens; //가격이 매겨진 토큰, 창작토큰들
    mapping(uint256 =>address[]) public randomParticipants; //tokenID
    constructor() ERC721("test","test"){
        tokenID = 0;
    }

    //minting의 주인은 msg.sender 
    //tokenURI 에 metadata정보 다 들어있다.
    //{name : "" , description, tokenURI: ""} -> IPFS 
    //http imageURL 로 tokenURI 생성 ipfs를 통해서 만들수 있나 , 
    //owner는 이 컨트랙트를 배포한 서비스계정이라고 생각하면되고 , msg.sender는 트랜젝션발생시킨 사람
    function mintMynft(string memory tokenURI, uint256 _tokenId) public{
        
        _mint(owner(), tokenID); //운영자계정이 있어야함 msg.sender를 운영자계정으로 바꾸어야한다
        _tokenURIs[tokenID] = tokenURI;
        _tokenOwners[msg.sender].push(tokenID); //멤버변수 추가할떄마다 신경써주어야함!
        participants[_tokenId].push(msg.sender);
        participateTokens[_tokenId].push(tokenID);
        tokenID++;
    }
        //tokenID리스트를 리턴받아서 ID로 찾는다 
    function showNFTList(address account) public
    {
        uint256 size = balanceOf(account);
        uint256[] memory balance = new uint[](size);
        balance =_tokenOwners[account];

        //_tokenURIs[account];
    }
    //미당첨자에게 랜덤으로 보유한 nft를 transfer할것이다
    //미당첨자는 몇명인가, 미당첨자 address[]필요? 
    function transfer(address _to, uint256 _id) public {
        //require(msg.sender,);
        _transfer(msg.sender, _to, _id);
        
    }
    //외부에서 address 정렬후 넘겨준다
    //외부는 buyNFT 하는데서 보낸다 
    //Funding의 randParticipants(tokenID)를 넣어서 randomParticipants 를만들고
    //randomParticipants[tokenID]를 전달인자로 넣는다
    //funding contract를 전달인자로 넣는다 
    //어떤 작품을 전달하는가?  -> 가치있는 토큰ID

         //참가자리스트를 랜덤으로 섞는 로직 , 전역 변수에 넣는다 
    function randParticipants(uint256 _tokenID)public returns(uint256){
        address tempAddress = participants[_tokenID][0];
        uint256 _totlaParticipants = participants[_tokenID].length;
        console.log('participantsCnt', _totlaParticipants);
        uint256 i;
        for(i=0; i<_totlaParticipants-1; i++)
        {
            randomParticipants[_tokenID].push(participants[_tokenID][i+1]);
        }
        randomParticipants[_tokenID].push(tempAddress);
        //console.log(randomParticipants[_tokenID][_totlaParticipants-1]);
        return _totlaParticipants;
    }

    function randomDeployNFT(uint256 tokenID,address winner) public
    {   
        uint256 cnt=randParticipants(tokenID);
        console.log(cnt);
        uint256 i;
        for(i=0; i<cnt; i++)
        {
            //require(randomParticipants[tokenID][i] != winner,"randomParticipants is Winner");
            _transfer(owner(),randomParticipants[tokenID][i],participateTokens[tokenID][i]); //랜덤당첨자에게 참가자들이 배포한 토큰을 전송한다
        }
        // participants[tokenID]
        // participateTokens[tokenID]
    }


}
