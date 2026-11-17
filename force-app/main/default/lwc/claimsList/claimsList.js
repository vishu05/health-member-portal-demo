import { LightningElement, api } from 'lwc';
export default class ClaimsList extends LightningElement {
    @api claims = [];
    get hasClaims() { return this.claims.length > 0; }
}
