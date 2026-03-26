package com.robot.core.info
{
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   
   public class MapHotInfo
   {
      
      private var _infos:HashMap;
      
      public function MapHotInfo(_arg_1:IDataInput)
      {
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_5:uint = 0;
         super();
         this._infos = new HashMap();
         var _local_4:uint = _arg_1.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = _arg_1.readUnsignedInt();
            _local_3 = _arg_1.readUnsignedInt();
            this._infos.add(_local_2,_local_3);
            _local_5++;
         }
      }
      
      public function get infos() : HashMap
      {
         return this._infos;
      }
   }
}

