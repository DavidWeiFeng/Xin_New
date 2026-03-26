package com.robot.app.toolBar.pkTool
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.teamPK.TeamPKManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.effect.ColorFilter;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PetFightMouseIcon extends BasePKMouseIcon implements IPKMouseIcon
   {
      
      private var bmp:Bitmap;
      
      public function PetFightMouseIcon()
      {
         super();
         ToolTipManager.add(this,"精灵对战");
      }
      
      override protected function getIcon() : Sprite
      {
         var _local_1:Sprite = new Sprite();
         _local_1.addChild(ShotBehaviorManager.getMovieClip("pk_icon_bg"));
         var _local_2:SimpleButton = ShotBehaviorManager.getButton("pk_icon_fight");
         DisplayUtil.align(_local_2,_local_1.getRect(_local_1),AlignType.MIDDLE_CENTER);
         _local_1.addChild(_local_2);
         return _local_1;
      }
      
      override protected function getMouseIcon() : Sprite
      {
         var _local_1:Sprite = new Sprite();
         var _local_2:MovieClip = ShotBehaviorManager.getMovieClip("pk_mouseIcon_pet");
         this.bmp = DisplayUtil.copyDisplayAsBmp(_local_2);
         _local_1.graphics.beginFill(0,0);
         _local_1.graphics.drawRect(this.bmp.x,this.bmp.y,this.bmp.width,this.bmp.height);
         _local_1.addChild(this.bmp);
         return _local_1;
      }
      
      override public function move(_arg_1:Point) : void
      {
         var _local_2:Point = MainManager.actorModel.localToGlobal(new Point());
         if(Point.distance(_local_2,_arg_1) > petDis)
         {
            outOfDistance = true;
            mouseIcon.filters = [ColorFilter.setGrayscale()];
         }
         else
         {
            outOfDistance = false;
            mouseIcon.filters = [];
         }
      }
      
      override public function click() : void
      {
         var _local_1:BasePeoleModel = null;
         for each(_local_1 in UserManager.getUserModelList())
         {
            if(_local_1.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY))
            {
               if(_local_1.isShield)
               {
                  _local_1.showShieldMovie();
               }
               else
               {
                  TeamPKManager.petFight(_local_1.info.userID);
               }
               break;
            }
         }
      }
      
      override public function show() : void
      {
         super.show();
         MainManager.actorModel.showShotRadius(petDis);
      }
   }
}

