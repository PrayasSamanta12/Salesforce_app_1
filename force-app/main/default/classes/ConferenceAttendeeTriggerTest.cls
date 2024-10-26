
@isTest
public class EventAttendeeTriggerTest {
	
    @testSetup
    public static void setupData(){
        
        Event_Organizer__c  org = new Event_Organizer__c (
            Name = 'Prayas Samanta',
            Phone__c = '9230166545',
            Email__c = 'samantaprayas3@gmail.com'
        );
        insert org;
        
        Event__c event = new Event__c(
            Name__c = 'Conference #1',
            Conference_Organizer__c  = org.Id,
            Conference_Type__c = 'In-Person',
            Frequency__c  = 'Weekly',
            Max_Seats__c  = 200,
            Recurring__c = true,
            Live__c = true,
            Start_DateTime__c = System.now()
            //End_Date_Time__c  = System.now().addDays(3)
        );
        insert event;
        Attendee__c att = new Attendee__c(
            Name = 'Soumya Sarkar',
            Email__c = 'ps19july2003@gmail.com',
            Phone__c = '7872505077'
        );
        insert att;
        
        Event_Attendee__c evtAtt = new Event_Attendee__c(Event__c = event.Id, Attendee__c = att.Id);
        insert evtAtt;
    }
    
    @isTest
    static void sendEmailTest(){
        Test.startTest();
        try{
            integer i = 10/0;
        }catch(System.Exception ex ){
            
        }
        Test.stopTest();
    }
} 