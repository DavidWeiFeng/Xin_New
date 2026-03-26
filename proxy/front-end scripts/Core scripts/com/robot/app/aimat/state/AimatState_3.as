package com.robot.app.aimat.state
{
   import com.robot.core.aimat.*;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.pet.*;
   import com.robot.core.mode.*;
   
   public class AimatState_3 implements IAimatState
   {
      
      private var _mc:PetModel;
      
      private var _count:int = 0;
      
      private var objs:IAimatSprite;
      
      private var petArr:Array = [164,77,27,62,108];
      
      public function AimatState_3()
      {
         super();
      }
      
      public function get isFinish() : Boolean
      {
         if(Boolean(this.objs))
         {
            this._mc.x = this.objs.sprite.x;
            this._mc.y = this.objs.sprite.y;
            this._mc.direction = this.objs.direction;
         }
         ++this._count;
         if(this._count >= 50)
         {
            return true;
         }
         return false;
      }
      
      public function execute(_arg_1:IAimatSprite, _arg_2:AimatInfo) : void
      {
         this.objs = _arg_1;
         if(_arg_1.sprite.visible == false)
         {
            return;
         }
         var _local_3:ActionSpriteModel = _arg_1.sprite as ActionSpriteModel;
         this._mc = new PetModel(_local_3);
         var _local_4:PetShowInfo = new PetShowInfo();
         var _local_5:int = int(Math.random() * 5);
         _local_4.petID = int(this.petArr[_local_5]);
         this._mc.show(_local_4);
         this._mc.x -= 40;
         this._mc.y -= 5;
         _arg_1.sprite.visible = false;
      }
      
      public function destroy() : void
      {
         this.objs.sprite.visible = true;
         this._mc.destroy();
         this._mc = null;
      }
   }
}

