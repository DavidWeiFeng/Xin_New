package com.robot.app.aimat.state
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import org.taomee.utils.DisplayUtil;
   
   public class AimatState_10046 implements IAimatState
   {
      
      private var _ui:MovieClip;
      
      public function AimatState_10046()
      {
         super();
      }
      
      public function get isFinish() : Boolean
      {
         if(this._ui.currentFrame == this._ui.totalFrames - 1)
         {
            return true;
         }
         return false;
      }
      
      public function execute(_arg_1:IAimatSprite, _arg_2:AimatInfo) : void
      {
         var _local_3:Rectangle = _arg_1.hitRect;
         this._ui = AimatController.getResState(_arg_2.id);
         this._ui.mouseEnabled = false;
         this._ui.mouseChildren = false;
         _arg_1.sprite.addChild(this._ui);
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this._ui);
         this._ui = null;
      }
   }
}

