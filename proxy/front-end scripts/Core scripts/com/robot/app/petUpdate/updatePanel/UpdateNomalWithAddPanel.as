package com.robot.app.petUpdate.updatePanel
{
   import com.robot.app.petUpdate.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   
   public class UpdateNomalWithAddPanel extends UpdateNomalPanel
   {
      
      public function UpdateNomalWithAddPanel()
      {
         super();
      }
      
      override protected function initUI() : void
      {
         panel = UIManager.getMovieClip("ui_PetUpdateNormalWithAddPanel");
         iconMC = new Sprite();
         iconMC.x = 188;
         iconMC.y = 170;
         iconMC.scaleY = 0.9;
         iconMC.scaleX = 0.9;
         panel.addChild(iconMC);
         addChild(panel);
         btn = panel["okBtn"];
         btn.addEventListener(MouseEvent.CLICK,clickHandler);
      }
      
      override public function setInfo(_arg_1:UpdatePropInfo, _arg_2:PetInfo) : void
      {
         if(PetUpdatePropController.addPer == 10)
         {
            panel["txt"].text = "赛尔精灵获得经验：\rNoNo加成经验：\r离升级还需经验：\r";
            panel["nonoMC"].gotoAndStop(2);
         }
         else
         {
            panel["txt"].text = "赛尔精灵获得经验：\r超能NoNo加成经验：\r离升级还需经验：\r";
            panel["nonoMC"].gotoAndStop(1);
         }
         var _local_3:Number = PetUpdatePropController.addition;
         var _local_4:uint = uint(Math.floor((_arg_1.exp - _arg_2.exp) / (1 + _local_3)));
         panel["add_txt"].text = "EXP+" + PetUpdatePropController.addPer + "%";
         panel["seer_exp_txt"].text = _local_4.toString();
         panel["nono_exp_txt"].text = _arg_1.exp - _arg_2.exp - _local_4;
         panel["up_exp_txt"].text = _arg_1.nextLvExp - _arg_1.exp;
         panel["total_exp_txt"].text = _arg_1.exp - _arg_2.exp;
         panel["name_txt"].text = PetXMLInfo.getName(_arg_2.id);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(_arg_1.id),onLevelComplete,"pet");
      }
   }
}

