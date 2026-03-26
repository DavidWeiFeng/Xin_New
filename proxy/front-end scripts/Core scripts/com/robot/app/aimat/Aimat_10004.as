package com.robot.app.aimat
{
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import org.taomee.utils.*;
   
   public class Aimat_10004 extends BaseAimat
   {
      
      private var speedPos:Point;
      
      private var ui:MovieClip;
      
      private var ui2:MovieClip;
      
      private var arr:Array = [];
      
      private var _speed:Number = 20;
      
      public function Aimat_10004()
      {
         super();
      }
      
      override public function execute(_arg_1:AimatInfo) : void
      {
         super.execute(_arg_1);
         if(_arg_1.speed > 0)
         {
            this._speed = _arg_1.speed;
         }
         this.ui = AimatController.getResEffect(_info.id);
         this.ui.x = _info.startPos.x;
         this.ui.y = _info.startPos.y - this.ui.height - 6;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         this.ui.scaleX = _info.endPos.x > _info.startPos.x ? 1 : -1;
         MapManager.currentMap.depthLevel.addChild(this.ui);
         _info.startPos.x = this.ui.scaleX > 0 ? this.ui.x + this.ui.width + this._speed : this.ui.x - this.ui.width - this._speed;
         _info.startPos.y = this.ui.y;
         this.speedPos = GeomUtil.angleSpeed(_info.endPos,_info.startPos);
         this.speedPos.x *= this._speed;
         this.speedPos.y *= this._speed;
         this.ui.addFrameScript(this.ui.totalFrames - 1,this.onEnd);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this.ui))
         {
            this.ui.addFrameScript(this.ui.totalFrames - 1,null);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
         }
         this.speedPos = null;
         if(Boolean(this.ui2))
         {
            this.ui2.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.ui2);
            this.ui2 = null;
         }
         this.arr = null;
      }
      
      private function onEnd() : void
      {
         var _local_1:MovieClip = null;
         var _local_2:int = 0;
         this.ui.addFrameScript(this.ui.totalFrames - 1,null);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
         while(_local_2 < 5)
         {
            _local_1 = AimatController.getResEffect(_info.id,"02");
            _local_1.mouseEnabled = false;
            _local_1.mouseChildren = false;
            _local_1.scaleX = _local_1.scaleY = Math.random();
            _local_1.alpha = Math.random() + 0.3;
            _local_1.x = _info.startPos.x;
            _local_1.y = _info.startPos.y;
            this.arr.push(_local_1);
            MapManager.currentMap.depthLevel.addChild(_local_1);
            _local_2++;
         }
         this.ui2 = AimatController.getResEffect(_info.id,"02");
         this.ui2.x = _info.startPos.x;
         this.ui2.y = _info.startPos.y;
         this.ui2.mouseEnabled = false;
         this.ui2.mouseChildren = false;
         MapManager.currentMap.depthLevel.addChild(this.ui2);
         this.ui2.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onEnter(_arg_1:Event) : void
      {
         var _local_2:int = 0;
         var _local_3:IAimatSprite = null;
         var _local_4:MovieClip = null;
         var _local_5:MovieClip = null;
         var _local_6:int = 0;
         if(Math.abs(this.ui2.x - _info.endPos.x) < this._speed / 2 && Math.abs(this.ui2.y - _info.endPos.y) < this._speed / 2)
         {
            this.ui2.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.ui2);
            this.ui2 = null;
            _local_2 = 0;
            while(_local_2 < 5)
            {
               _local_4 = this.arr[_local_2];
               DisplayUtil.removeForParent(_local_4);
               _local_4 = null;
               _local_2++;
            }
            this.arr = null;
            AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
            _local_3 = MapManager.getObjectPoint(_info.endPos,[IAimatSprite]) as IAimatSprite;
            if(Boolean(_local_3))
            {
               _local_3.aimatState(_info);
            }
            return;
         }
         this.ui2.x += this.speedPos.x;
         this.ui2.y += this.speedPos.y;
         while(_local_6 < 5)
         {
            _local_5 = this.arr[_local_6];
            _local_5.x += this.speedPos.x + Math.random() * 6 - 3;
            _local_5.y += this.speedPos.y + (Math.random() * 40 - 20);
            _local_6++;
         }
      }
   }
}

