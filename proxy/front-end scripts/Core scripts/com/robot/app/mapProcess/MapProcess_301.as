package com.robot.app.mapProcess
{
   import com.robot.app.sceneInteraction.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class MapProcess_301 extends BaseMapProcess
   {
      
      private var _prizeMc:MovieClip;
      
      private var _prizeBtn:MovieClip;
      
      private var _myPosIndex:int;
      
      private var _youPosIndex:int;
      
      private var _eve_0:MovieClip;
      
      private var _eve_1:MovieClip;
      
      public function MapProcess_301()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._prizeMc = conLevel["prizeMc"];
         this._prizeBtn = conLevel["prizeBtn"];
         conLevel["shitouMc"].mouseEnabled = false;
         conLevel["shitouMc"].mouseChildren = false;
         this._prizeMc.mouseEnabled = false;
         this._prizeBtn.mouseEnabled = false;
         this._eve_0 = conLevel["eve_0"];
         this._eve_1 = conLevel["eve_1"];
         this._eve_0.mouseChildren = false;
         this._eve_1.mouseChildren = false;
         this._eve_0.mouseEnabled = false;
         this._eve_1.mouseEnabled = false;
         if(TasksManager.getTaskStatus(21) == TasksManager.COMPLETE)
         {
            TeachersDayController.isPosComplete = true;
            this.showLu();
            this.allowPrize();
         }
         else
         {
            if(TeachersDayController.isPosComplete)
            {
               this.showLu();
            }
            else
            {
               TeachersDayController.setup();
            }
            SocketConnection.addCmdListener(CommandID.ML_FIG_BOSS,this.onFigBoss);
            MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
         }
         SocketConnection.addCmdListener(CommandID.ML_STEP_POS,this.onStepPos);
         MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.ML_FIG_BOSS,this.onFigBoss);
         SocketConnection.removeCmdListener(CommandID.ML_STEP_POS,this.onStepPos);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         this._prizeMc = null;
         this._prizeBtn = null;
         this._eve_0 = null;
         this._eve_1 = null;
      }
      
      private function showLu() : void
      {
         this._eve_0.gotoAndPlay(2);
         this._eve_1.gotoAndPlay(2);
         DisplayUtil.removeForParent(btnLevel["posMaskMc"]);
      }
      
      private function allowPrize() : void
      {
         this._prizeBtn.mouseEnabled = true;
         this._prizeMc.gotoAndPlay(2);
      }
      
      private function hasTS() : Boolean
      {
         if(UserManager.contains(MainManager.actorInfo.teacherID))
         {
            return true;
         }
         if(UserManager.contains(MainManager.actorInfo.studentID))
         {
            return true;
         }
         return false;
      }
      
      private function moveUser(_arg_1:uint, _arg_2:Point) : void
      {
         var _local_3:BasePeoleModel = null;
         if(_arg_1 == 0)
         {
            return;
         }
         if(_arg_1 == MainManager.actorID)
         {
            MainManager.actorModel.stop();
            MainManager.actorModel.pos = _arg_2;
         }
         else
         {
            _local_3 = UserManager.getUserModel(_arg_1);
            if(Boolean(_local_3))
            {
               _local_3.stop();
               _local_3.pos = _arg_2;
            }
         }
      }
      
      private function onStepPos(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         var _local_5:Point = new Point(_local_2.readUnsignedInt(),_local_2.readUnsignedInt());
         var _local_6:uint = _local_2.readUnsignedInt();
         var _local_7:uint = _local_2.readUnsignedInt();
         var _local_8:Point = new Point(_local_2.readUnsignedInt(),_local_2.readUnsignedInt());
         this.moveUser(_local_3,_local_5);
         if(_local_3 != 0)
         {
            if(_local_3 == MainManager.actorID)
            {
               this._myPosIndex = _local_4;
            }
            else
            {
               this._youPosIndex = _local_4;
            }
         }
         if(_local_6 != 0)
         {
            if(_local_6 == MainManager.actorID)
            {
               this._myPosIndex = _local_7;
            }
            else
            {
               this._youPosIndex = _local_7;
            }
         }
         if(!TeachersDayController.isPosComplete)
         {
            if(this._myPosIndex != 0 && this._youPosIndex != 0)
            {
               TeachersDayController.isPosComplete = true;
               this.showLu();
            }
         }
      }
      
      private function onMapDown(_arg_1:MapEvent) : void
      {
         if(!TeachersDayController.isPosComplete)
         {
            if(this._myPosIndex != 0)
            {
               SocketConnection.send(CommandID.ML_STEP_POS,0,0);
            }
         }
         this._myPosIndex = 0;
      }
      
      private function onWalkEnter(e:RobotEvent) : void
      {
         var pos:Point = null;
         var i:int = 0;
         var mc:MovieClip = null;
         if(this.hasTS())
         {
            return;
         }
         pos = MainManager.actorModel.pos;
         i = 0;
         while(i < 4)
         {
            mc = conLevel.getChildByName("fire_" + i.toString()) as MovieClip;
            if(Boolean(mc))
            {
               if(mc.hitTestPoint(pos.x,pos.y))
               {
                  MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
                  MainManager.actorModel.stop();
                  Alarm.show("前方很危险！只有和你的教官或者学员在一起才可以突破试炼场中的火墙噢！",function():void
                  {
                     MapManager.changeMap(101);
                  });
                  return;
               }
            }
            i += 1;
         }
      }
      
      private function onFigBoss(_arg_1:SocketEvent) : void
      {
         TeachersDayController.starFig();
      }
      
      public function onPosFun1() : void
      {
         if(this.hasTS())
         {
            if(this._myPosIndex == 1)
            {
               return;
            }
            SocketConnection.send(CommandID.ML_STEP_POS,1,1);
         }
         else if(!TeachersDayController.isPosComplete)
         {
            SocketConnection.send(CommandID.ML_STEP_POS,0,0);
         }
      }
      
      public function onPosFun2() : void
      {
         if(this.hasTS())
         {
            if(this._myPosIndex == 2)
            {
               return;
            }
            SocketConnection.send(CommandID.ML_STEP_POS,1,2);
         }
         else if(!TeachersDayController.isPosComplete)
         {
            SocketConnection.send(CommandID.ML_STEP_POS,0,0);
         }
      }
      
      public function onSFigFun() : void
      {
         if(MainManager.actorInfo.teacherID == 0)
         {
            if(MainManager.actorInfo.studentID != 0)
            {
               Alarm.show("这里是" + TextFormatUtil.getRedTxt("学员") + "参加试炼的位置哦，快去旁边看看吧！");
               return;
            }
         }
         else
         {
            SocketConnection.send(CommandID.ML_FIG_BOSS,0);
         }
      }
      
      public function onTFigFun() : void
      {
         if(MainManager.actorInfo.studentID == 0)
         {
            if(MainManager.actorInfo.teacherID != 0)
            {
               Alarm.show("这里是" + TextFormatUtil.getRedTxt("教官") + "参加试炼的位置哦，快去旁边看看吧！");
               return;
            }
         }
         else
         {
            SocketConnection.send(CommandID.ML_FIG_BOSS,1);
         }
      }
      
      public function onPrizeFun() : void
      {
         SocketConnection.addCmdListener(CommandID.ML_GET_PRIZE,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.ML_GET_PRIZE,arguments.callee);
            var _local_3:ByteArray = _arg_1.data as ByteArray;
            var _local_4:uint = _local_3.readUnsignedInt();
            var _local_5:uint = _local_3.readUnsignedInt();
            var _local_6:uint = _local_3.readUnsignedInt();
            Alarm.show("恭喜你通过了雷蒙教官火之试炼的考验！" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(_local_5)) + "是给你们的最高荣耀，快点击储存箱看看吧。");
         });
         SocketConnection.send(CommandID.ML_GET_PRIZE);
      }
   }
}

