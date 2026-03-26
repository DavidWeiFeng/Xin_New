package com.robot.app.im.ui.tab
{
   import com.robot.core.manager.UserManager;
   import com.robot.core.mode.BasePeoleModel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TabOnline implements IIMTab
   {
      
      private var _index:int;
      
      private var _fun:Function;
      
      private var _ui:MovieClip;
      
      private var _con:Sprite;
      
      public function TabOnline(_arg_1:int, _arg_2:MovieClip, _arg_3:Sprite, _arg_4:Function)
      {
         super();
         this._index = _arg_1;
         this._ui = _arg_2;
         this._ui.gotoAndStop(1);
         this._con = _arg_3;
         this._fun = _arg_4;
      }
      
      public function show() : void
      {
         var _local_1:BasePeoleModel = null;
         this._ui.mouseEnabled = false;
         if(Boolean(this._ui.parent))
         {
            this._ui.parent.addChild(this._ui);
            this._ui.gotoAndStop(2);
         }
         var _local_2:Array = [];
         var _local_3:Array = UserManager.getUserModelList();
         for each(_local_1 in _local_3)
         {
            _local_2.push(_local_1.info);
         }
         _local_2.sortOn("vip",Array.DESCENDING | Array.NUMERIC);
         this._fun(_local_2,300);
      }
      
      public function hide() : void
      {
         this._ui.mouseEnabled = true;
         if(Boolean(this._ui.parent))
         {
            this._ui.parent.addChildAt(this._ui,0);
            this._ui.gotoAndStop(1);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(_arg_1:int) : void
      {
         this._index = _arg_1;
      }
   }
}

