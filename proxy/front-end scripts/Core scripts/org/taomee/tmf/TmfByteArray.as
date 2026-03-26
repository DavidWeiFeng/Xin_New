package org.taomee.tmf
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TmfByteArray extends ByteArray
   {
      
      public function TmfByteArray(_arg_1:IDataInput)
      {
         super();
         _arg_1.readBytes(this,bytesAvailable);
      }
   }
}

