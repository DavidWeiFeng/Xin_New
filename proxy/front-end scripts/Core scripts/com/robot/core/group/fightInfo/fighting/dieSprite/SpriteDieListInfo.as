package com.robot.core.group.fightInfo.fighting.dieSprite
{
   import flash.utils.IDataInput;
   
   public class SpriteDieListInfo
   {
      
      private var _count:uint;
      
      private var _list:Array;
      
      public function SpriteDieListInfo(param1:IDataInput = null)
      {
         var _loc2_:SpriteDieInfo = null;
         super();
         this._count = param1.readUnsignedByte();
         this._list = [];
         var _loc3_:uint = 0;
         while(_loc3_ < this._count)
         {
            _loc2_ = new SpriteDieInfo(param1);
            this._list.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function get count() : uint
      {
         return this._count;
      }
      
      public function get list() : Array
      {
         return this._list;
      }
   }
}

