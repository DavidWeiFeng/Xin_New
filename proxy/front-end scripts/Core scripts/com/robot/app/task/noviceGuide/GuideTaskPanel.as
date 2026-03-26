package com.robot.app.task.noviceGuide
{
   import com.robot.app.task.taskUtils.manage.*;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import org.taomee.utils.*;
   
   public class GuideTaskPanel extends Sprite
   {
      
      private var PATH:String = "resource/task/novice.swf";
      
      private var app:ApplicationDomain;
      
      private var mc:MovieClip;
      
      private var tip:MovieClip;
      
      private var tipShip:MovieClip;
      
      private var mapMc:MovieClip;
      
      private var doctor:SimpleButton;
      
      private var shiper:SimpleButton;
      
      private var qqNpc:SimpleButton;
      
      private var doctorMC:MovieClip;
      
      private var shiperMC:MovieClip;
      
      private var flyBookBtn:SimpleButton;
      
      private var newsBtn:SimpleButton;
      
      private var monBtn:SimpleButton;
      
      private var newsBookMC:MovieClip;
      
      private var monBookMC:MovieClip;
      
      private var flyBookMC:MovieClip;
      
      private var qqMC:MovieClip;
      
      private var tipTxtAry:Array = ["发明家茜茜在飞船的机械室等你","罗杰船长在飞船的船长室等你","派特博士在飞船的实验室等你","飞船手册：可以查看飞船上功能设施的作用","航行日志：可以查看飞船每周的新发现","精灵手册：可以查看精灵相关的信息","现在你可以回到机械室找我领取奖励"];
      
      public function GuideTaskPanel()
      {
         super();
      }
      
      public function show() : void
      {
         var closeBtn:SimpleButton = null;
         var dragMc:SimpleButton = null;
         this.mc = TaskUIManage.getMovieClip("noviceTaskPanel",4);
         this.tip = TaskUIManage.getMovieClip("tipPanel",4);
         DisplayUtil.align(this.mc,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.topLevel.addChild(this.mc);
         closeBtn = this.mc["exitBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         dragMc = this.mc["dragMC"];
         dragMc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            mc.startDrag();
         });
         dragMc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            mc.stopDrag();
         });
         this.initPanel();
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         LevelManager.topLevel.removeChild(this.mc);
         LevelManager.openMouseEvent();
      }
      
      private function initPanel() : void
      {
         this.doctor = this.mc["btn3"];
         this.doctor.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this.doctor.addEventListener(MouseEvent.MOUSE_OUT,this.removeTip);
         this.shiper = this.mc["btn2"];
         this.shiper.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this.shiper.addEventListener(MouseEvent.MOUSE_OUT,this.removeTip);
         this.qqNpc = this.mc["btn1"];
         this.qqNpc.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this.qqNpc.addEventListener(MouseEvent.MOUSE_OUT,this.removeTip);
         this.flyBookBtn = this.mc["btn4"];
         this.flyBookBtn.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this.flyBookBtn.addEventListener(MouseEvent.MOUSE_OUT,this.removeTip);
         this.newsBtn = this.mc["btn5"];
         this.newsBtn.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this.newsBtn.addEventListener(MouseEvent.MOUSE_OUT,this.removeTip);
         this.monBtn = this.mc["btn6"];
         this.monBtn.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this.monBtn.addEventListener(MouseEvent.MOUSE_OUT,this.removeTip);
         this.doctorMC = this.mc["doctorMC"] as MovieClip;
         this.shiperMC = this.mc["shiperMC"];
         this.newsBookMC = this.mc["newsBookMC"] as MovieClip;
         this.newsBookMC.mouseChildren = false;
         this.newsBookMC.mouseEnabled = false;
         this.monBookMC = this.mc["monBookMC"] as MovieClip;
         this.monBookMC.mouseChildren = false;
         this.monBookMC.mouseEnabled = false;
         this.flyBookMC = this.mc["flyBookMC"] as MovieClip;
         this.qqMC = this.mc["qqMC"];
         this.qqMC.gotoAndStop(2);
         if(GuideTaskModel.bReadFlyBook)
         {
            this.flyBookBtn.mouseEnabled = false;
            this.flyBookMC.gotoAndStop(2);
         }
         if(GuideTaskModel.statusAry[0] == 1)
         {
            this.shiperMC.gotoAndStop(2);
            this.shiper.mouseEnabled = false;
            this.qqNpc.mouseEnabled = false;
         }
         if(GuideTaskModel.statusAry[2] == 1)
         {
            this.doctorMC.gotoAndStop(2);
            this.doctor.mouseEnabled = false;
            this.shiper.mouseEnabled = false;
            this.qqNpc.mouseEnabled = false;
         }
         if(TasksManager.taskList[0] == 3)
         {
            this.newsBookMC.gotoAndStop(2);
            this.newsBtn.mouseEnabled = false;
         }
         if(GuideTaskModel.bReadMonBook)
         {
            this.monBookMC.gotoAndStop(2);
            this.monBtn.mouseEnabled = false;
         }
         if(TasksManager.taskList[0] == 3 && GuideTaskModel.bReadMonBook && GuideTaskModel.bTaskDoctor)
         {
            this.createTip(this.tipTxtAry[6],1);
            this.flyBookBtn.mouseEnabled = false;
            this.newsBtn.mouseEnabled = false;
            this.monBtn.mouseEnabled = false;
         }
      }
      
      private function showTip(_arg_1:MouseEvent) : void
      {
         var _local_2:String = (_arg_1.target as SimpleButton).name;
         var _local_3:int = int(uint(_local_2.substr(3,1)));
         this.createTip(this.tipTxtAry[_local_3 - 1],_local_3);
      }
      
      private function createTip(_arg_1:String, _arg_2:int) : void
      {
         if(_arg_2 == 1 || _arg_2 == 4)
         {
            this.tip.x = 350;
            this.tip.y = 93.9;
         }
         else if(_arg_2 == 2 || _arg_2 == 5)
         {
            this.tip.x = 86;
            this.tip.y = 94;
         }
         else if(_arg_2 == 3 || _arg_2 == 6)
         {
            this.tip.x = 218;
            this.tip.y = 89;
         }
         var _local_3:TextField = this.tip["tipTxt"];
         _local_3.text = _arg_1;
         this.mc.addChild(this.tip);
      }
      
      private function removeTip(_arg_1:MouseEvent) : void
      {
         if(this.mc.contains(this.tip))
         {
            this.mc.removeChild(this.tip);
         }
      }
   }
}

