package com.robot.app.mapProcess
{
   import com.robot.app.task.SeerInstructor.*;
   import com.robot.core.animate.*;
   import com.robot.core.event.*;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.mode.PetModel;
   import com.robot.core.ui.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import gs.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MapProcess_11 extends BaseMapProcess
   {
      
      private var balkMC:MovieClip;
      
      private var clickMC:MovieClip;
      
      private var catchTimer:Timer;
      
      private var isCacthing:Boolean = false;
      
      private var isFlower:Boolean = false;
      
      private var _plantMc:MovieClip;
      
      public function MapProcess_11()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _local_1:DialogBox = null;
         UserManager.addActionListener(MainManager.actorID,this.onAction);
         this.balkMC = typeLevel["balkMC"];
         this.clickMC = conLevel["clickMC"];
         this.clickMC.addEventListener(MouseEvent.CLICK,this.showTip);
         if(Boolean(MainManager.actorModel.nono))
         {
            if(MainManager.actorInfo.superNono)
            {
               DisplayUtil.removeForParent(this.balkMC);
               DisplayUtil.removeForParent(this.clickMC);
               MapManager.currentMap.makeMapArray();
            }
         }
         var _local_2:Array = MainManager.actorInfo.clothIDs;
         if(_local_2.indexOf(100011) != -1)
         {
            DisplayUtil.removeForParent(this.balkMC);
            DisplayUtil.removeForParent(this.clickMC);
            MapManager.currentMap.makeMapArray();
         }
         NewInstructorContoller.chekWaste();
         this.catchTimer = new Timer(5 * 1000,1);
         this.catchTimer.addEventListener(TimerEvent.TIMER,this.onCatchTimer);
         if(TasksManager.getTaskStatus(403) == TasksManager.COMPLETE)
         {
            this.isFlower = true;
            conLevel["flowerMC"].gotoAndStop("live");
         }
         else
         {
            _local_1 = new DialogBox();
            _local_1.show("好想要新鲜空气和阳光啊",0,-20,conLevel["flowerMC"]);
         }
      }
      
      override public function destroy() : void
      {
         var _local_1:ActorModel = MainManager.actorModel;
         _local_1.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         this.clickMC.removeEventListener(MouseEvent.CLICK,this.showTip);
         UserManager.removeActionListener(MainManager.actorID,this.onAction);
         this.balkMC = null;
         this.catchTimer.stop();
         this.catchTimer.removeEventListener(TimerEvent.TIMER,this.onCatchTimer);
         this.catchTimer = null;
      }
      
      private function onAction(_arg_1:PeopleActionEvent) : void
      {
         var _local_2:Array = null;
         var _local_3:Array = null;
         var _local_4:PeopleItemInfo = null;
         switch(_arg_1.actionType)
         {
            case PeopleActionEvent.CLOTH_CHANGE:
               _local_2 = _arg_1.data as Array;
               _local_3 = [];
               for each(_local_4 in _local_2)
               {
                  _local_3.push(_local_4.id);
               }
               if(_local_3.indexOf(100011) != -1)
               {
                  DisplayUtil.removeForParent(this.balkMC);
                  DisplayUtil.removeForParent(this.clickMC);
                  MapManager.currentMap.makeMapArray();
                  break;
               }
               typeLevel.addChild(this.balkMC);
               conLevel.addChild(this.clickMC);
               if(this.clickMC.hitTestPoint(MainManager.actorModel.pos.x,MainManager.actorModel.pos.y,true))
               {
                  MainManager.actorModel.walkAction(new Point(608,245));
               }
               MapManager.currentMap.makeMapArray();
         }
      }
      
      public function onPlantClickHandler(param1:MouseEvent) : void
      {
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.walkAction(new Point(450,230));
      }
      
      private function onWalk(_arg_1:Event) : void
      {
         if(Math.abs(Point.distance(new Point(450,230),MainManager.actorModel.pos)) < 30)
         {
            this.onMapDown(null);
            MainManager.actorModel.stop();
            MapManager.changeMap(13);
         }
      }
      
      private function onMapDown(_arg_1:MapEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
      }
      
      private function showTip(_arg_1:MouseEvent) : void
      {
         Alarm.show("你必须穿上" + TextFormatUtil.getRedTxt("履带") + "才能进入沼泽哦！\n" + "(你可以在" + TextFormatUtil.getRedTxt("机械室") + "的" + TextFormatUtil.getRedTxt("赛尔工厂") + "中购买到)");
      }
      
      public function clearWaste() : void
      {
         NewInstructorContoller.setWaste();
      }
      
      public function hitFlower() : void
      {
         var _local_1:String = null;
         var _local_2:uint = 0;
         if(this.isCacthing || this.isFlower)
         {
            return;
         }
         if(TasksManager.getTaskStatus(403) == TasksManager.UN_ACCEPT)
         {
            _local_1 = "你还没有领取" + TextFormatUtil.getRedTxt("小医生布布") + "任务呢，" + "快点击右上角的" + TextFormatUtil.getRedTxt("精灵训练营") + "按钮看看吧！";
            Alarm.show(_local_1);
            return;
         }
         var _local_3:ActorModel = MainManager.actorModel;
         var _local_4:PetModel = _local_3.pet;
         if(Boolean(_local_4))
         {
            _local_2 = uint(_local_4.info.petID);
            if(this.check(_local_2))
            {
               _local_3.addEventListener(RobotEvent.WALK_START,this.onWalkStart);
               this.catchTimer.stop();
               this.catchTimer.reset();
               this.catchTimer.start();
               this.isCacthing = true;
               if(_local_2 == 1 || _local_2 == 301)
               {
                  conLevel["effectMC"].gotoAndStop("one");
                  topLevel["movie"].gotoAndStop("one");
               }
               else if(_local_2 == 2 || _local_2 == 302)
               {
                  conLevel["effectMC"].gotoAndStop("two");
                  topLevel["movie"].gotoAndStop("two");
               }
               else if(_local_2 == 3 || _local_2 == 303)
               {
                  conLevel["effectMC"].gotoAndStop("three");
                  topLevel["movie"].gotoAndStop("three");
               }
               TweenLite.to(topLevel["movie"],1,{
                  "x":(MainManager.getStageWidth() - topLevel["movie"].width) / 2,
                  "onComplete":this.onComp
               });
               PetManager.showCurrent();
            }
            else
            {
               Alarm.show("你必须带上<font color=\'#ff0000\'>布布种子、布布草、布布花、黄金布布、蒙娜布布、丽莎布布</font>的其中一个才能给克洛斯花补充活力哦！");
               conLevel["effectMC"].gotoAndStop(1);
            }
         }
         else
         {
            Alarm.show("你必须带上<font color=\'#ff0000\'>布布种子、布布草、布布花、黄金布布、蒙娜布布、丽莎布布</font>的其中一个才能给克洛斯花补充活力哦！");
            conLevel["effectMC"].gotoAndStop(1);
         }
      }
      
      private function check(_arg_1:uint) : Boolean
      {
         var _local_3:Boolean = false;
         var _local_4:int = 0;
         var _local_2:Array = [1,2,3,301,302,303];
         while(_local_4 < _local_2.length)
         {
            if(_local_2[_local_4] == _arg_1)
            {
               return true;
            }
            _local_4++;
         }
         return _local_3;
      }
      
      private function onComp() : void
      {
         setTimeout(this.closeFlower,2000);
      }
      
      private function closeFlower() : void
      {
         try
         {
            topLevel["movie"].x = 1075;
         }
         catch(e:Error)
         {
         }
      }
      
      private function onCatchTimer(_arg_1:TimerEvent) : void
      {
         this.isCacthing = false;
         TasksManager.complete(403,0,this.onSuccess);
      }
      
      private function onSuccess(_arg_1:Boolean) : void
      {
         this.isFlower = _arg_1;
         if(this.isFlower)
         {
            conLevel["flowerMC"].gotoAndStop("live");
            conLevel["effectMC"].gotoAndStop(1);
            PetManager.showCurrent();
         }
         else
         {
            Alarm.show("这次补充活力似乎没有起到效果，再试试吧！");
         }
      }
      
      private function onWalkStart(_arg_1:RobotEvent) : void
      {
         if(this.isCacthing)
         {
            Alarm.show("随便走动是无法为克洛斯花补充能量的哦！");
            this.isCacthing = false;
            this.catchTimer.stop();
            conLevel["effectMC"].gotoAndStop(1);
            PetManager.showCurrent();
         }
      }
   }
}

