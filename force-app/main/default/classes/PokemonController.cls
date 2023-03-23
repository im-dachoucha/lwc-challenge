public with sharing class PokemonController {

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getAllPokemon() {
        return [SELECT Id, Name, Type_1__c, Height__c, Weight__c, Attack__c, Defense__c, Speed__c, Abilities__c, Pokedex_Number__c, Image__c FROM Pokemon__c];
    }
}