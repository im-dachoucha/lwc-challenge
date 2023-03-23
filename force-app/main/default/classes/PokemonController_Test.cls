@isTest
public class PokemonController_Test {

    @isTest
    static void testGetAllPokemon() {
        // Create test Pokemon records
        Pokemon__c p1 = new Pokemon__c(Name='Pikachu', Type_1__c='Electric', Height__c=0.4, Weight__c=6.0, Attack__c=55, Defense__c=40, Speed__c=90, Abilities__c='Static', Pokedex_Number__c=25, Image__c='pikachu.png');
        Pokemon__c p2 = new Pokemon__c(Name='Charizard', Type_1__c='Fire', Height__c=1.7, Weight__c=90.5, Attack__c=84, Defense__c=78, Speed__c=100, Pokedex_Number__c=6, Image__c='charizard.png');
        insert new List<Pokemon__c>{p1, p2};
        
        // Call the controller method
        List<Pokemon__c> result = PokemonController.getAllPokemon();
        
        // Verify the results
        System.assertEquals(2, result.size(), 'Unexpected number of records');
        System.assertEquals('Pikachu', result[0].Name, 'Incorrect record');
        System.assertEquals('Charizard', result[1].Name, 'Incorrect record');
    }
}