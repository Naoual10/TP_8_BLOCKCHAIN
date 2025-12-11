const HelloWorld = artifacts.require("HelloWorld");

contract("HelloWorld", () => {

  it("Hello World Testing", async () => {
    // Récupérer l'instance du contrat déployé
    const helloWorld = await HelloWorld.deployed();

    // Modifier la variable yourName
    await helloWorld.setName("User Name");

    // Lire la variable yourName
    const result = await helloWorld.yourName();

    // Vérifier que la valeur est correcte
    assert(result === "User Name");
  });

});
