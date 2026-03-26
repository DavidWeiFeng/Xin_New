package com.robot.app.petUpdate.updatePanel
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.ui.skillBtn.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class SingleSkillPanel extends Sprite
   {
      
      private var panel:MovieClip;
      
      private var iconMC:Sprite;
      
      private var skillBtn:BlackSkillBtn;
      
      private var okBtn:SimpleButton;
      
      public function SingleSkillPanel()
      {
         super();
         this.panel = UIManager.getMovieClip("ui_PetUpdateSkillPanel");
         this.iconMC = new Sprite();
         this.iconMC.x = 108;
         this.iconMC.y = 135;
         this.iconMC.scaleY = 1.5;
         this.iconMC.scaleX = 1.5;
         this.panel.addChild(this.iconMC);
         this.okBtn = this.panel["okBtn"];
         this.okBtn.addEventListener(MouseEvent.CLICK,this.okHandler);
         addChild(this.panel);
      }
      
      public function setInfo(_arg_1:uint, _arg_2:uint, _arg_3:Boolean = true) : void
      {
         var _local_4:uint = 0;
         DisplayUtil.removeAllChild(this.iconMC);
         if(_arg_3)
         {
            _local_4 = uint(PetManager.getPetInfo(_arg_1).id);
            this.panel["name_txt"].text = PetXMLInfo.getName(_local_4);
         }
         else
         {
            _local_4 = uint(PetManager.curEndPetInfo.id);
            this.panel["name_txt"].text = PetXMLInfo.getName(_local_4);
         }
         ResourceManager.getResource(ClientConfig.getPetSwfPath(_local_4),this.onShowComplete,"pet");
         this.skillBtn = new BlackSkillBtn(_arg_2);
         this.skillBtn.x = 175;
         this.skillBtn.y = 100;
         this.panel.addChild(this.skillBtn);
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
      
      private function okHandler(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

