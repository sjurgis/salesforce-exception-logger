/*
	Description: Test class for ExLog
*/
@isTest
private class ExLogTest {

    static testMethod void exLogTest() {
        Test.startTest();
        ExLog.writeBatchException('SampleClass','SampleObject','sampleFunction','error message','trace error message', false);
        ExLog.isTest = true;
        
        try{
        	ExLog.add('SampleClass','SampleObject','sampleFunction',new ExLogException('Test Exception'), false);
            
        }catch(Exception e){
        	// We are expecting an exception ehere is we turn on isTest
        }
        
        Contact newContact = new Contact();
        newContact.FirstName = 'FirstName';
        newContact.LastName = 'LastName';
        newContact.Email = 'testExLogTest@fakeemail.com';
        insert newContact;
        
        try{
        	ExLog.add('SampleClass','SampleObject','sampleFunction', new ExLogException('Test Exception'), newContact.Id, false);
        }catch(Exception e){
        	// We are expecting an exception ehere is we turn on isTest
        }
        
		Contact newContact2 = new Contact();
        newContact2.FirstName = 'FirstName';
        newContact2.LastName = 'LastName';
        newContact2.Email = 'testExLogTest@fakeemail.com';
        Database.SaveResult sr = Database.insert(newContact2, false);
        delete newContact2;
        newContact2.OwnerId=userInfo.getUserId();
        Database.SaveResult sr1 = Database.Update(newContact2, false);
    	try{
	    	if(!sr.isSuccess()){
	    		for(Database.Error duplicateError : sr.getErrors()){
	    			ExLog.write('SampleClass','SampleObject','sampleFunction', duplicateError, false);
	    		}
	    	}
	    	if(!sr1.isSuccess()){
	    		for(Database.Error duplicateError : sr1.getErrors()){
	    			ExLog.write('SampleClass','SampleObject','sampleFunction', duplicateError, false);    
	    		}     
	    	}    
    	}catch(Exception e){
    		// We are expecting an exception ehere is we turn on isTest
    	}
    	Test.stopTest();
    	Integer logCount = [SELECT count() from Exception_Log__c ];
    	system.assertEquals(true,(logCount>0),'Exception Logs should have been created.');
    }
    
    class ExLogException extends Exception{}
    
}