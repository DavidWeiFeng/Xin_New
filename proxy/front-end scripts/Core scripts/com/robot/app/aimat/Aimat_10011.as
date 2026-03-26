package com.robot.app.aimat
{
   import com.robot.core.aimat.*;
   import com.robot.core.event.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.MovieClip;
   import org.taomee.utils.*;
   
   public class Aimat_10011 extends BaseAimat
   {
      
      private var ui:MovieClip;
      
      private var ui2:MovieClip;
      
      public function Aimat_10011()
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
         MapManager.currentMap.root.addChild(this.ui);
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
         if(Boolean(this.ui2))
         {
            this.ui2.addFrameScript(this.ui2.totalFrames - 1,null);
            DisplayUtil.removeForParent(this.ui2);
            this.ui2 = null;
         }
      }
      
      private function onEnd() : void
      {
         this.ui.addFrameScript(this.ui.totalFrames - 1,null);
         AimatController.dispatchEvent(AimatEvent.PLAY_END,_info);
         DisplayUtil.removeForParent(this.ui);
         this.ui = null;
         this.ui2 = AimatController.getResEffect(_info.id,"02");
         this.ui2.x = _info.endPos.x;
         this.ui2.y = _info.endPos.y;
         this.ui2.mouseEnabled = false;
         this.ui2.mouseChildren = false;
         MapManager.currentMap.root.addChild(this.ui2);
         this.ui2.addFrameScript(this.ui2.totalFrames - 1,this.onEnd2);
      }
      
      private function onEnd2() : void
      {
         this.ui2.addFrameScript(this.ui2.totalFrames - 1,null);
         DisplayUtil.removeForParent(this.ui2);
         this.ui2 = null;
         var _local_1:IAimatSprite = MapManager.getObjectPoint(_info.endPos,[IAimatSprite]) as IAimatSprite;
         if(Boolean(_local_1))
         {
            _local_1.aimatState(_info);
         }
      }
   }
}

