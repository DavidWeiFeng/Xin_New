package com.robot.core.event
{
   import flash.events.Event;
   
   public class TaskEvent extends Event
   {
      
      public static const ACCEPT:String = "accept";
      
      public static const COMPLETE:String = "complete";
      
      public static const QUIT:String = "quit";
      
      public static const GET_PRO_STATUS:String = "getProStatus";
      
      public static const SET_PRO_STATUS:String = "setProStatus";
      
      public static const GET_PRO_STATUS_LIST:String = "getProStatusList";
      
      private var _actType:String;
      
      private var _taskID:uint;
      
      private var _pro:uint;
      
      private var _flag:Boolean;
      
      private var _data:Array;
      
      public function TaskEvent(_arg_1:String, _arg_2:uint, _arg_3:uint, _arg_4:Boolean, _arg_5:Array = null)
      {
         super(_arg_1 + "_" + _arg_2.toString() + "_" + _arg_3.toString());
         this._actType = _arg_1;
         this._taskID = _arg_2;
         this._pro = _arg_3;
         this._flag = _arg_4;
         this._data = _arg_5;
      }
      
      public function get actType() : String
      {
         return this._actType;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      public function get pro() : uint
      {
         return this._pro;
      }
      
      public function get flag() : Boolean
      {
         return this._flag;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
   }
}

