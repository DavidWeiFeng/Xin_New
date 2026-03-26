package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class SystemMsgInfo
   {
      
      public var isNewYear:Boolean = false;
      
      public var npc:uint;
      
      public var msgTime:uint;
      
      private var msgLen:uint;
      
      public var msg:String;
      
      public var type:uint;
      
      public function SystemMsgInfo(_arg_1:IDataInput = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this.type = _arg_1.readShort();
            this.npc = _arg_1.readShort();
            this.msgTime = _arg_1.readUnsignedInt();
            this.msgLen = _arg_1.readUnsignedInt();
            this.msg = _arg_1.readUTFBytes(this.msgLen);
         }
      }
   }
}

