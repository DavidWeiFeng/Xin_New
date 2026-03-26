package com.robot.app.im.ui.tab
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TabNewly implements IIMTab
   {
      
      private var _index:int;
      
      private var _fun:Function;
      
      private var _ui:MovieClip;
      
      private var _con:Sprite;
      
      private var _isInfo:Boolean = true;
      
      public function TabNewly(_arg_1:int, _arg_2:MovieClip, _arg_3:Sprite, _arg_4:Function)
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
         this._ui.mouseEnabled = false;
         if(Boolean(this._ui.parent))
         {
            this._ui.parent.addChild(this._ui);
            this._ui.gotoAndStop(2);
         }
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

