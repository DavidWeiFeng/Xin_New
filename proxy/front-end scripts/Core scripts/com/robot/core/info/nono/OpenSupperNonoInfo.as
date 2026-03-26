package com.robot.core.info.nono
{
   import flash.utils.IDataInput;
   
   public class OpenSupperNonoInfo
   {
      
      private var _success:Number;
      
      public function OpenSupperNonoInfo(data:IDataInput)
      {
         super();
         this._success = data.readUnsignedInt();
      }
      
      public function get success() : Number
      {
         return this._success;
      }
   }
}

