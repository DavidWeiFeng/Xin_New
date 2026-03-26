package com.robot.app.fightNote
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.fightInfo.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class FightWaitPanel
   {
      
      private static var panel:MovieClip;
      
      private static var closeBtn:SimpleButton;
      
      private static var selectPanel:MovieClip;
      
      private static var userInfo:UserInfo;
      
      private static var seletctCloseBtn:SimpleButton;
      
      private static var singleBtn:SimpleButton;
      
      private static var multiBtn:SimpleButton;
      
      private static var isInvite:Boolean = false;
      
      initHandler();
      
      public function FightWaitPanel()
      {
         super();
      }
      
      private static function initHandler() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitch);
         EventManager.addEventListener(RobotEvent.CLOSE_FIGHT_WAIT,closeWait);
      }
      
      private static function closeWait(_arg_1:RobotEvent) : void
      {
         hide();
      }
      
      private static function onMapSwitch(_arg_1:MapEvent) : void
      {
         if(isInvite)
         {
            SocketConnection.send(CommandID.INVITE_FIGHT_CANCEL);
            isInvite = false;
         }
      }
      
      public static function selectMode(_info:UserInfo) : void
      {
         var dragBtn:SimpleButton = null;
         userInfo = _info;
         if(!selectPanel)
         {
            selectPanel = UIManager.getMovieClip("FightSelectMode_mc");
            DisplayUtil.align(selectPanel,null,AlignType.MIDDLE_CENTER);
            seletctCloseBtn = selectPanel["closeBtn"];
            singleBtn = selectPanel["singleBtn"];
            multiBtn = selectPanel["multiBtn"];
            dragBtn = selectPanel["dragBtn"];
            dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               selectPanel.startDrag();
            });
            dragBtn.addEventListener(MouseEvent.MOUSE_UP,function():void
            {
               selectPanel.stopDrag();
            });
            seletctCloseBtn.addEventListener(MouseEvent.CLICK,closeSelectHandler);
            singleBtn.addEventListener(MouseEvent.CLICK,selectModeHandler);
            multiBtn.addEventListener(MouseEvent.CLICK,selectModeHandler);
         }
         LevelManager.appLevel.addChild(selectPanel);
      }
      
      private static function show() : void
      {
         var dragBtn:SimpleButton = null;
         if(!panel)
         {
            panel = UIManager.getMovieClip("FightWait_mc");
            closeBtn = panel["closeBtn"];
            closeBtn.addEventListener(MouseEvent.CLICK,closePanel);
            dragBtn = panel["dragBtn"];
            dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               panel.startDrag();
            });
            dragBtn.addEventListener(MouseEvent.MOUSE_UP,function():void
            {
               panel.stopDrag();
            });
            MainManager.getStage().addEventListener(MouseEvent.MOUSE_UP,function():void
            {
               panel.stopDrag();
            });
         }
         DisplayUtil.align(panel,null,AlignType.MIDDLE_CENTER);
         panel["myNameTxt"].text = MainManager.actorInfo.nick;
         panel["otherNameTxt"].text = userInfo.nick;
         LevelManager.topLevel.addChild(panel);
         LevelManager.closeMouseEvent();
      }
      
      public static function hide() : void
      {
         if(Boolean(panel))
         {
            if(Boolean(panel.parent))
            {
               panel.parent.removeChild(panel);
            }
         }
         isInvite = false;
         LevelManager.openMouseEvent();
      }
      
      private static function closeSelectHandler(_arg_1:MouseEvent) : void
      {
         selectPanel.parent.removeChild(selectPanel);
      }
      
      private static function selectModeHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:SimpleButton = _arg_1.currentTarget as SimpleButton;
         PetFightModel.enemyName = userInfo.nick;
         if(_local_3 == singleBtn)
         {
            _local_2 = 1;
            PetFightModel.mode = PetFightModel.SINGLE_MODE;
         }
         else
         {
            _local_2 = 2;
            PetFightModel.mode = PetFightModel.MULTI_MODE;
         }
         PetFightModel.status = PetFightModel.FIGHT_WITH_PLAYER;
         SocketConnection.send(CommandID.INVITE_TO_FIGHT,userInfo.userID,_local_2);
         isInvite = true;
         closeSelectHandler(null);
         show();
      }
      
      private static function closePanel(_arg_1:MouseEvent) : void
      {
         SocketConnection.send(CommandID.INVITE_FIGHT_CANCEL);
         panel.parent.removeChild(panel);
         LevelManager.openMouseEvent();
      }
   }
}

