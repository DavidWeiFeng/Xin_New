package com.robot.core.info.mail
{
   import flash.utils.IDataInput;
   
   public class MailListInfo
   {
      
      private var _total:uint;
      
      private var _mailList:Array;
      
      public function MailListInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         this._mailList = [];
         super();
         this._total = _arg_1.readUnsignedInt();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this._mailList.push(new SingleMailInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get total() : uint
      {
         return this._total;
      }
      
      public function get mailList() : Array
      {
         return this._mailList;
      }
   }
}

