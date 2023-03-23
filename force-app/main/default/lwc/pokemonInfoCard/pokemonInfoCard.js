import { LightningElement, api } from 'lwc';

export default class PokemonInfoCard extends LightningElement {
    @api pokemon;

    handleCardClick() {
        const selectEvent = new CustomEvent("pokemonselect", {
          detail: this.pokemon.Id
        });
        this.dispatchEvent(selectEvent);
      }
}