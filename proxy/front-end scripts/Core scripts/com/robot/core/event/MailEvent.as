package com.robot.core.event
{
   import flash.events.Event;
   
   public class MailEvent extends Event
   {
      
      public static const MAIL_LIST:String = "mailList";
      
      public static const MAIL_DELETE:String = "mailDelete";
      
      public static const MAIL_CLEAR:String = "mailClear";
      
      public static const MAIL_SEND:String = "mailSend";
      
      public function MailEvent(_arg_1:String, _arg_2:Boolean = false, _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
   }
}

