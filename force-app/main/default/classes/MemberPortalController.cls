/**
 * @description Thin controller for member portal LWCs (Experience Cloud
 *              style component APIs, org-agnostic for this demo).
 */
public with sharing class MemberPortalController {

    @AuraEnabled(cacheable=true)
    public static MemberPortalService.Dashboard getDashboard(Id memberId) {
        if (memberId == null) {
            throw new AuraHandledException('A member Id is required.');
        }
        return MemberPortalService.getDashboard(memberId);
    }

    @AuraEnabled(cacheable=true)
    public static List<Claim__c> getClaims(Id memberId, String statusFilter) {
        if (memberId == null) {
            throw new AuraHandledException('A member Id is required.');
        }
        return MemberPortalService.getClaims(memberId, statusFilter);
    }
}
