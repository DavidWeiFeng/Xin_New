package com.robot.app.action
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.skeleton.*;
   import com.robot.core.ui.alert.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ActorActionManager
   {
      
      private static var subMenu:MovieClip;
      
      private static var actionBtn:SimpleButton;
      
      private static var tranBtn:SimpleButton;
      
      private static var unTranBtn:SimpleButton;
      
      public static var isTransforming:Boolean = false;
      
      setup();
      
      public function ActorActionManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         EventManager.addEventListener(RobotEvent.TRANSFORM_START,onTranStart);
         EventManager.addEventListener(RobotEvent.TRANSFORM_OVER,onTranOver);
      }
      
      private static function onTranStart(_arg_1:RobotEvent) : void
      {
         isTransforming = true;
      }
      
      private static function onTranOver(_arg_1:RobotEvent) : void
      {
         isTransforming = false;
         if(Boolean(tranBtn))
         {
            tranBtn.visible = !MainManager.actorModel.isTransform;
            unTranBtn.visible = MainManager.actorModel.isTransform;
         }
      }
      
      public static function showMenu(_arg_1:DisplayObject) : void
      {
         var _local_2:Point = null;
         _local_2 = null;
         if(!subMenu)
         {
            subMenu = CoreAssetsManager.getMovieClip("lib_transform_menu");
            _local_2 = _arg_1.localToGlobal(new Point());
            subMenu.x = _local_2.x;
            subMenu.y = _local_2.y - subMenu.height - 5;
            actionBtn = subMenu["actionBtn"];
            tranBtn = subMenu["tranBtn"];
            unTranBtn = subMenu["unTranBtn"];
            ToolTipManager.add(actionBtn,"蹲下");
            ToolTipManager.add(tranBtn,"变形");
            ToolTipManager.add(unTranBtn,"恢复变形");
            actionBtn.addEventListener(MouseEvent.CLICK,actionHandler);
            tranBtn.addEventListener(MouseEvent.CLICK,tranHandler);
            unTranBtn.addEventListener(MouseEvent.CLICK,unTranHandler);
         }
         tranBtn.visible = !MainManager.actorModel.isTransform;
         unTranBtn.visible = MainManager.actorModel.isTransform;
         LevelManager.topLevel.addChild(subMenu);
         MainManager.getStage().addEventListener(MouseEvent.CLICK,onStageClick);
      }
      
      private static function onStageClick(_arg_1:MouseEvent) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,onStageClick);
         if(!subMenu.hitTestPoint(_arg_1.stageX,_arg_1.stageY))
         {
            DisplayUtil.removeForParent(subMenu);
         }
      }
      
      private static function actionHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         if(MainManager.actorInfo.actionType == 1)
         {
            Alarm.show("注意！不要采用危险操作，取消飞行模式才能进行赛尔变形。");
            return;
         }
         if(isTransforming)
         {
            return;
         }
         if(!MainManager.actorModel.isTransform)
         {
            MainManager.actorModel.peculiarAction(MainManager.actorModel.direction);
         }
      }
      
      private static function tranHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         if(MainManager.actorInfo.actionType == 1)
         {
            Alarm.show("注意！不要采用危险操作，取消飞行模式才能进行赛尔变形。");
            return;
         }
         if(isTransforming)
         {
            return;
         }
         var _local_2:uint = uint(SuitXMLInfo.getSuitID(MainManager.actorInfo.clothIDs));
         SocketConnection.send(CommandID.PEOPLE_TRANSFROM,_local_2);
      }
      
      private static function unTranHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         if(isTransforming)
         {
            return;
         }
         if(MainManager.actorModel.skeleton is TransformSkeleton)
         {
            (MainManager.actorModel.skeleton as TransformSkeleton).untransform();
         }
      }
   }
}

