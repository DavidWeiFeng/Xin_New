package com.robot.core.event
{
   import flash.events.Event;
   
   public class CutBmpEvent extends Event
   {
      
      public static const CUT_BMP_COMPLETE:String = "cutBmpComplete";
      
      private var _imgUrl:String;
      
      private var _toID:uint;
      
      public function CutBmpEvent(_arg_1:String, _arg_2:String, _arg_3:uint = 0, _arg_4:Boolean = false, _arg_5:Boolean = false)
      {
         super(_arg_1,_arg_4,_arg_5);
         this._imgUrl = _arg_2;
         this._toID = _arg_3;
      }
      
      public function get imgURL() : String
      {
         return this._imgUrl;
      }
      
      public function get toID() : uint
      {
         return this._toID;
      }
   }
}

