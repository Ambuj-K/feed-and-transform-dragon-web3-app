const main = async () => {
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();
  
    console.log("Deploying contracts with account: ", deployer.address);
    console.log("Account balance: ", accountBalance.toString());
  
    const dragonContractFactory = await hre.ethers.getContractFactory("DragonPortal");
    const dragonContract = await dragonContractFactory.deploy({
      value: hre.ethers.utils.parseEther("0.001"),
    });
    await dragonContract.deployed();
  
    console.log("DragonPortal address: ", dragonContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();
