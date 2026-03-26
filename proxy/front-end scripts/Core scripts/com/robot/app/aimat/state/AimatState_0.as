package com.robot.app.aimat.state
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import org.taomee.utils.DisplayUtil;
   
   public class AimatState_0 implements IAimatState
   {
      
      private var _ui:MovieClip;
      
      private var _count:int = 0;
      
      public function AimatState_0()
      {
         super();
      }
      
      public function get isFinish() : Boolean
      {
         ++this._count;
         if(this._count >= 50)
         {
            return true;
         }
         return false;
      }
      
      public function execute(_arg_1:IAimatSprite, _arg_2:AimatInfo) : void
      {
         var _local_3:Rectangle = null;
         _local_3 = null;
         _local_3 = _arg_1.hitRect;
         this._ui = AimatController.getResState(_arg_2.id);
         this._ui.mouseEnabled = false;
         this._ui.mouseChildren = false;
         this._ui.x = _local_3.width / 2 - Math.random() * _local_3.width + _arg_1.centerPoint.x - _arg_1.sprite.x;
         this._ui.y = -Math.random() * _local_3.height + _arg_1.centerPoint.y - _arg_1.sprite.y;
         _arg_1.sprite.addChild(this._ui);
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this._ui);
         this._ui = null;
      }
   }
}

