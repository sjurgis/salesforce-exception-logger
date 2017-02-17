/*
Description: Class to log system exceptions

Test class: ExLogTest

Invoke using ExLog.add(<Trigger || Class>, Object name, Method Name, exception object, is future) 
  in the catch block of functions
For example: ExLog.add('Trigger', 'Account', 'SomeFunction', e, false);

*/

public class ExLog {
  public static Boolean isTest = false;
  
  //No record ID required
  public static void add(String sourceType, String objName, String methodName, Exception e, boolean isFuture) {
    try {
      write(sourceType, objName, methodName, e, '', isFuture);
      
      if(isTest){
        throw new ExLogException('this exception gets thrown only when executed via test class');
      }
      
    } catch(Exception ex) {
      write('Class', 'ExLog', objName + '.' + methodName, ex, '', isFuture);
    }
  }
  
  //This one accepts a record ID
  public static void add(String sourceType, String objName, String methodName, Exception e, string recordID, boolean isFuture) {
    try {
      write(sourceType, objName, methodName, e, recordID, isFuture);
      
      if(isTest){
        throw new ExLogException('this exception gets thrown only when executed via test class');
      }
    } catch(Exception ex) {
      write('Class', 'ExLog', objName + '.' + methodName, ex, recordID, isFuture);    
    }
  }
  
  //Write the exception, accepting input from method overloading above
  public static void write(String sourceType, String objName, String methodName, Exception e, string recordID, boolean isFuture) {
    try {
      Exception_Log__c exLog = new Exception_Log__c ();
      exLog.Source_Type__c = sourceType;
      exLog.Object_Name__c = objName;
      exLog.method_name__c = methodName;
      exLog.RecordId__c = recordID;
      exLog.Exception_Type__c = e.getTypeName();
      exLog.Message__c = e.getMessage();
      exLog.Stack_Trace__c = e.getStackTraceString();
      
      // putting into future method to prevent mixed_dml errors, but in case it's called from future, use normal DML
      if ( isFuture )
        insert exLog;	
      else
        objectWritter ( JSON.serialize ( exLog ) );
      
      if(isTest){
        throw new ExLogException('this exception gets thrown only when executed via test class');
      }
    } catch(Exception ex) {
      throw(ex);      
    }            
  }
  
  //Takes in a Database.SaveResult object.
  public static void write(String sourceType, String objName, String methodName, Database.Error e, boolean isFuture) {
    try {
      Exception_Log__c  exLog = new Exception_Log__c ();
      exLog.Source_Type__c = sourceType;
      exLog.Object_Name__c = objName;
      exLog.method_name__c = methodName;
      exLog.Exception_Type__c = 'DML Database Error';
      exLog.Message__c = 'Status Code: ' + e.getStatusCode() + '\nError Message: ' + e.getMessage();
      exLog.Stack_Trace__c = 'Status Code: ' + e.getStatusCode() + '\nError Message: ' + e.getMessage();
      
      // putting into future method to prevent mixed_dml errors, but in case it's called from future, use normal DML
      if ( isFuture )
        insert exLog;	
      else
        objectWritter ( JSON.serialize ( exLog ) );
      
      if(isTest){
        throw new ExLogException('this exception gets thrown only when executed via test class');
      }
    } catch(Exception ex) {
      throw(ex);      
    }    
  }
  
  //Takes in a Database.SaveResult Batch error.
  public static void writeBatchException(String sourceType, String objName, String methodName, String error, String stackError, boolean isFuture) {
    try {
      Exception_Log__c  exLog = new Exception_Log__c ();
      exLog.Source_Type__c = sourceType;
      exLog.Object_Name__c = objName;
      exLog.method_name__c = methodName;
      exLog.Exception_Type__c = 'DML Database Error';
      exLog.Message__c = error;
      exLog.Stack_Trace__c = stackError;
      
      // putting into future method to prevent mixed_dml errors, but in case it's called from future, use normal DML
      if ( isFuture )
        insert exLog;	
      else
        objectWritter ( JSON.serialize ( exLog ) );
      
      
      if(isTest){
        throw new ExLogException('this exception gets thrown only when executed via test class');
      }
    } catch(Exception ex) {
      throw(ex);      
    }    
  }
  
  @future
  public static void objectWritter (string serializedMessage){
    Exception_Log__c toWrite = (Exception_Log__c)JSON.deserialize(serializedMessage, Exception_Log__c.class);
    
    insert toWrite;
  }
  
  
  class ExLogException extends Exception{}
  }
