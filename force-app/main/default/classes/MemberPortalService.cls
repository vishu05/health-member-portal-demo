/**
 * @description Service layer for the member portal dashboard.
 *              Synthetic demo data only - this is not a medical system
 *              and must never hold real PHI.
 */
public with sharing class MemberPortalService {

    public class Dashboard {
        @AuraEnabled public Member_Profile__c member;
        @AuraEnabled public List<Coverage__c> coverages;
        @AuraEnabled public List<Claim__c> recentClaims;
        @AuraEnabled public List<Care_Team_Member__c> careTeam;
        @AuraEnabled public Decimal totalBilledThisYear;
    }

    public static Dashboard getDashboard(Id memberId) {
        Dashboard d = new Dashboard();
        d.member = [
            SELECT Id, Name, Member_Number__c, Plan_Name__c
            FROM Member_Profile__c WHERE Id = :memberId LIMIT 1
        ];
        d.coverages = [
            SELECT Id, Name, Coverage_Type__c, Status__c, Effective_Date__c
            FROM Coverage__c WHERE Member_Profile__c = :memberId
            ORDER BY Effective_Date__c DESC LIMIT 20
        ];
        d.recentClaims = [
            SELECT Id, Name, Claim_Status__c, Provider_Name__c,
                   Service_Date__c, Billed_Amount__c
            FROM Claim__c WHERE Member_Profile__c = :memberId
            ORDER BY Service_Date__c DESC NULLS LAST LIMIT 10
        ];
        d.careTeam = [
            SELECT Id, Name, Clinician_Name__c, Role__c
            FROM Care_Team_Member__c WHERE Member_Profile__c = :memberId
            ORDER BY Clinician_Name__c LIMIT 20
        ];
        AggregateResult ar = [
            SELECT SUM(Billed_Amount__c) total FROM Claim__c
            WHERE Member_Profile__c = :memberId
            AND Service_Date__c = THIS_YEAR
        ];
        d.totalBilledThisYear = (Decimal) ar.get('total');
        if (d.totalBilledThisYear == null) { d.totalBilledThisYear = 0; }
        return d;
    }

    public static List<Claim__c> getClaims(Id memberId, String statusFilter) {
        List<Claim__c> claims = [
            SELECT Id, Name, Claim_Status__c, Provider_Name__c,
                   Service_Date__c, Billed_Amount__c
            FROM Claim__c WHERE Member_Profile__c = :memberId
            ORDER BY Service_Date__c DESC NULLS LAST LIMIT 100
        ];
        if (String.isBlank(statusFilter)) { return claims; }
        List<Claim__c> filtered = new List<Claim__c>();
        for (Claim__c c : claims) {
            if (c.Claim_Status__c == statusFilter) { filtered.add(c); }
        }
        return filtered;
    }
}
