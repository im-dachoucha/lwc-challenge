import { LightningElement, wire, track } from "lwc";
import getPokemonList from "@salesforce/apex/PokemonController.getAllPokemon";

export default class PokemonCardWrapper extends LightningElement {
  @track searchTerm = "";
  filteredPokemon = [];
  selectedPokemon = null;
  isModalOpen = false;
  listPokemon;


  @wire(getPokemonList)
  pokemonListHandler({ data, error }) {
    if (data) {
      this.filteredPokemon = this.listPokemon = data;
    } else if (error) {
      console.error(error);
    }
  }

  handleSearchChange(event) {

    this.searchTerm = event.target.value.toLowerCase();
    this.filteredPokemon = this.listPokemon.filter(pokemon =>
      pokemon.Name.toLowerCase().includes(this.searchTerm)
    );
  }

  handlePokemonSelect({detail}) {
    this.selectedPokemon
    this.filteredPokemon.forEach(pokemon => {
      if(pokemon.Id == detail) {
        this.selectedPokemon = pokemon
      }
    });

    console.log("selected pokemon", this.selectedPokemon)
    this.isModalOpen = true;
  }

  handleModalClose() {
    this.isModalOpen = false;
  }
}