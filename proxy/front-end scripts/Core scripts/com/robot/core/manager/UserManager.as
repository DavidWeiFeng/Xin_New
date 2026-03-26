package com.robot.core.manager
{
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.mode.BasePeoleModel;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class UserManager
   {
      
      private static var instance:EventDispatcher;
      
      private static var _listDic:HashMap = new HashMap();
      
      public static var _hideOtherUserModelFlag:Boolean = false;
      
      public function UserManager()
      {
         super();
      }
      
      public static function get length() : int
      {
         return _listDic.length;
      }
      
      public static function addUser(_arg_1:uint, _arg_2:BasePeoleModel) : BasePeoleModel
      {
         return _listDic.add(_arg_1,_arg_2);
      }
      
      public static function removeUser(_arg_1:uint) : BasePeoleModel
      {
         return _listDic.remove(_arg_1);
      }
      
      public static function getUserModel(_arg_1:uint) : BasePeoleModel
      {
         if(_arg_1 == MainManager.actorID)
         {
            return MainManager.actorModel;
         }
         return _listDic.getValue(_arg_1);
      }
      
      public static function clear() : void
      {
         var _local_1:Sprite = null;
         for each(_local_1 in getUserModelList())
         {
            DisplayUtil.removeForParent(_local_1);
         }
         _listDic.clear();
      }
      
      public static function getUserIDList() : Array
      {
         return _listDic.getKeys();
      }
      
      public static function getUserModelList() : Array
      {
         return _listDic.getValues();
      }
      
      public static function contains(_arg_1:uint) : Boolean
      {
         return _listDic.containsKey(_arg_1);
      }
      
      public static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addActionListener(_arg_1:uint, _arg_2:Function) : void
      {
         getInstance().addEventListener(_arg_1.toString(),_arg_2,false,0,false);
      }
      
      public static function removeActionListener(_arg_1:uint, _arg_2:Function) : void
      {
         getInstance().removeEventListener(_arg_1.toString(),_arg_2,false);
      }
      
      public static function dispatchAction(_arg_1:uint, _arg_2:String, _arg_3:Object) : void
      {
         if(hasActionListener(_arg_1))
         {
            getInstance().dispatchEvent(new PeopleActionEvent(_arg_1.toString(),_arg_2,_arg_3));
         }
      }
      
      public static function hasActionListener(_arg_1:uint) : Boolean
      {
         return getInstance().hasEventListener(_arg_1.toString());
      }
      
      public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1,_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:Event) : void
      {
         getInstance().dispatchEvent(_arg_1);
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
      
      public static function willTrigger(_arg_1:String) : Boolean
      {
         return getInstance().willTrigger(_arg_1);
      }
   }
}

