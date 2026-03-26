package com.robot.app.fightNote.petKing
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.net.*;
   import com.robot.core.pet.petWar.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PetKingWaitPanel
   {
      
      private static var selectPanel:MovieClip;
      
      private static var waitPanel:MovieClip;
      
      private static var singleBtn:SimpleButton;
      
      private static var multiBtn:SimpleButton;
      
      private static var _petWarPanel:Sprite;
      
      initHandler();
      
      public function PetKingWaitPanel()
      {
         super();
      }
      
      private static function initHandler() : void
      {
         EventManager.addEventListener(RobotEvent.CLOSE_FIGHT_WAIT,closeWait);
      }
      
      private static function closeWait(_arg_1:RobotEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitch);
         DisplayUtil.removeForParent(waitPanel,false);
         LevelManager.openMouseEvent();
      }
      
      private static function showWaitPanel() : void
      {
         var dragBtn:SimpleButton = null;
         var waitCloseBtn:SimpleButton = null;
         if(!waitPanel)
         {
            waitPanel = UIManager.getMovieClip("FightWait_mc");
            dragBtn = waitPanel["dragBtn"];
            dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               waitPanel.startDrag();
            });
            dragBtn.addEventListener(MouseEvent.MOUSE_UP,function():void
            {
               waitPanel.stopDrag();
            });
            waitCloseBtn = waitPanel["closeBtn"];
            waitCloseBtn.addEventListener(MouseEvent.CLICK,closeWaitPanel);
         }
      }
      
      public static function show() : void
      {
         var closeBtn:SimpleButton = null;
         var dragBtn2:SimpleButton = null;
         if(!waitPanel || !selectPanel)
         {
            showWaitPanel();
            selectPanel = MapLibManager.getMovieClip("ui_pet_king_panel");
            singleBtn = selectPanel["singleBtn"];
            multiBtn = selectPanel["multiBtn"];
            closeBtn = selectPanel["closeBtn"];
            closeBtn.addEventListener(MouseEvent.CLICK,closeSelect);
            singleBtn.addEventListener(MouseEvent.CLICK,selectModeHandler);
            multiBtn.addEventListener(MouseEvent.CLICK,selectModeHandler);
            dragBtn2 = selectPanel["dragBtn"];
            dragBtn2.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               selectPanel.startDrag();
            });
            dragBtn2.addEventListener(MouseEvent.MOUSE_UP,function():void
            {
               selectPanel.stopDrag();
            });
         }
         DisplayUtil.align(selectPanel,null,AlignType.MIDDLE_CENTER);
         DisplayUtil.align(waitPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(selectPanel);
      }
      
      public static function showPetWar() : void
      {
         if(!_petWarPanel)
         {
            _petWarPanel = MapLibManager.getMovieClip("ui_pet_metee_panel");
            _petWarPanel["startBtn"].addEventListener(MouseEvent.CLICK,onStartHandler);
            _petWarPanel["closeBtn"].addEventListener(MouseEvent.CLICK,function(_arg_1:MouseEvent):void
            {
               DisplayUtil.removeForParent(_petWarPanel);
               DragManager.remove(_petWarPanel["dragBtn"]);
            });
            DragManager.add(_petWarPanel["dragBtn"],_petWarPanel);
            LevelManager.appLevel.addChild(_petWarPanel);
            DisplayUtil.align(_petWarPanel,null,AlignType.MIDDLE_CENTER);
         }
         else
         {
            DragManager.add(_petWarPanel["dragBtn"],_petWarPanel);
            LevelManager.appLevel.addChild(_petWarPanel);
            DisplayUtil.align(_petWarPanel,null,AlignType.MIDDLE_CENTER);
         }
      }
      
      private static function onStartHandler(_arg_1:MouseEvent) : void
      {
         LevelManager.closeMouseEvent();
         showWait();
         PetWarController.start(close);
      }
      
      private static function closeSelect(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(selectPanel,false);
      }
      
      public static function close() : void
      {
         DisplayUtil.removeForParent(waitPanel,false);
      }
      
      public static function closeWaitPanel(_arg_1:MouseEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitch);
         DisplayUtil.removeForParent(waitPanel,false);
         SocketConnection.send(CommandID.INVITE_FIGHT_CANCEL);
         LevelManager.openMouseEvent();
         PetFightModel.mode = PetFightModel.FIGHT_WITH_NPC;
      }
      
      private static function onMapSwitch(_arg_1:MapEvent) : void
      {
         closeWaitPanel(null);
      }
      
      private static function selectModeHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:SimpleButton = _arg_1.currentTarget as SimpleButton;
         if(_local_3 == singleBtn)
         {
            _local_2 = 5;
            PetFightModel.mode = PetFightModel.SINGLE_MODE;
         }
         else
         {
            _local_2 = 6;
            PetFightModel.mode = PetFightModel.MULTI_MODE;
         }
         PetFightModel.status = PetFightModel.FIGHT_WITH_PLAYER;
         SocketConnection.send(CommandID.PET_KING_JOIN,_local_2,0);
         closeSelect(null);
         showWait();
      }
      
      private static function showWait() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitch);
         showWaitPanel();
         DisplayUtil.align(waitPanel,null,AlignType.MIDDLE_CENTER);
         waitPanel["myNameTxt"].text = MainManager.actorInfo.nick;
         waitPanel["otherNameTxt"].text = "";
         LevelManager.topLevel.addChild(waitPanel);
         LevelManager.closeMouseEvent();
      }
   }
}

