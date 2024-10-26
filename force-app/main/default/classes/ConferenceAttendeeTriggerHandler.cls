public class ConferenceAttendeeTriggerHandler {
    
    public static void sendConfirmationEmail(List<Conference_Attendee__c> newRecordList ) {
        
        Set<Id> attendeesIdsSet = new Set<Id>();
        Set<Id> eventIdsSet = new Set<Id>();
        
        for(Conference_Attendee__c ea : newRecordList){
            attendeesIdsSet.add(ea.Attendee__c);
            eventIdsSet.add(ea.Event__c);
        }
        
        Map<Id,Attendee__c> attendeeMap = new Map<Id,Attendee__c>( 
            [Select Id, Name, Email__c From Attendee__c WHERE  Id IN : attendeesIdsSet]
        );
        
        Map<Id, Event__c > eventMap = new Map<Id, Event__c > ( [Select Id, Name__c, Start_DateTime__c, Conference_Organizer__c , Conference_Organizer__r.Name,
                                                                Location__c , Location__r.Name, Location__r.City__c,
                                                                Location__r.State__c, Location__r.Country__c,
                                                                Location__r.Postal_Code__c, Location__r.Street__c
                                                                FROM Event__c  WHERE ID IN: eventIdsSet]
                                                             );
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for(Conference_Attendee__c ea : newRecordList){
            
            Attendee__c att = attendeeMap.get(ea.Attendee__c);
            Conference__c evt = eventMap.get(ea.Event__c);
              
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setSubject('Ticket of the conference '+evt.Name__c);
            List<String> toAddress = new List<String>();
            toAddress.add(att.Email__c);
            mail.setToAddresses( toAddress );
            mail.setSenderDisplayName(evt.Conference_Organizer__r.Name);
            
            String locaton = 'https://www.google.com/maps/place/'+evt.Location__r.Street__c+' '+evt.Location__r.City__c+' '
                +evt.Location__r.State__c+' '+
                evt.Location__r.Country__c+' '+evt.Location__r.Postal_Code__c;
            String hrefForLocation = '<a href="'+locaton+'"'+'target="_blank">Here</a>';
            String emailBody = 'Dear '+ att.Name + ',<br/><br/>'+
                'Thank you for registering for '+evt.Name__c+' which will be Organized on '+
                evt.Start_DateTime__c+' & will be held in '+evt.Location__r.Name
                +'.<br/>We are excited to have you,'+ 
                'see you in the event. <br/>'+
                'Here is the location of the conference provided in this link '+hrefForLocation+'.<br/><br/><br/>'+
                'Thanks,<br/>'+evt.Conference_Organizer__r.Name;
            
            mail.setHtmlBody(emailBody);
            emailList.add(mail);
            
        }
        
        try{
            
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(emailList, false); 
            for(Messaging.SendEmailResult email : results){
                System.debug(email.isSuccess());
                if(!email.isSuccess()){
                    List<Messaging.SendEmailError> errors = email.getErrors();
                    TransactionLogHandler.doHandleExceptionWithError(JSON.serialize(errors), 'EventAttendeeTriggerHandler');
                }
            }  
        }catch(System.Exception ex){
            TransactionLogHandler.doHandleException(ex, 'EventAttendeeTriggerHandler');
        }
    }
}