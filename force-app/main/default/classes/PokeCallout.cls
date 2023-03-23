public class PokeCallout {
    
    // Define the endpoint URL for the PokeAPI
    private static final String ENDPOINT_URL = 'https://pokeapi.co/api/v2/pokemon?limit=10'; // limit = number of pokemons to retreive
    
    public static void savePokeAPIPokemonData() {
        // Make a callout to the PokeAPI and get the list of all Pokemons
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Parse the JSON response and extract the relevant data for each Pokemon
        Map<String, Object> pokemonList = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        
        List<Object> pokemonArray = (List<Object>) pokemonList.get('results');
        
        List<Pokemon__c> pokemonRecords = new List<Pokemon__c>();
        
        for (Object pokemon : pokemonArray) {
            Map<String, Object> pokemonMap = (Map<String, Object>) pokemon;
            //https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png
            Pokemon__c pokemonRecord = new Pokemon__c();
            pokemonRecord.Name = (String) pokemonMap.get('name');
            pokemonRecord.Url__c = (String) pokemonMap.get('url');
            //System.debug(pokemonRecord.Url__c);
    
            // Make a callout to the PokeAPI to get the Pokemon details
            HttpRequest detailRequest = new HttpRequest();
            detailRequest.setEndpoint((String) pokemonMap.get('url'));
            detailRequest.setMethod('GET');
            HttpResponse detailResponse = http.send(detailRequest);


            List<Object> abilities = (List<Object>) ((Map<String, Object>) JSON.deserializeUntyped(detailResponse.getBody())).get('abilities');
            String res = '';
            
            for(Object a: abilities){
                String name = (String) ((Map<String, Object>)((Map<String, Object>)a).get('ability')).get('name');
                res += name + ';';
            }
            //System.debug(res);

            List<Schema.PicklistEntry> entries = Pokemon__c.Abilities__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry entry: entries){
                if(res.toLowerCase().contains(entry.getLabel().toLowerCase())){
                    //System.debug(entry);
                    pokemonRecord.put('Abilities__c', entry.getLabel());
                }
                //System.debug(entry.getLabel());
            }
            //System.debug(((Map<String, Object>) JSON.deserializeUntyped(detailResponse.getBody())).get('stats'));

            List<Object> stats = (List<Object>) ((Map<String, Object>) JSON.deserializeUntyped(detailResponse.getBody())).get('stats');
            for(Object s: stats){
                //System.debug(((Map<String, Object>)((Map<String, Object>) s).get('stat')((Map<String, Object>) s).get('stat')).get('name'));
                Map<String, Object> stat = (Map<String, Object>) s;
                String statName = (String) ((Map<String, Object>) stat.get('stat')).get('name');
                Integer base_stat = (Integer) stat.get('base_stat');
                switch on statName {
                    when 'attack' {
                        pokemonRecord.Attack__c = base_stat;
                    }
                    when 'defense' {
                        pokemonRecord.Defense__c = base_stat;
                    }
                    when 'speed' {
                        pokemonRecord.Speed__c = base_stat;
                    }
                }
            }

            /*List<Object> abilities = (List<Object>) ((Map<String, Object>) JSON.deserializeUntyped(detailResponse.getBody())).get('abilities');
            String[] res = new String[]{};
            
            for(Object a: abilities){
                //System.debug(((Map<String, Object>)((Map<String, Object>)a).get('ability')).get('name'));
                String name = (String) ((Map<String, Object>)((Map<String, Object>)a).get('ability')).get('name');
                //values.add(new SelectOption(name, name));
                //res.add(name);
                //pokemonRecord.Abilities__c += name + ';';
            }*/
            //pokemonRecord.Abilities__c = pokemonRecord.Abilities__c.removeEnd(';');
            //pokemonRecord.put('Abilities__c', pokemonRecord.Abilities__c);
            //System.debug(res.removeEnd(';'));
            //pokemonRecord.Abilities__c = res.removeEnd(';');
            //pokemonRecord.Abilities__c =  values;
            // pokemonRecord.Abilities__c = pokemonRecord.Abilities__c.trim();
            
            // Parse the JSON response and set the custom fields
            Map<String, Object> pokemonDetailMap = (Map<String, Object>) JSON.deserializeUntyped(detailResponse.getBody());
            // pokemonRecord.Attack__c = (Integer) pokemonDetailMap.get('attack');
            // pokemonRecord.Defense__c = (Integer) pokemonDetailMap.get('defense');
            pokemonRecord.Height__c = (Decimal) pokemonDetailMap.get('height');
            pokemonRecord.Pokedex_Number__c = (Integer) pokemonDetailMap.get('id');
            // pokemonRecord.Speed__c = (Integer) pokemonDetailMap.get('speed');
            pokemonRecord.Weight__c = (Decimal) pokemonDetailMap.get('weight');
            //pokemonRecord.Image__c = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/' + pokemonRecord.Pokedex_Number__c + '.png';
            pokemonRecord.Image__c = (String) ((Map<String, Object>) pokemonDetailMap.get('sprites')).get('front_shiny');

            List<Object> types = (List<Object>) pokemonDetailMap.get('types');
            
            if(types != null && types.size() > 0){
                String type = (String) (((Map<String, Object>) ((Map<String, Object>)types[0]).get('type')).get('name'));
                System.debug(type);
                pokemonRecord.put('Type_1__c', type);
                // System.debug( ((Map<String, Object>) ((Map<String, Object>)types[0]).get('type')).get('name') );
            }
            
            // List<Object> typeList = (List<Object>) pokemonDetailMap.get('types');
            // if (typeList != null && typeList.size() > 0) {
            //     Map<String, Object> typeMap = (Map<String, Object>) typeList.get(0);
            //     if (typeMap != null) {
            //         pokemonRecord.put'Type_1__c' = (String) typeMap.get('type.name');
            //     }
            // }
    
            pokemonRecords.add(pokemonRecord);
        }
    
        // Insert the records into Salesforce
        Database.insert(pokemonRecords, false);
    }
}