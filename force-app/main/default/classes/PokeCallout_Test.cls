@isTest
public class PokeCallout_Test {
	@isTest static void testCallout() {
        
        Test.setMock(HttpCalloutMock.class, new Poke_Mock());
         
        PokeCallout.savePokeAPIPokemonData();

	}
}