package com.robot.app.aimat
{
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.MovieClip;
   import org.taomee.utils.*;
   
   public class Aimat_10016 extends BaseAimat
   {
      
      private var ui:MovieClip;
      
      public function Aimat_10016()
      {
         super();
      }
      
      override public function execute(_arg_1:AimatInfo) : void
      {
         super.execute(_arg_1);
         this.ui = AimatController.getResEffect(_info.id);
         this.ui.x = _info.startPos.x;
         this.ui.y = _info.startPos.y;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         this.ui.rotation = GeomUtil.pointAngle(_info.endPos,_info.startPos);
         MapManager.currentMap.depthLevel.addChild(this.ui);
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
      }
      
      private function onEnd() : void
      {
         this.ui.addFrameScript(this.ui.totalFrames - 1,null);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
         AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
         var _local_1:IAimatSprite = MapManager.getObjectPoint(_info.endPos,[IAimatSprite]) as IAimatSprite;
         if(Boolean(_local_1))
         {
            _local_1.aimatState(_info);
         }
      }
   }
}

