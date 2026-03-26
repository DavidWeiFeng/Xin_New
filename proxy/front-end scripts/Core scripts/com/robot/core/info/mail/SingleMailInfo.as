package com.robot.core.info.mail
{
   import flash.utils.IDataInput;
   
   public class SingleMailInfo
   {
      
      private var _id:uint;
      
      public var template:uint;
      
      public var time:uint;
      
      public var fromID:uint;
      
      public var fromNick:String;
      
      private var _flag:uint;
      
      public var content:String;
      
      public function SingleMailInfo(_arg_1:IDataInput = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this._id = _arg_1.readUnsignedInt();
            this.template = _arg_1.readUnsignedInt();
            this.time = _arg_1.readUnsignedInt();
            this.fromID = _arg_1.readUnsignedInt();
            this.fromNick = _arg_1.readUTFBytes(16);
            this._flag = _arg_1.readUnsignedInt();
         }
      }
      
      public function get readed() : Boolean
      {
         return this._flag == 1;
      }
      
      public function set readed(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this._flag = 1;
         }
         else
         {
            this._flag = 0;
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get date() : Date
      {
         var _local_1:Date = new Date();
         _local_1.setTime(this.time * 1000);
         return _local_1;
      }
   }
}

