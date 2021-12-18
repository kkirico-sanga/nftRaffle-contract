pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MyNFT.sol";


//(opensea에서) 가져온 nft를 보관하는 컨트랙트
contract Funding is MyNFT{
    uint256 constant FundingPrice = 0.1 ether;

    mapping(uint256 => uint256) public prices; //tokenID , nft_price
    mapping(uint256 => uint256) public deadlines; //tpkenID, deadLine 시간

   // mapping(uint256 => address[]) public participants; //tokenID별로 참여자 리스트를 갖고있다
    mapping(uint256 => uint256) public fundingPot; // tokenID, 펀딩가격 
    mapping(uint256 =>address) public fundingOwner; //tokenID, 당첨자
    //가격가치를 가지는 nft를 등록하는 과정

    function mintMynftPriced(string memory tokenURI,uint256 _price) public{
        console.log(tokenURI);
        _mint(msg.sender, tokenID); //운영자계정이 있어야함 msg.sender를 운영자계정으로 바꾸어야한다
        _tokenURIs[tokenID] = tokenURI;
        _tokenOwners[msg.sender].push(tokenID); //멤버변수 추가할떄마다 신경써주어야함!
        prices[tokenID]=_price; //NFT의 가격
        deadlines[tokenID] = block.timestamp + (24 * 60 * 60);
     
        tokenID++;
        
    }

    //누군가 구매할때, 이 함수를 실행시킨사람한테 price를 받을것이다
    function buyNFT(uint256 _tokenID, address to) private
    {
        //돈은 작품을 만든 사람한테 간다 
        uint256 nftPrice=prices[_tokenID];   //NFT 작품 가격을 지불해야한다.
        address nftOwner= ownerOf(_tokenID);
        require(nftPrice == fundingPot[_tokenID], "price is not equal!");
        // pay(msg.sender,nftOwner,nftPrice); //msg.sender가 owner에게 돈을 지불 Direct로 못준다
        console.log('_tokenID', _tokenID);
 
        //작품은 이걸 실행한 사람한테 간다
        _transfer(nftOwner,to,_tokenID);   //token의 owner가
        // msg sender에게 토큰을 준다
        // 이 contract가 가지고 있는 ether를 판매자에게 전송한다/
        payable(nftOwner).transfer(nftPrice); //nftOwner 한테 nftPrice만큼 돈을지불 , payable address로 바꿔주는거 castion
    }
    
    //어떤 nft에 펀딩하냐, 펀딩 금액 고정, contract가 함수 실행sender의 0.1ether를 받아온다,이 함수가 실행되면 그냥 받아지는것
    function funding(uint256 _tokenID) public payable
    {
        //FundingPrice//고정
        // uint256 balance=balanceOf(msg.sender);
        // require(balance >=FundingPrice,"Funding Fail, balance is low");
        require(msg.value>=FundingPrice,"Funding Fail, balance is low");
        require(fundingPot[_tokenID]< prices[_tokenID],"Funding Success");
        require(deadlines[_tokenID] > block.timestamp,"Funding End : Reach to DeadLine");
        //tokenID
        participants[_tokenID].push(msg.sender);
        fundingPot[_tokenID]+=FundingPrice;
        console.log('price :',prices[_tokenID],'fundingPot',fundingPot[_tokenID]);
        //uint256 nftPrice=prices[_tokenID];
    }

    //펀딩 가격에 도달하면 랜덤으로 당첨자를 선정한다, 이함수는 contract 주인만 실행 가능하다
    function randomNFTOwner(uint256 _tokenID) public onlyOwner returns(address)
    {   
        //랜덤 당첨자 선정 ownerIndex가 랜덤 당첨자가 된다
        uint256 length = prices[_tokenID] / 0.1 ether;
       uint256 ownerIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%length; 
       address ownerAddress= participants[_tokenID][ownerIndex];
       console.log('ownerAddress',ownerAddress);
       fundingOwner[_tokenID]=ownerAddress;

        buyNFT(_tokenID,ownerAddress); //NFT를 구매하게 할것이다 
        deadlines[_tokenID]=0;
        return ownerAddress;
    }
}