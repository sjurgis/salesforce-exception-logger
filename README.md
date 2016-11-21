# salesforce-exception-logger [![Deploy to Salesforce](https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png)](https://githubsfdeploy.herokuapp.com/?owner=sjurgis&repo=salesforce-exception-logger)

Log your exceptions for further analysis using reports or sending out workflow email alerts!

Invoke using ExLog.add(<Trigger || Class>, Object name, Method Name, exception object, is future) in the catch block of functions.
  
For example: `ExLog.add('Trigger', 'Account', 'SomeFunction', e, false);`


