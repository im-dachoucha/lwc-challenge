import { LightningElement, api, track } from 'lwc';

export default class PokemonDetailModal extends LightningElement {
    @api pokemon;
    @api isModalOpen;

    handleClose = () => {
        console.log("handleClose function");
        this.isModalOpen = false;
        this.pokemon = null
    }
}