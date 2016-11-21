# salesforce-exception-logger [![Deploy to Salesforce](https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png)](https://githubsfdeploy.herokuapp.com/?owner=sjurgis&repo=salesforce-exception-logger)

Log your exceptions for further analysis using reports or sending out workflow email alerts!

Invoke using ExLog.add(<Trigger || Class>, Object name, Method Name, exception object, is future) in the catch block of functions.
  
For example: `ExLog.add('Trigger', 'Account', 'SomeFunction', e, false);`

Use in Visualforce:
```html
<apex:page standardcontroller="Lead" extensions="LeadExtension">
<button onclick="javascript:causeException();" > log exception </button>
  <script>
   function causeException(){
     try {
       invalidFunctionName('foo');
     } catch (e) {
        Visualforce.remoting.timeout = 120000; // Set timeout at page level
        Visualforce.remoting.Manager.invokeAction(
            '{!$RemoteAction.LeadExtension.logException}',
            e.message, 
            e.stack, 
            handleResult,
            {escape:true}
        );
        function handleResult(result, event) { 
          throw e;
        }
     }
   }
  </script>
</apex:page>
```


```java 
public class LeadExtension {
  @RemoteAction public static void logException (string message, string stack) {
    ExLog.ObjectWritter(
      JSON.serialize (
        new Exception_log__c (
            Message__c = message
          , Stack_Trace__c = stack
          , Source_Type__c = 'Visualforce'
          , Object_Name__c = 'N/A'
          , Method_name__c = 'causeException'
          , Exception_Type__c = 'JavaScript exception'
        )
      )
    );
  }
}
```
