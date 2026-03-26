package com.robot.core.mode
{
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class ActorModel extends BasePeoleModel
   {
      
      private var radius:Sprite;
      
      private var _footMC:MovieClip;
      
      public function ActorModel(_arg_1:UserInfo)
      {
         super(_arg_1);
         this._footMC = UIManager.getMovieClip("q_mc");
         addChildAt(this._footMC,0);
      }
      
      public function get footMC() : MovieClip
      {
         return this._footMC;
      }
      
      public function showShotRadius(_arg_1:uint) : void
      {
         if(!this.radius)
         {
            this.radius = new Sprite();
            this.radius.mouseEnabled = false;
         }
         this.radius.graphics.clear();
         this.radius.graphics.lineStyle(2,16776960,0.6);
         this.radius.graphics.beginFill(16776960,0.2);
         this.radius.graphics.drawCircle(0,0,_arg_1);
         addChildAt(this.radius,0);
      }
      
      public function hideRadius() : void
      {
         DisplayUtil.removeForParent(this.radius);
      }
      
      public function getIsPetFollw(_arg_1:uint) : Boolean
      {
         if(Boolean(pet))
         {
            if(pet.info.petID == _arg_1)
            {
               return true;
            }
            return false;
         }
         return false;
      }
   }
}

