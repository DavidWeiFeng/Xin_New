package com.robot.app.bag
{
   import flash.events.Event;
   
   public class BagTypeEvent extends Event
   {
      
      public static const SELECT:String = "bagSelect";
      
      private var _showType:int;
      
      private var _suitID:uint;
      
      public function BagTypeEvent(_arg_1:String, _arg_2:int, _arg_3:uint = 0)
      {
         super(_arg_1);
         this._showType = _arg_2;
         this._suitID = _arg_3;
      }
      
      public function get showType() : int
      {
         return this._showType;
      }
      
      public function get suitID() : int
      {
         return this._suitID;
      }
   }
}

