package com.robot.app.bag
{
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import flash.utils.*;
   import org.taomee.events.DynamicEvent;
   import org.taomee.utils.*;
   
   public class BagTypePanel extends Sprite
   {
      
      private var _selectIndex:int = 0;
      
      private var _suitPanel:SuitListPanel;
      
      private var _esuitPanel:SuitListPanel;
      
      private var _app:ApplicationDomain;
      
      private var _selectItem:BagTypeListItem;
      
      private var _listCon:Sprite;
      
      private var _outTime:uint;
      
      public function BagTypePanel(_arg_1:ApplicationDomain)
      {
         var _local_2:int = 0;
         var _local_3:BagTypeListItem = null;
         var _local_4:Sprite = null;
         super();
         this._app = _arg_1;
         _local_4 = new (_arg_1.getDefinition("bagtypepanelMc") as Class)() as Sprite;
         _local_4.width = 104;
         _local_4.cacheAsBitmap = true;
         addChild(_local_4);
         this._listCon = new Sprite();
         this._listCon.x = 12;
         this._listCon.y = 15;
         addChild(this._listCon);
         var _local_5:int = int(BagShowType.typeNameList.length);
         while(_local_2 < _local_5)
         {
            _local_3 = new BagTypeListItem(this._app);
            _local_3.setInfo(_local_2,BagShowType.typeNameList[_local_2]);
            _local_3.y = _local_2 * (_local_3.height + 5);
            _local_3.addEventListener(MouseEvent.ROLL_OVER,this.onItemOver);
            _local_3.addEventListener(MouseEvent.ROLL_OUT,this.onItemOut);
            _local_3.addEventListener(MouseEvent.CLICK,this.onItemClick);
            this._listCon.addChild(_local_3);
            _local_2++;
         }
         this._selectItem = this._listCon.getChildAt(BagShowType.currType) as BagTypeListItem;
         this._selectItem.select = true;
         _local_4.height = this._listCon.height + 35;
      }
      
      public function setSelect(_arg_1:int) : void
      {
         this._selectItem.select = false;
         this._selectItem = this._listCon.getChildAt(_arg_1) as BagTypeListItem;
         this._selectItem.select = true;
      }
      
      private function suitDestroy() : void
      {
         if(Boolean(this._suitPanel))
         {
            this._suitPanel.removeEventListener(Event.SELECT,this.onSuitSelect);
            this._suitPanel.removeEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
            this._suitPanel.removeEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
            this._suitPanel.destroy();
            DisplayUtil.removeForParent(this._suitPanel);
            this._suitPanel = null;
         }
         if(Boolean(this._esuitPanel))
         {
            this._esuitPanel.removeEventListener(Event.SELECT,this.onSuitSelect);
            this._esuitPanel.removeEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
            this._esuitPanel.removeEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
            this._esuitPanel.destroy();
            DisplayUtil.removeForParent(this._esuitPanel);
            this._esuitPanel = null;
         }
      }
      
      private function onItemOver(_arg_1:MouseEvent) : void
      {
         var _local_2:BagTypeListItem = _arg_1.currentTarget as BagTypeListItem;
         if(_local_2.id == BagShowType.SUIT)
         {
            if(this._suitPanel == null)
            {
               this._suitPanel = new SuitListPanel(this._app);
               this._suitPanel.addEventListener(Event.SELECT,this.onSuitSelect);
               this._suitPanel.addEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
               this._suitPanel.addEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
               this._suitPanel.x = _local_2.x + _local_2.width + 10;
               this._suitPanel.y = -20;
            }
            addChild(this._suitPanel);
            clearTimeout(this._outTime);
         }
         else if(_local_2.id == BagShowType.ELITE_SUIT)
         {
            if(this._esuitPanel == null)
            {
               this._esuitPanel = new SuitListPanel(this._app,true);
               this._esuitPanel.addEventListener(Event.SELECT,this.onSuitSelect);
               this._esuitPanel.addEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
               this._esuitPanel.addEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
               this._esuitPanel.x = _local_2.x + _local_2.width + 10;
               this._esuitPanel.y = -20;
            }
            addChild(this._esuitPanel);
            clearTimeout(this._outTime);
         }
      }
      
      private function onItemOut(e:MouseEvent) : void
      {
         var item:BagTypeListItem = e.currentTarget as BagTypeListItem;
         if(item.id == BagShowType.SUIT)
         {
            if(Boolean(this._suitPanel))
            {
               clearTimeout(this._outTime);
               this._outTime = setTimeout(function():void
               {
                  suitDestroy();
               },500);
            }
         }
         if(item.id == BagShowType.ELITE_SUIT)
         {
            if(Boolean(this._esuitPanel))
            {
               clearTimeout(this._outTime);
               this._outTime = setTimeout(function():void
               {
                  suitDestroy();
               },500);
            }
         }
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         var _local_2:BagTypeListItem = _arg_1.currentTarget as BagTypeListItem;
         if(_local_2.id != BagShowType.SUIT)
         {
            dispatchEvent(new BagTypeEvent(BagTypeEvent.SELECT,_local_2.id));
         }
      }
      
      private function onSuitSelect(_arg_1:DynamicEvent) : void
      {
         dispatchEvent(new BagTypeEvent(BagTypeEvent.SELECT,BagShowType.SUIT,_arg_1.paramObject as uint));
      }
      
      private function onSuitOver(_arg_1:MouseEvent) : void
      {
         clearTimeout(this._outTime);
      }
      
      private function onSuitOut(_arg_1:MouseEvent) : void
      {
         this.suitDestroy();
      }
   }
}

