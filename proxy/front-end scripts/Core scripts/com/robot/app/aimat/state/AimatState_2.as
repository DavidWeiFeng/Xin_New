package com.robot.app.aimat.state
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   
   public class AimatState_2 implements IAimatState
   {
      
      private var _maoyan:MovieClip;
      
      private var _obj:IAimatSprite;
      
      private var _count:int = 0;
      
      public function AimatState_2()
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
         var _local_3:MovieClip = null;
         this._obj = _arg_1;
         var _local_4:Array = [0.6,1.2,0.1,0,-263,0.6,1.2,0.16,0,-263,0.6,1.2,0.16,0,-263,0,0,0,1,0];
         if(_arg_1.sprite is BasePeoleModel)
         {
            _local_3 = BasePeoleModel(_arg_1.sprite).skeleton.getSkeletonMC();
            _local_3.filters = [new ColorMatrixFilter(_local_4)];
            this._maoyan = AimatController.getResState(10001);
            this._maoyan.mouseEnabled = false;
            this._maoyan.y = -_arg_1.hitRect.height;
            _arg_1.sprite.addChildAt(this._maoyan,0);
         }
         else
         {
            _arg_1.sprite.filters = [new ColorMatrixFilter(_local_4)];
         }
      }
      
      public function destroy() : void
      {
         var _local_1:MovieClip = null;
         _local_1 = null;
         if(this._obj is BasePeoleModel)
         {
            if(Boolean(this._maoyan))
            {
               DisplayUtil.removeForParent(this._maoyan);
               this._maoyan = null;
            }
            BasePeoleModel(this._obj).skeleton.getSkeletonMC().filters = [];
            _local_1 = AimatController.getResState(1000102);
            _local_1.x = this._obj.sprite.x;
            _local_1.y = this._obj.sprite.y;
            MovieClipUtil.playEndAndRemove(_local_1);
            MapManager.currentMap.depthLevel.addChild(_local_1);
         }
         else
         {
            this._obj.sprite.filters = [];
         }
         this._obj = null;
      }
   }
}

