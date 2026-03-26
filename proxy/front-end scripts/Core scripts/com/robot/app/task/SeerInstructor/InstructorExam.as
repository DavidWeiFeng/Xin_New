package com.robot.app.task.SeerInstructor
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.Event;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class InstructorExam
   {
      
      private static var loader:MCLoader;
      
      private static var gamePanel:*;
      
      private static var curGame:Sprite;
      
      private static var PATH:String = "resource/Games/InstructorExam/Questions.swf";
      
      public function InstructorExam()
      {
         super();
      }
      
      public static function loadGame() : void
      {
         loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在加载教官考试题目");
         loader.addEventListener(MCLoadEvent.SUCCESS,onLoad);
         loader.doLoad();
      }
      
      private static function onLoad(_arg_1:MCLoadEvent) : void
      {
         loader.removeEventListener(MCLoadEvent.SUCCESS,onLoad);
         LevelManager.topLevel.addChild(_arg_1.getContent());
         DisplayUtil.align(_arg_1.getContent(),null,AlignType.MIDDLE_CENTER);
         curGame = _arg_1.getContent() as Sprite;
         _arg_1.getContent().addEventListener("instructorExamOver",onGameOver);
      }
      
      private static function onGameOver(_arg_1:Event) : void
      {
         gamePanel = _arg_1.target as Sprite;
         var _local_2:Object = gamePanel.obj;
         if(_local_2.flag == 0)
         {
            curGame.mouseChildren = false;
            curGame.mouseEnabled = false;
            Alarm.show("你成功通过了教官预考,点击右上角图标查看考核内容",okFun);
         }
         else if(_local_2.flag == 1)
         {
            curGame.mouseChildren = false;
            curGame.mouseEnabled = false;
            Alarm.show("你没有通过了教官预考,下次继续努力吧",failFun);
         }
         else if(_local_2.flag == 2)
         {
            LevelManager.topLevel.removeChild(curGame);
         }
      }
      
      private static function okFun() : void
      {
         TasksManager.accept(201,onAccept);
      }
      
      private static function onAccept(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            TasksManager.setTaskStatus(NewInstructorContoller.TASK_ID,TasksManager.ALR_ACCEPT);
            LevelManager.topLevel.removeChild(curGame);
            NewInstructorContoller.showIcon();
         }
      }
      
      private static function onChangeOK(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.CHANGE_TASK_STATUES,onChangeOK);
         TasksManager.taskList[200] = 2;
         LevelManager.topLevel.removeChild(curGame);
         SeerInstructorMain.start();
      }
      
      private static function failFun() : void
      {
         LevelManager.topLevel.removeChild(curGame);
      }
   }
}

