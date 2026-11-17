/**
 * @description Synthetic seed data. Invented people, invented claims.
 *              Never replace this with real member/PHI data.
 */
@isTest
public class MemberPortalTestFactory {

    public static Member_Profile__c createMember(String name) {
        Member_Profile__c m = new Member_Profile__c(
            Name = name,
            Member_Number__c = 'CP-DEMO-1001',
            Plan_Name__c = 'ClearPath Choice (fictional plan)'
        );
        insert m;
        return m;
    }

    public static Id createFullDemoMember() {
        Member_Profile__c m = createMember('Jordan Example');
        insert new Coverage__c(
            Member_Profile__c = m.Id, Coverage_Type__c = 'Medical',
            Status__c = 'Active', Effective_Date__c = Date.today().addMonths(-3));
        insert new Claim__c(
            Member_Profile__c = m.Id, Claim_Status__c = 'Processed',
            Provider_Name__c = 'Example Clinic', Service_Date__c = Date.today().addDays(-14),
            Billed_Amount__c = 240.00);
        insert new Care_Team_Member__c(
            Member_Profile__c = m.Id, Clinician_Name__c = 'Dr Example',
            Role__c = 'Primary Care (fictional)');
        return m.Id;
    }
}
