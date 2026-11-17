import { LightningElement, api, wire } from 'lwc';
import getDashboard from '@salesforce/apex/MemberPortalController.getDashboard';

export default class MemberDashboard extends LightningElement {
    @api recordId;
    @api memberId;
    dashboard;
    error;

    get effectiveMemberId() { return this.memberId || this.recordId; }
    get member() { return this.dashboard?.member; }
    get coverages() { return this.dashboard?.coverages || []; }
    get claims() { return this.dashboard?.recentClaims || []; }
    get careTeam() { return this.dashboard?.careTeam || []; }
    get totalBilled() { return this.dashboard?.totalBilledThisYear || 0; }
    get hasError() { return !!this.error; }

    @wire(getDashboard, { memberId: '$effectiveMemberId' })
    wiredDashboard({ data, error }) {
        if (data) { this.dashboard = data; this.error = undefined; }
        else if (error) { this.error = error; this.dashboard = undefined; }
    }
}
