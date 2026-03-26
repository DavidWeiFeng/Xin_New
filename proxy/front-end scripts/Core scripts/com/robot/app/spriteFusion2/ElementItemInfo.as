package com.robot.app.spriteFusion2
{
   import com.robot.core.info.userItem.SingleItemInfo;
   
   public class ElementItemInfo
   {
      
      private var _num:int;
      
      private var _info:SingleItemInfo;
      
      public function ElementItemInfo()
      {
         super();
      }
      
      public function get num() : int
      {
         return this._num;
      }
      
      public function set num(_arg_1:int) : void
      {
         this._num = _arg_1;
      }
      
      public function set info(_arg_1:SingleItemInfo) : void
      {
         this._info = _arg_1;
      }
      
      public function get info() : SingleItemInfo
      {
         return this._info;
      }
   }
}

