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
   
   public class Aimat_10015 extends BaseAimat
   {
      
      private var speedPos:Point;
      
      private var ui:MovieClip;
      
      private var _speed:Number = 36;
      
      public function Aimat_10015()
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
         this.ui.y = _info.startPos.y;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         this.ui.rotation = GeomUtil.pointAngle(_info.endPos,_info.startPos);
         MapManager.currentMap.depthLevel.addChild(this.ui);
         this.speedPos = GeomUtil.angleSpeed(_info.endPos,_info.startPos);
         this.speedPos.x *= this._speed;
         this.speedPos.y *= this._speed;
         this.ui.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this.ui))
         {
            this.ui.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
         }
      }
      
      private function onEnter(_arg_1:Event) : void
      {
         var _local_2:IAimatSprite = null;
         if(Math.abs(this.ui.x - _info.endPos.x) < this._speed / 2 && Math.abs(this.ui.y - _info.endPos.y) < this._speed / 2)
         {
            this.ui.removeEventListener(Event.ENTER_FRAME,this.onEnter);
            AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
            DisplayUtil.removeForParent(this.ui);
            this.ui = null;
            _local_2 = MapManager.getObjectPoint(_info.endPos,[IAimatSprite]) as IAimatSprite;
            if(Boolean(_local_2))
            {
               _local_2.aimatState(_info);
            }
            return;
         }
         this.ui.x += this.speedPos.x;
         this.ui.y += this.speedPos.y;
      }
   }
}

