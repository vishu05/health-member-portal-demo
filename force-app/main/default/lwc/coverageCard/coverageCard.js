import { LightningElement, api } from 'lwc';
export default class CoverageCard extends LightningElement {
    @api coverages = [];
    get hasCoverages() { return this.coverages.length > 0; }
}
