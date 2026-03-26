package com.robot.core.info.fbGame
{
   import flash.utils.IDataInput;
   
   public class FBGameOverInfo
   {
      
      private var _array:Array;
      
      public function FBGameOverInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         this._array = [];
         super();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this._array.push(new GameOverUserInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get userList() : Array
      {
         return this._array;
      }
   }
}

