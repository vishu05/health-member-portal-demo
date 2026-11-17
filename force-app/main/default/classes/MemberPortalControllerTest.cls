@isTest
private class MemberPortalControllerTest {

    @isTest
    static void dashboardReturnsAllSections() {
        Id memberId = MemberPortalTestFactory.createFullDemoMember();

        Test.startTest();
        MemberPortalService.Dashboard d = MemberPortalController.getDashboard(memberId);
        Test.stopTest();

        System.assertNotEquals(null, d.member);
        System.assertEquals(1, d.coverages.size());
        System.assertEquals(1, d.recentClaims.size());
        System.assertEquals(1, d.careTeam.size());
        System.assertEquals(240.00, d.totalBilledThisYear);
    }

    @isTest
    static void claimsCanBeFilteredByStatus() {
        Id memberId = MemberPortalTestFactory.createFullDemoMember();
        List<Claim__c> processed = MemberPortalController.getClaims(memberId, 'Processed');
        List<Claim__c> denied = MemberPortalController.getClaims(memberId, 'Denied');
        System.assertEquals(1, processed.size());
        System.assertEquals(0, denied.size());
    }

    @isTest
    static void missingMemberRejected() {
        Boolean thrown = false;
        try {
            MemberPortalController.getDashboard(null);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        System.assertEquals(true, thrown);
    }

    @isTest
    static void bulkMembersDashboardQueriesStayFlat() {
        List<Member_Profile__c> members = new List<Member_Profile__c>();
        for (Integer i = 0; i < 50; i++) {
            members.add(new Member_Profile__c(
                Name = 'Bulk Example ' + i, Member_Number__c = 'CP-DEMO-' + i));
        }
        insert members;

        Test.startTest();
        Integer before = Limits.getQueries();
        MemberPortalController.getDashboard(members[0].Id);
        Integer used = Limits.getQueries() - before;
        Test.stopTest();
        System.assert(used <= 5, 'Dashboard should use a flat query count, used: ' + used);
    }
}
