package com.robot.app.games.waterGunGame
{
   import com.robot.app.buyItem.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.Event;
   import org.taomee.manager.*;
   
   public class WaterGunGame
   {
      
      private static var loader:MCLoader;
      
      private static var gamePanel:*;
      
      private static var curGame:*;
      
      private static var waterGameAward:WaterGameAward;
      
      private static var PATH:String = "resource/Games/waterGame/WaterGame.swf";
      
      public function WaterGunGame()
      {
         super();
      }
      
      public static function loadGame() : void
      {
         loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在加载水枪小游戏");
         loader.addEventListener(MCLoadEvent.SUCCESS,onLoad);
         loader.doLoad();
      }
      
      private static function onLoad(_arg_1:MCLoadEvent) : void
      {
         loader.removeEventListener(MCLoadEvent.SUCCESS,onLoad);
         LevelManager.topLevel.addChild(_arg_1.getContent());
         curGame = _arg_1.getContent();
         _arg_1.getContent().addEventListener("waterGunGameOver",onGameOver);
      }
      
      private static function onGameOver(_arg_1:Event) : void
      {
         gamePanel = _arg_1.target as Sprite;
         var _local_2:Object = gamePanel.obj;
         if(_local_2.flag == 0)
         {
            waterGameAward = new WaterGameAward();
            EventManager.addEventListener(WaterGameAward.GET_WATER_GUN_GAME_AWARD_OK,onGetItemsOk);
         }
         else if(_local_2.flag == 1)
         {
            NpcTipDialog.show("水枪里的水全部用完了，你没有找到射的最远的角度。等水重新注满再试一试吧！",onFail,NpcTipDialog.CICI,-60,onFail);
         }
         else if(_local_2.flag == 2)
         {
            remove();
         }
      }
      
      private static function onSucess() : void
      {
         remove();
         ItemAction.buyMultiItem(3,"喷水套装",100052,100053,100054);
      }
      
      private static function onGetItemsOk(_arg_1:Event) : void
      {
         EventManager.removeEventListener(WaterGameAward.GET_WATER_GUN_GAME_AWARD_OK,onGetItemsOk);
         waterGameAward.destroy();
         if(WaterGameAward.bExist)
         {
            NpcTipDialog.show("真棒！水枪和发射炮弹一样，在与地面成45度角时，可以打到最远的地方。勇敢赛尔真是很聪明！",remove,NpcTipDialog.CICI,-60,remove);
         }
         else
         {
            NpcTipDialog.show("真棒！水枪和发射炮弹一样，在与地面成45度角时，可以打到最远的地方。快点装备上喷水装去火山星深处营救遇险的海盗吧。",onSucess,NpcTipDialog.CICI,-60,onSucess);
         }
      }
      
      private static function onFail() : void
      {
         remove();
      }
      
      private static function remove() : void
      {
         LevelManager.topLevel.removeChild(curGame);
         curGame.destroy();
         destroy();
      }
      
      private static function destroy() : void
      {
         gamePanel = null;
         loader = null;
      }
   }
}

