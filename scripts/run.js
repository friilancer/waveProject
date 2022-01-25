const main = async () => {
    //const [_, randomPerson] = await hre.ethers.getSigners()
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1")
    });

    await waveContract.deployed();
    console.log(`Contract deployed to ${waveContract.address}`);

    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    )

    console.log(
        "Contract Balance:",
        hre.ethers.utils.formatEther(contractBalance)
    )
    let waveCount;

    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber())
    
    let wave1 = await waveContract.wave("Wave 1");
    await wave1.wait();

    let wave2 = await waveContract.wave("Wave 2");
    await wave2.wait();

    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    )

    console.log(
        "Contract Balance:",
        hre.ethers.utils.formatEther(contractBalance)
    )

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
  
    
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
}

runMain();