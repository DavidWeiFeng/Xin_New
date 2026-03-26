package com.robot.app.aimat
{
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import flash.display.MovieClip;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class Aimat_10017 extends BaseAimat
   {
      
      private var ui:MovieClip;
      
      public function Aimat_10017()
      {
         super();
      }
      
      override public function execute(_arg_1:AimatInfo) : void
      {
         super.execute(_arg_1);
         this.ui = AimatController.getResEffect(_info.id);
         this.ui.x = _info.endPos.x;
         this.ui.y = _info.endPos.y;
         this.ui.mouseEnabled = false;
         this.ui.mouseChildren = false;
         MapManager.currentMap.depthLevel.addChild(this.ui);
         DepthManager.swapDepth(this.ui,this.ui.y);
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
         AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
      }
   }
}

