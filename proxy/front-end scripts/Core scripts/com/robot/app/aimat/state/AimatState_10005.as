package com.robot.app.aimat.state
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import org.taomee.utils.DisplayUtil;
   
   public class AimatState_10005 implements IAimatState
   {
      
      private var _mc:MovieClip;
      
      private var _obj:DisplayObject;
      
      private var _count:int = 0;
      
      public function AimatState_10005()
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
         this._obj = BasePeoleModel(_arg_1).skeleton.getSkeletonMC();
         var _local_3:Rectangle = _arg_1.hitRect;
         this._mc = AimatController.getResState(_arg_2.id);
         this._mc.mouseEnabled = false;
         this._mc.mouseChildren = false;
         this._mc.x = _arg_1.centerPoint.x - _arg_1.sprite.x;
         this._mc.y = _arg_1.centerPoint.y - _arg_1.sprite.y;
         _arg_1.sprite.addChild(this._mc);
         var _local_4:ColorTransform = new ColorTransform();
         _local_4.color = 16777215;
         if(_arg_1 is BasePeoleModel)
         {
            this._obj.transform.colorTransform = _local_4;
         }
      }
      
      public function destroy() : void
      {
         this._obj.transform.colorTransform = new ColorTransform();
         DisplayUtil.removeForParent(this._mc);
         this._mc = null;
         this._obj = null;
      }
   }
}

