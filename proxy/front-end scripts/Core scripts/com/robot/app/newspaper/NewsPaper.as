package com.robot.app.newspaper
{
   import com.robot.app.picturebook.PictureBookController;
   import com.robot.app.task.books.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.PetBookXMLInfo;
   import com.robot.core.controller.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   
   public class NewsPaper extends BaseBeanController
   {
      
      public static var timeIcon:Sprite;
      
      private static var newsTipMC:MovieClip;
      
      public function NewsPaper()
      {
         super();
      }
      
      override public function start() : void
      {
         timeIcon = UIManager.getSprite("news_Icon");
         timeIcon.x = 24;
         timeIcon.y = 20;
         (timeIcon["ball"] as MovieClip).visible = false;
         (timeIcon["ball"] as MovieClip).stop();
         (timeIcon["ball"] as MovieClip).mouseEnabled = false;
         (timeIcon["ball"] as MovieClip).mouseChildren = false;
         var _local_1:SimpleButton = timeIcon["newsBtn"] as SimpleButton;
         _local_1.addEventListener(MouseEvent.CLICK,this.showNewsPanel);
         LevelManager.iconLevel.addChild(timeIcon);
         ToolTipManager.add(timeIcon,"精灵图鉴");
         newsTipMC = timeIcon["newsTipMC"];
         newsTipMC.mouseChildren = false;
         newsTipMC.mouseEnabled = false;
         newsTipMC.visible = false;
         newsTipMC.stop();
         var _local_2:Object = SaveUserInfo.getNewsVersion();
         if(_local_2 && _local_2.id == MainManager.actorInfo.userID && _local_2.version == ClientConfig.newsVersion)
         {
            newsTipMC.visible = false;
         }
         else
         {
            newsTipMC.visible = true;
            newsTipMC.play();
         }
         finish();
      }
      
      private function showNewsPanel(_arg_1:Event) : void
      {
         (timeIcon["ball"] as MovieClip).visible = false;
         newsTipMC.visible = false;
         newsTipMC.stop();
         SaveUserInfo.saveNewsSO();
         if(!PetBookXMLInfo.isSetup)
         {
            PetBookXMLInfo.setup(PictureBookController.show);
         }
         else
         {
            PictureBookController.show();
         }
      }
   }
}

