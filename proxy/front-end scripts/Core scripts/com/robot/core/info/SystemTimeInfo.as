package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class SystemTimeInfo
   {
      
      private var _date:Date;
      
      private var _num:int;
      
      public function SystemTimeInfo(data:IDataInput)
      {
         var time:uint;
         super();
         time = uint(data.readUnsignedInt());
         this._date = new Date(time * 1000);
         try
         {
            this._num = int(data.readUnsignedInt());
         }
         catch(error:Error)
         {
            this._num = 0;
         }
      }
      
      public function get date() : Date
      {
         return this._date;
      }
      
      public function get num() : int
      {
         return this._num;
      }
   }
}

