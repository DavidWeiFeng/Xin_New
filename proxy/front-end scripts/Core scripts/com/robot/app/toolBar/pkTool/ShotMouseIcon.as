package com.robot.app.toolBar.pkTool
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.ShotDisXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ShotMouseIcon extends BasePKMouseIcon implements IPKMouseIcon
   {
      
      private var bmp:Bitmap;
      
      public function ShotMouseIcon()
      {
         super();
         ToolTipManager.add(this,"射击");
      }
      
      override protected function getIcon() : Sprite
      {
         var _local_1:Sprite = new Sprite();
         _local_1.addChild(ShotBehaviorManager.getMovieClip("pk_icon_bg"));
         var _local_2:SimpleButton = ShotBehaviorManager.getButton("pk_icon_shot");
         DisplayUtil.align(_local_2,_local_1.getRect(_local_1),AlignType.MIDDLE_CENTER);
         _local_1.addChild(_local_2);
         return _local_1;
      }
      
      override protected function getMouseIcon() : Sprite
      {
         var _local_1:Sprite = new Sprite();
         var _local_2:MovieClip = ShotBehaviorManager.getMovieClip("pk_mouseIcon_shot");
         this.bmp = DisplayUtil.copyDisplayAsBmp(_local_2);
         _local_1.graphics.beginFill(0,0);
         _local_1.graphics.drawRect(this.bmp.x,this.bmp.y,this.bmp.width,this.bmp.height);
         _local_1.addChild(this.bmp);
         return _local_1;
      }
      
      override public function move(_arg_1:Point) : void
      {
         var _local_2:Point = MainManager.actorModel.localToGlobal(new Point());
         if(Point.distance(_local_2,_arg_1) > shotDis)
         {
            outOfDistance = true;
            this.bmp.visible = false;
            mouseIcon.addChild(forbidIcon);
         }
         else
         {
            outOfDistance = false;
            this.bmp.visible = true;
            DisplayUtil.removeForParent(forbidIcon);
         }
      }
      
      override public function click() : void
      {
         AimatController.setClothType(MainManager.actorInfo.clothIDs);
         MainManager.actorModel.aimatAction(0,AimatController.type,new Point(LevelManager.mapLevel.mouseX,LevelManager.mapLevel.mouseY));
      }
      
      override public function show() : void
      {
         super.show();
         var _local_1:uint = uint(ShotDisXMLInfo.getClothDistance(MainManager.actorInfo.clothIDs));
         MainManager.actorModel.showShotRadius(_local_1);
      }
   }
}

