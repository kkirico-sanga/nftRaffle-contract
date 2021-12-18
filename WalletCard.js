import React, {useState} from 'react'
import {ethers} from 'ethers'
import './cover.css';

const WalletCard=() => {
    const [errorMessage, setErrorMessage]=useState(null);
    const [defaultAccount, setDefaultAccount]=useState(null);
    const [userBalance, setUserBalance]=useState(null);
    const [connButtonText, setConnButtonText]=useState('Connect Wallet');
    const connectWalletHandler = ()=>{
        //
        if(window.ethereum){
            //metamask is here i think
            console.log('test1');
            window.ethereum.request({method:'eth_requestAccounts'})
            .then(result=>{
                console.log('test2');
                accountChangedHandler(result[0]);
            })
        }
        else{
            console.log('test3');
            setErrorMessage('Install MetaMask');
        }
    }
    const accountChangedHandler = (newAccount)=>{ //계정 바뀌었을때 
        console.log('test4');
        setDefaultAccount(newAccount);
        getUserBalance(newAccount.toString());
    }
    
    const getUserBalance = (address) => {
        console.log('getUserBalance'+address);
        window.ethereum.request({method: 'eth_getBalance', params:[address,'latest']})
        .then(balance=>{
            setUserBalance(ethers.utils.formatEther(balance));
        })

    }
    const chainChangedHandler = () =>{
        window.location.reload(); // 네트워크가 바뀌었을때 자산을 0으로 갱신 
    }

    window.ethereum.on('accountsChanged',accountChangedHandler);
    window.ethereum.on('chainChanged',chainChangedHandler);
    return(
        <div className='walletCard'>
            <br></br><br></br><br></br>
            <h1>{"NFT Raffle"}</h1>
            <h3>{"Connection to MetaMask"}</h3>
            <br></br><br></br>
              <button onClick={connectWalletHandler}>{connButtonText}</button>
              <br></br><br></br>
              <div className='accountDisplay'>
                  <h3>Address : {defaultAccount}</h3>
              </div>
              <div className='balanceDisplay'>
                  <h3>Balance : {userBalance}</h3>
              </div>
              {errorMessage}
        </div>
    );
}

export default WalletCard;

