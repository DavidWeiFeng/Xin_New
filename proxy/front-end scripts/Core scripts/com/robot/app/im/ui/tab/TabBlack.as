package com.robot.app.im.ui.tab
{
   import com.robot.app.im.ui.IMListItem;
   import com.robot.core.event.RelationEvent;
   import com.robot.core.manager.RelationManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TabBlack implements IIMTab
   {
      
      private var _index:int;
      
      private var _fun:Function;
      
      private var _ui:MovieClip;
      
      private var _con:Sprite;
      
      private var _isInfo:Boolean = true;
      
      public function TabBlack(_arg_1:int, _arg_2:MovieClip, _arg_3:Sprite, _arg_4:Function)
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
         RelationManager.addEventListener(RelationEvent.BLACK_ADD,this.onRelation);
         RelationManager.addEventListener(RelationEvent.BLACK_REMOVE,this.onRelation);
         RelationManager.addEventListener(RelationEvent.UPDATE_INFO,this.onRelation);
         if(this._isInfo)
         {
            RelationManager.setBlackInfo();
            this._isInfo = false;
         }
         else
         {
            this._fun(RelationManager.blackInfos,RelationManager.F_MAX);
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
         RelationManager.removeEventListener(RelationEvent.BLACK_ADD,this.onRelation);
         RelationManager.removeEventListener(RelationEvent.BLACK_REMOVE,this.onRelation);
         RelationManager.removeEventListener(RelationEvent.UPDATE_INFO,this.onRelation);
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(_arg_1:int) : void
      {
         this._index = _arg_1;
      }
      
      private function onRelation(_arg_1:RelationEvent) : void
      {
         var _local_2:IMListItem = null;
         switch(_arg_1.type)
         {
            case RelationEvent.BLACK_ADD:
            case RelationEvent.BLACK_REMOVE:
               this._fun(RelationManager.blackInfos,RelationManager.F_MAX);
               return;
            case RelationEvent.UPDATE_INFO:
               if(_arg_1.userID == 0)
               {
                  this._fun(RelationManager.blackInfos,RelationManager.F_MAX);
                  break;
               }
               _local_2 = this._con.getChildByName(_arg_1.userID.toString()) as IMListItem;
               if(Boolean(_local_2))
               {
                  _local_2.info = RelationManager.getBlackInfo(_arg_1.userID);
               }
         }
      }
   }
}

