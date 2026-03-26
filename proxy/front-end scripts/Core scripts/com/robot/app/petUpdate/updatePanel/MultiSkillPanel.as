package com.robot.app.petUpdate.updatePanel
{
   import com.robot.app.petUpdate.panel.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.ui.skillBtn.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.effect.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class MultiSkillPanel extends Sprite
   {
      
      private var panel:MovieClip;
      
      private var replaceBtn:SimpleButton;
      
      private var closeBtn:SimpleButton;
      
      private var skillBtns:Array;
      
      private var study:uint;
      
      private var drop:uint = 0;
      
      private var newSkillMC:BlackSkillBtn;
      
      private var _catchTime:uint;
      
      private var iconMC:Sprite;
      
      public function MultiSkillPanel()
      {
         super();
         this.panel = UIManager.getMovieClip("ui_PetUpdateMoreSkillPanel");
         addChild(this.panel);
         this.replaceBtn = this.panel["okBtn"];
         this.closeBtn = this.panel["closeBtn"];
         this.replaceBtn.addEventListener(MouseEvent.CLICK,this.replaceHandler);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         SocketConnection.addCmdListener(CommandID.PET_STUDY_SKILL,this.onStudy);
         this.iconMC = new Sprite();
         this.iconMC.x = 104;
         this.iconMC.y = 150;
         this.panel.addChild(this.iconMC);
      }
      
      public function setInfo(catchTime:uint, skillID:uint, isBag:Boolean = true) : void
      {
         var petSkills:Array = null;
         var petID:uint = 0;
         petSkills = null;
         petID = 0;
         DisplayUtil.removeAllChild(this.iconMC);
         this._catchTime = catchTime;
         this.replaceBtn.mouseEnabled = false;
         this.replaceBtn.filters = [ColorFilter.setGrayscale()];
         DisplayUtil.removeForParent(this.newSkillMC);
         this.newSkillMC = new BlackSkillBtn(skillID);
         this.newSkillMC.x = 176;
         this.newSkillMC.y = 99;
         this.panel.addChild(this.newSkillMC);
         this.study = skillID;
         this.skillBtns = [];
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(_arg_1:SocketEvent):void
         {
            var _local_4:BlackSkillBtn = null;
            var _local_5:SkillBtnController = null;
            var _local_3:PetSkillInfo = null;
            var _local_7:uint = 0;
            _local_4 = null;
            _local_5 = null;
            SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
            var _local_6:PetInfo = _arg_1.data as PetInfo;
            petSkills = _local_6.skillArray;
            for each(_local_3 in petSkills)
            {
               _local_4 = new BlackSkillBtn(_local_3.id,_local_3.pp);
               _local_5 = new SkillBtnController(_local_4,_local_3);
               _local_4.x = 39 + _local_7 % 2 * (_local_4.width + 8);
               _local_4.y = 190 + Math.floor(_local_7 / 2) * (_local_4.height + 3);
               _local_5.addEventListener(SkillBtnController.CLICK,onClickSkillBtn);
               skillBtns.push(_local_5);
               panel.addChild(_local_4);
               _local_7++;
            }
            ResourceManager.getResource(ClientConfig.getPetSwfPath(petID),onShowComplete,"pet");
         });
         SocketConnection.send(CommandID.GET_PET_INFO,this._catchTime);
      }
      
      private function onClickSkillBtn(_arg_1:Event) : void
      {
         var _local_2:SkillBtnController = null;
         var _local_3:SkillBtnController = _arg_1.currentTarget as SkillBtnController;
         this.drop = _local_3.skillID;
         for each(_local_2 in this.skillBtns)
         {
            _local_2.checkIsOwner(_local_3);
         }
         this.replaceBtn.mouseEnabled = true;
         this.replaceBtn.filters = [];
      }
      
      private function replaceHandler(event:MouseEvent) : void
      {
         var okBtn:SimpleButton = null;
         var closeBtn:SimpleButton = null;
         var alarm:MovieClip = null;
         alarm = null;
         alarm = UIManager.getMovieClip("ui_MultiSkillAlarm");
         var newMC:BlackSkillBtn = new BlackSkillBtn(this.study);
         var oldMC:BlackSkillBtn = new BlackSkillBtn(this.drop);
         newMC.x = 39;
         oldMC.x = 195;
         oldMC.y = 102;
         newMC.y = 102;
         alarm.addChild(newMC);
         alarm.addChild(oldMC);
         DisplayUtil.align(alarm,null,AlignType.MIDDLE_CENTER);
         okBtn = alarm["okBtn"];
         closeBtn = alarm["closeBtn"];
         okBtn.addEventListener(MouseEvent.CLICK,function():void
         {
            DisplayUtil.removeForParent(alarm);
            SocketConnection.send(CommandID.PET_STUDY_SKILL,_catchTime,1,1,drop,study);
         });
         closeBtn.addEventListener(MouseEvent.CLICK,function():void
         {
            DisplayUtil.removeForParent(alarm);
         });
         MainManager.getStage().addChild(alarm);
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function onStudy(event:SocketEvent) : void
      {
         var sprite:Sprite = null;
         PetManager.upDate();
         sprite = Alarm.show("恭喜你，宠物学习技能成功！",function():void
         {
            dispatchEvent(new Event(Event.CLOSE));
         });
         MainManager.getStage().addChild(sprite);
      }
      
      private function onShowComplete(o:DisplayObject) : void
      {
         var _showMc:MovieClip = null;
         _showMc = null;
         _showMc = o as MovieClip;
         if(Boolean(_showMc))
         {
            _showMc.gotoAndStop("rightdown");
            _showMc.addEventListener(Event.ENTER_FRAME,function():void
            {
               var _local_2:MovieClip = _showMc.getChildAt(0) as MovieClip;
               if(Boolean(_local_2))
               {
                  _local_2.gotoAndStop(1);
                  _showMc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            this.iconMC.addChild(_showMc);
         }
      }
   }
}

