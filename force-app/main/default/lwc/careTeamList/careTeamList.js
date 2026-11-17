import { LightningElement, api } from 'lwc';
export default class CareTeamList extends LightningElement {
    @api careTeam = [];
    get hasTeam() { return this.careTeam.length > 0; }
}
