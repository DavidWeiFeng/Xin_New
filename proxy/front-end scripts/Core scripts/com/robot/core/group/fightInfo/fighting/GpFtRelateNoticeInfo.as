package com.robot.core.group.fightInfo.fighting
{
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   
   public class GpFtRelateNoticeInfo
   {
      
      private var _side:uint;
      
      private var _relationMap:HashMap;
      
      public function GpFtRelateNoticeInfo(param1:IDataInput = null)
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         this._relationMap = new HashMap();
         super();
         this._side = param1.readUnsignedByte();
         var _loc8_:uint = uint(param1.readUnsignedByte());
         var _loc9_:uint = 0;
         while(_loc9_ < _loc8_)
         {
            _loc2_ = uint(param1.readUnsignedShort());
            _loc3_ = uint(param1.readUnsignedByte());
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc6_ = uint(param1.readUnsignedByte());
               _loc7_ = uint(param1.readUnsignedInt());
               _loc4_.push(_loc6_);
               _loc5_++;
            }
            if(_loc4_.length > 0)
            {
               this._relationMap.add(_loc2_,_loc4_);
            }
            _loc9_++;
         }
      }
      
      public function get side() : uint
      {
         return this._side;
      }
      
      public function get relationMap() : HashMap
      {
         return this._relationMap;
      }
   }
}

