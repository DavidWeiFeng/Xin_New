package com.robot.app.petUpdate.updatePanel
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class UpdateNomalPanel extends Sprite
   {
      
      protected var panel:MovieClip;
      
      protected var btn:SimpleButton;
      
      protected var evoPetMC:MovieClip;
      
      protected var iconMC:Sprite;
      
      public function UpdateNomalPanel()
      {
         super();
         this.initUI();
      }
      
      protected function initUI() : void
      {
         this.panel = UIManager.getMovieClip("ui_PetUpdateNormalPanel");
         this.iconMC = new Sprite();
         this.iconMC.x = 170;
         this.iconMC.y = 120;
         this.iconMC.scaleY = 0.9;
         this.iconMC.scaleX = 0.9;
         this.panel.addChild(this.iconMC);
         addChild(this.panel);
         this.btn = this.panel["okBtn"];
         this.btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      protected function clickHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         DisplayUtil.removeAllChild(this.iconMC);
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this,true);
         this.panel = null;
         this.btn = null;
         this.iconMC = null;
      }
      
      public function setInfo(_arg_1:UpdatePropInfo, _arg_2:PetInfo) : void
      {
         this.panel["name_txt"].text = PetXMLInfo.getName(_arg_2.id);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(_arg_1.id),this.onLevelComplete,"pet");
         this.panel["exp_info_txt"].htmlText = "赛尔精灵获得经验：<font color=\'#ff0000\'>" + (_arg_1.exp - _arg_2.exp) + "</font>\r" + "离升级还需经验：<font color=\'#ff0000\'>" + (_arg_1.nextLvExp - _arg_1.exp) + "</font>";
      }
      
      protected function onLevelComplete(o:DisplayObject) : void
      {
         this.evoPetMC = o as MovieClip;
         if(Boolean(this.evoPetMC))
         {
            this.evoPetMC.gotoAndStop("rightdown");
            this.evoPetMC.addEventListener(Event.ENTER_FRAME,function():void
            {
               var _local_2:MovieClip = evoPetMC.getChildAt(0) as MovieClip;
               if(Boolean(_local_2))
               {
                  _local_2.gotoAndStop(1);
                  evoPetMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            this.evoPetMC.scaleX = 1.5;
            this.evoPetMC.scaleY = 1.5;
            this.iconMC.addChild(this.evoPetMC);
         }
      }
   }
}

