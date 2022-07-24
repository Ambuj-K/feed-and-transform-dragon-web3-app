const main = async() => {

    // initialise a few accts to create dragons from, locally

    const [owner, randomUser, randomUser1] = await hre.ethers.getSigners();
    const dragonContractFactory = await hre.ethers.getContractFactory("DragonFeed");

    // add ether for local testing

    const dragonContract = await dragonContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });

    // wait for deployment on local hardhat dev env

    await dragonContract.deployed();

    // log contract address and owner acct of hardhat

    console.log("DragonFactory Deployed to ", dragonContract.address);
    console.log("DragonFactory deployed by ", owner.address);

    // log totaldragons

    let dragonCount;
    dragonCount = await dragonContract.displayTotalDragons();

    // log contract balance before/after each dragon test

    let contractBalance = await hre.ethers.provider.getBalance(dragonContract.address);
    console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance)
    );

    // create dragon

    let dragonTxn = await dragonContract.createDragon("Dragon created!");
    await dragonTxn.wait();

    // log total dragonss

    dragonCount = await dragonContract.displayTotalDragons();

    dragonTxn = await dragonContract.connect(randomUser).createDragon("A dragon!");
    await dragonTxn.wait();

    // log contract balance before/after each dragon test

    contractBalance = await hre.ethers.provider.getBalance(dragonContract.address);
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    dragonTxn = await dragonContract.connect(randomUser1).("Another dragon!");
    await dragonTxn.wait();

    // log contract balance before/after each dragon test

    contractBalance = await hre.ethers.provider.getBalance(dragonContract.address);
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    waveTxn = await waveContract.connect(randomUser).createDragon("Another dragon!");
    await dragonTxn.wait();

    // log contract balance before/after each dragon test

    contractBalance = await hre.ethers.provider.getBalance(dragonContract.address);
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    dragonCount = await dragonContract.displayTotalWaves();

    let allWaves = await dragonContract.getAllDragons();
    console.log(allDragons);
};

const runMain = async() => {
    try {
        await main();
        process.exit(0);
    } catch(error){
        console.log("error",error);
        process.exit(1);
    }
};

runMain();
