package com.robot.core.info
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import flash.utils.IDataInput;
   
   public class ChangeClothInfo
   {
      
      private var _userID:uint;
      
      private var _clothArray:Array;
      
      public function ChangeClothInfo(_arg_1:IDataInput)
      {
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_5:uint = 0;
         this._clothArray = [];
         super();
         this._userID = _arg_1.readUnsignedInt();
         var _local_4:uint = uint(_arg_1.readUnsignedInt());
         while(_local_5 < _local_4)
         {
            _local_2 = uint(_arg_1.readUnsignedInt());
            _local_3 = uint(_arg_1.readUnsignedInt());
            this._clothArray.push(new PeopleItemInfo(_local_2,_local_3));
            _local_5++;
         }
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get clothArray() : Array
      {
         return this._clothArray;
      }
   }
}

