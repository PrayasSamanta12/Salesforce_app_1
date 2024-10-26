trigger ConferenceSpeakerTrigger on ConferenceSpeakers__c (before insert, before update ) {
    
    Set<Id> speakerIdsSet = new Set<Id>();
    Set<Id> eventIdsSet = new Set<Id>();
    
    for( ConferenceSpeakers__c es : Trigger.New ){
         speakerIdsSet.add(es.Speaker__c);
         eventIdsSet.add(es.Event__c);
    }
    Map<Id, DateTime> requestedEvents = new Map<Id, DateTime>();
    
    List<Event__c> relatedEventList = [Select Id, Start_DateTime__c From Event__c 
                                       Where Id IN : eventIdsSet];
    
    for(Conference__c evt : relatedEventList ){
        requestedEvents.put(evt.Id, evt.Start_DateTime__c);
    }
    List<ConferenceSpeakers__c> relatedEventSpeakerList = [ SELECT Id, Conference__c, Speaker__c,
                                               Event__r.Start_DateTime__c
                                               From ConferenceSpeakers__c
                                               WHERE Speaker__c IN : speakerIdsSet];
    
    for( ConferenceSpeakers__c es : Trigger.New ){ 
        
        DateTime bookingTime = requestedEvents.get(es.Event__c); 
        
        for(EventSpeakers__c es1 : relatedEventSpeakerList) {
            if(es1.Speaker__c == es.Speaker__c && es1.Event__r.Start_DateTime__c == bookingTime ){
                es.Speaker__c.addError('The speaker is already booked at that time');
                es.addError('The speaker is already booked at that time');
            }
        }
        
    } 
}