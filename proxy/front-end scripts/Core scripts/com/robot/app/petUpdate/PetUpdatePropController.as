package com.robot.app.petUpdate
{
   import com.robot.app.experienceShared.ExperienceSharedModel;
   import com.robot.app.petUpdate.updatePanel.UpdatePropManager;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.PetUpdatePropInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   
   public class PetUpdatePropController
   {
      
      public static var owner:PetUpdatePropController;
      
      public static var addPer:uint;
      
      public static var addition:Number;
      
      private var panel:MovieClip;
      
      private var expMC:MovieClip;
      
      private var expTxt:TextField;
      
      private var txtArray:Array = [];
      
      private var arrowArray:Array = [];
      
      private var iconMC:Sprite;
      
      private var infoArray:Array = [];
      
      private var btn:SimpleButton;
      
      private var bmp:Bitmap;
      
      public function PetUpdatePropController()
      {
         super();
         owner = this;
         EventManager.addEventListener(PetFightEvent.PET_UPDATE_PROP,this.onFightClose);
      }
      
      public function setup(_arg_1:PetUpdatePropInfo) : void
      {
         var _local_2:UpdatePropInfo = null;
         var _local_3:uint = 0;
         addition = _arg_1.addition;
         addPer = _arg_1.addPer;
         this.infoArray = _arg_1.dataArray.slice();
         for each(_local_2 in this.infoArray)
         {
            _local_3 = uint(PetXMLInfo.getEvolvingLv(_local_2.id));
            if(PetXMLInfo.getTypeCN(_local_2.id) == "机械")
            {
               if(_local_2.level >= _local_3 && _local_3 != 0)
               {
                  Alarm.show("你的精灵已经达到了进化等级，现在可以在实验室的精灵进化仓里进行进化了。");
               }
            }
         }
         if(ExperienceSharedModel.isGetExp)
         {
            this.show();
         }
         ExperienceSharedModel.isGetExp = false;
      }
      
      private function onFightClose(_arg_1:PetFightEvent) : void
      {
         this.bmp = _arg_1.dataObj as Bitmap;
         if(this.infoArray.length == 0)
         {
            DisplayUtil.removeForParent(this.bmp);
            this.bmp = null;
            PetManager.upDate();
            return;
         }
         this.show();
      }
      
      public function show(_arg_1:Boolean = false, _arg_2:Boolean = true) : void
      {
         var _local_3:PetInfo = null;
         var _local_4:UpdatePropInfo = this.infoArray.shift() as UpdatePropInfo;
         if(_arg_2)
         {
            _local_3 = PetManager.getPetInfo(_local_4.catchTime);
         }
         else
         {
            _local_3 = PetManager.curEndPetInfo;
         }
         UpdatePropManager.update(_local_4,_local_3,this.closeHandler,_arg_1);
      }
      
      private function closeHandler() : void
      {
         if(this.infoArray.length > 0)
         {
            this.show();
         }
         else
         {
            this.infoArray = [];
            if(PetUpdateSkillController.infoArray.length > 0)
            {
               EventManager.dispatchEvent(new PetFightEvent(PetFightEvent.PET_UPDATE_SKILL,this.bmp));
            }
            else
            {
               if(Boolean(this.bmp))
               {
               }
               DisplayUtil.removeForParent(this.bmp);
            }
            PetManager.upDate();
            this.bmp = null;
         }
      }
   }
}

