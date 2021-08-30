pragma solidity ^0.4.25;
import "./zombiefactory.sol";
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}
contract ZombieFeeding is ZombieFactory {
//C.1.Inmutability of contracts.What d happen if the Cryptokittis contract had a bug and
//someone destroyed all the kittys? For this reason if often makes sense to have functions that will allow u
//to update key portions of the DApp. For example, instead of hardcoding the Cryptokitties contract address into our Dapp
//we should probably have a setKittyContractAddress function that lets us change this address in the future in case something happens to the cryptokittiescontract
//Look at how we removed the address ckaddress,
//and ofc kittyinterface(ckaddress) as we don want a declaration ``=`´
  KittyInterface kittyContract;
//and we added this function. External is like public but.. with public u can code the function from the outside the SC 
//and inside, BUT with external u just can code it just from outside.
  function setKittyContractAddress(address _address) external {
    kittyContract = KittyInterface(_address);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
