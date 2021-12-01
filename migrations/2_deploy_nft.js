var ExonswapV2Factory = artifacts.require("./ExonswapV2Factory.sol")
var WTRX = artifacts.require('./WTRX.sol')
var ExonCenterTRC721 = artifacts.require("./ExonCenterTRC721.sol")
var ExonswapV2PairRouter = artifacts.require("./ExonswapV2PairRouter.sol")
var ExonswapV2LiquidityRouter = artifacts.require("./ExonswapV2LiquidityRouter.sol")
var ExonswapV2SwapRouter = artifacts.require("./ExonswapV2SwapRouter.sol")

// //deploy test tokens
var USDT = artifacts.require("./USDT.sol")
var ExonToken = artifacts.require("./test/ExonToken.sol")
var BTC = artifacts.require("./test/BTC.sol")
var USDC = artifacts.require("./test/USDC.sol")


module.exports =   function(deployer,network,account) {
   console.log('DEPLOY INFO', network, account)
   deployer.deploy(ExonCenterTRC721, "Exon Center NFT", "Exon NFT")
   // deployer.deploy(WTRX);
   // deployer.deploy(USDT)
   // deployer.deploy(ExonToken)
   // deployer.deploy(BTC)
   // deployer.deploy(USDC)
   // deployer.deploy(ExonswapV2Factory, account, ExonCenterTRC721.address)
   // console.log(ExonswapV2Factory.address, WTRX.address)
   // deployer.deploy(ExonswapV2LiquidityRouter, ExonswapV2Factory.address, WTRX.address)
  // deployer.deploy(ExonswapV2SwapRouter, 'TAmcK1QBi7HapLhN6L7HuBTEDxPSAyTeZG', 'TRgZigtVyTN3vLice5TwhjpBjavAGKNCjR')

  // deployer.deploy(ExonswapV2PairRouter, 'TAmcK1QBi7HapLhN6L7HuBTEDxPSAyTeZG', 'TDePPLeXEtcukPRUNfsvoodDhVhJGWsEcW', 'TTScS8HMukLqgLKPuUz6gmnRGwBkgrR5Tp')
   
};

// module.exports = async function(deployer,network,account) {
//     console.log('DEPLOY INFO', network, account)
//     await deployer.deploy(ExonCenterTRC721, "Exon Center NFT", "Exon NFT")
//     await deployer.deploy(WTRX);
//     console.log(account, ExonCenterTRC721.address)
//     // await deployer.deploy(ExonswapV2Factory, account, ExonCenterTRC721.address)
//    //  console.log('#### Factory address constructor:', ExonswapV2Factory.address, WTRX.address)
//    //  await deployer.deploy(ExonswapV2LiquidityRouter, ExonswapV2Factory.address, WTRX.address)
//    // await deployer.deploy(USDT)
//    // await deployer.deploy(ExonToken)
//    //  await deployer.deploy(BTC)
//    //  await deployer.deploy(USDC)
// };
