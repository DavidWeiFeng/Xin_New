package com.robot.app.aimat
{
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import org.taomee.utils.*;
   
   public class Aimat_10046 extends BaseAimat
   {
      
      private var speedPos:Point;
      
      private var ui:MovieClip;
      
      private var _speed:Number = 36;
      
      private var ice_mc:MovieClip;
      
      public function Aimat_10046()
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
         this.ice_mc = this.ui["ice_mc"];
         this.ice_mc.addFrameScript(this.ice_mc.totalFrames - 1,this.onEnter);
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
         this.speedPos = null;
      }
      
      private function onEnter() : void
      {
         var _local_1:DisplayObject = null;
         this.ice_mc.addFrameScript(this.ice_mc.totalFrames - 1,null);
         this.ice_mc.gotoAndStop(1);
         AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
         var _local_2:Array = MapManager.getObjectsPointRect(_info.endPos,30,[IAimatSprite]);
         for each(_local_1 in _local_2)
         {
            if(_local_1 is IAimatSprite)
            {
               IAimatSprite(_local_1).aimatState(_info);
            }
         }
      }
   }
}

