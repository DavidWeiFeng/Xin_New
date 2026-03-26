package com.robot.app.weekMonster
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.*;
   
   public class WeekMonsterMain
   {
      
      private static var _loader:MCLoader;
      
      private static var mainPanel:MovieClip;
      
      private static var closeBtn:SimpleButton;
      
      private static var app:ApplicationDomain;
      
      private static var starBtn:SimpleButton;
      
      private static var PATH:String = "resource/module/newMonster/weekMonster.swf";
      
      public function WeekMonsterMain()
      {
         super();
      }
      
      public static function loadMonster() : void
      {
         if(!mainPanel)
         {
            _loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在加载本周新精灵");
            _loader.addEventListener(MCLoadEvent.SUCCESS,onComplete);
            _loader.doLoad();
         }
         else
         {
            DisplayUtil.align(mainPanel,null,AlignType.MIDDLE_CENTER);
            LevelManager.closeMouseEvent();
            LevelManager.appLevel.addChild(mainPanel);
            closeBtn = mainPanel["exitBtn"];
            closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
         }
      }
      
      private static function onComplete(_arg_1:MCLoadEvent) : void
      {
         app = _arg_1.getApplicationDomain();
         _loader.removeEventListener(MCLoadEvent.SUCCESS,onComplete);
         mainPanel = new (app.getDefinition("mainPanel") as Class)() as MovieClip;
         DisplayUtil.align(mainPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mainPanel);
         closeBtn = mainPanel["exitBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function changeMap(_arg_1:MouseEvent) : void
      {
         closeHandler(null);
         if(mainPanel.currentFrame == 1)
         {
            MapManager.changeMap(106);
         }
      }
      
      private static function changeMap2(_arg_1:MouseEvent) : void
      {
         closeHandler(null);
         MapManager.changeMap(41);
      }
      
      private static function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mainPanel,false);
         LevelManager.openMouseEvent();
         closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
         closeBtn = null;
      }
   }
}

