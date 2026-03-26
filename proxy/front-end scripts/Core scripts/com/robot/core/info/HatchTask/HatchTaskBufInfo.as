package com.robot.core.info.HatchTask
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HatchTaskBufInfo
   {
      
      private var _ObtainTm:uint;
      
      private var _buf:ByteArray = new ByteArray();
      
      public function HatchTaskBufInfo(_arg_1:IDataInput)
      {
         super();
         this._ObtainTm = _arg_1.readUnsignedInt();
         _arg_1.readBytes(this._buf);
      }
      
      public function get obtainTm() : uint
      {
         return this._ObtainTm;
      }
      
      public function get buf() : ByteArray
      {
         return this._buf;
      }
   }
}

