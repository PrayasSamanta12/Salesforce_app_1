
@isTest
public class DeleteConferenceBatchTest {

    @testSetup
    public static void testSetupData(){
        Event_Organizer__c  org = new Conference_Organizer__c (
            Name = 'Prayas Samanta',
            Phone__c = '9230166545',
            Email__c = 'prayas.samanta.21@aot.edu.in'
        );
        insert org;
        List<Conference__c> eventList = new List<Conference__c>();
        for(Integer i=0; i<=200; i++){
            Conference__c event = new Conference__c(
                Name__c = 'Conference #1'+i+1,
                Conference_Organizer__c  = org.Id,
                Conference_Type__c = 'Virtual',
                Frequency__c  = 'Weekly',
                Max_Seats__c  = 199,
                Recurring__c = true,
                Live__c = true,
                Start_DateTime__c = System.now().addMonths(-4),
                End_Date_Time__c  = System.now().addDays(3).addMonths(-4)
            );
            eventList.add(event);
        }
        insert eventList;
    }
    
    @isTest
    static void sendDeletEventTest(){
        Test.startTest();

        String jobId = Database.executeBatch(new DeleteEventBatch(), 250);
        
        Test.stopTest();
        
    }
}
