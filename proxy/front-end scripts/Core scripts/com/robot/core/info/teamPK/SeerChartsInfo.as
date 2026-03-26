package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class SeerChartsInfo
   {
      
      private var list:Array;
      
      public function SeerChartsInfo(_arg_1:IDataInput)
      {
         var _local_3:uint = 0;
         this.list = [];
         super();
         var _local_2:uint = uint(_arg_1.readUnsignedInt());
         while(_local_3 < _local_2)
         {
            this.list.push(new SeerChartsItemInfo(_arg_1));
            _local_3++;
         }
      }
      
      public function get infoList() : Array
      {
         return this.list;
      }
   }
}

