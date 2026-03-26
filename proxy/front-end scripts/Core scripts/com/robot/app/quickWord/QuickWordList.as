package com.robot.app.quickWord
{
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class QuickWordList extends Sprite
   {
      
      private var parentList:QuickWordList;
      
      private var subList:QuickWordList;
      
      private var perHeight:Number;
      
      private var checkTimer:Timer;
      
      private var _totalHeight:Number;
      
      public function QuickWordList(_arg_1:XML, _arg_2:QuickWordList = null)
      {
         super();
         this.checkTimer = new Timer(2000,1);
         this.checkTimer.addEventListener(TimerEvent.TIMER,this.checkIsHit);
         this.parentList = _arg_2;
         var _local_3:XMLList = _arg_1.elements("menu");
         if(_local_3.length() > 0)
         {
            this.listMC(_local_3);
         }
      }
      
      public function destroy() : void
      {
         if(!this.parentList)
         {
            dispatchEvent(new Event(Event.CLOSE));
         }
         if(Boolean(this.subList))
         {
            this.subList.destroy();
         }
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.checkTimer.stop();
         this.checkTimer.removeEventListener(TimerEvent.TIMER,this.checkIsHit);
         this.checkTimer = null;
         this.parentList = null;
         this.subList = null;
      }
      
      private function listMC(_arg_1:XMLList) : void
      {
         var _local_2:XML = null;
         var _local_3:MovieClip = null;
         var _local_4:TextField = null;
         var _local_5:int = 0;
         _local_2 = null;
         _local_3 = null;
         var _local_6:Number = 0;
         var _local_7:Array = [];
         for each(_local_2 in _arg_1)
         {
            _local_3 = UIManager.getMovieClip("quickWordListMC");
            _local_3.gotoAndStop(1);
            this.perHeight = _local_3.height + 1;
            _local_3.mouseChildren = false;
            this._totalHeight = this.perHeight * _arg_1.length();
            _local_4 = _local_3["txt"];
            _local_4.autoSize = TextFieldAutoSize.CENTER;
            _local_4.text = _local_2.@title;
            _local_6 = Math.max(_local_6,_local_4.width);
            _local_3.xml = _local_2;
            _local_3.y = this._totalHeight - this.perHeight * (_local_5 + 1);
            _local_3.buttonMode = true;
            if(_local_2.children().length() == 0)
            {
               _local_3["dotMC"].visible = false;
               _local_3.addEventListener(MouseEvent.CLICK,this.clickHandler);
            }
            _local_3.addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            _local_3.addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
            _local_7.push(_local_3);
            _local_5++;
         }
         this.formatMC(_local_7,_local_6);
      }
      
      private function formatMC(_arg_1:Array, _arg_2:Number) : void
      {
         var _local_3:MovieClip = null;
         var _local_4:MovieClip = null;
         var _local_5:MovieClip = null;
         _arg_2 = Math.max(100,_arg_2);
         for each(_local_3 in _arg_1)
         {
            _local_4 = _local_3["bgMC"];
            _local_5 = _local_3["dotMC"];
            _local_4.width = _arg_2 + _local_5.width + 12;
            _local_3["txt"].x = (_local_4.width - _local_3["txt"].width) / 2;
            _local_5.x = _local_4.width - _local_5.width - 6;
            this.addChild(_local_3);
         }
      }
      
      public function resetPosition() : void
      {
         if(!this.parentList)
         {
            return;
         }
         var _local_1:Point = this.localToGlobal(new Point());
         var _local_2:Number = _local_1.y + this.height - this.getFirst().totalHeight;
         if(_local_2 > 0)
         {
            this.y -= this.perHeight;
            this.resetPosition();
         }
      }
      
      public function get totalHeight() : Number
      {
         var _local_1:Point = this.localToGlobal(new Point());
         return _local_1.y + this._totalHeight;
      }
      
      public function getFirst() : QuickWordList
      {
         var _local_1:QuickWordList = this;
         while(Boolean(_local_1.parentList))
         {
            _local_1 = _local_1.parentList;
         }
         return _local_1;
      }
      
      private function overHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         _local_2["bgMC"].gotoAndStop(2);
         _local_2["dotMC"].gotoAndStop(2);
         if(Boolean(this.subList))
         {
            this.subList.destroy();
         }
         this.subList = null;
         var _local_3:DisplayObject = _arg_1.currentTarget as DisplayObject;
         _local_2 = _arg_1.currentTarget as MovieClip;
         var _local_4:XMLList = XML(_local_2.xml).elements("menu");
         if(_local_4.length() > 0)
         {
            this.subList = new QuickWordList(_local_2.xml,this);
            this.subList.x = this.width;
            this.subList.y = _local_3.y;
            this.addChild(this.subList);
            this.subList.resetPosition();
         }
      }
      
      private function outHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         _local_2["bgMC"].gotoAndStop(1);
         _local_2["dotMC"].gotoAndStop(1);
         if(Boolean(this.checkTimer))
         {
            this.checkTimer.stop();
            this.checkTimer.start();
         }
      }
      
      private function clickHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         this.getFirst().destroy();
         MainManager.actorModel.chatAction(_local_2["txt"].text);
      }
      
      private function checkIsHit(_arg_1:TimerEvent) : void
      {
         var _local_2:QuickWordList = this.getFirst();
         if(!_local_2.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true))
         {
            _local_2.destroy();
         }
      }
   }
}

