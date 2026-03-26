package com.robot.app.mapProcess.active.randomPet
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.mapProcess.active.SpecialPetActive;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.mode.BobyModel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class PretendPet extends BobyModel implements IRandomPet
   {
      
      private var _petMc:MovieClip;
      
      private var pretendMC:MovieClip;
      
      private var id:uint;
      
      private var timer:Timer;
      
      public function PretendPet()
      {
         super();
         this.timer = new Timer(10 * 1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onTimer(_arg_1:TimerEvent) : void
      {
         showBox(SpecialPetActive.getStr(this.id));
      }
      
      public function show(_arg_1:uint) : void
      {
         this.id = _arg_1;
         this.pretendMC = SpecialPetActive.getMC(_arg_1);
         this.pretendMC.gotoAndStop(1);
         this.addChild(this.pretendMC);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(_arg_1),this.onLoadPet,"pet");
      }
      
      private function onLoadPet(_arg_1:DisplayObject) : void
      {
         this._petMc = _arg_1 as MovieClip;
         this._petMc.buttonMode = true;
         this._petMc.addEventListener(MouseEvent.CLICK,this.onClick);
         (this._petMc.getChildAt(0) as MovieClip).gotoAndStop(1);
         this.pretendMC.addEventListener(MouseEvent.CLICK,this.onClickPretend);
         this.pretendMC.addEventListener(MouseEvent.ROLL_OVER,this.onOverPretend);
         this.pretendMC.addEventListener(MouseEvent.ROLL_OUT,this.onOutPretend);
      }
      
      private function onClickPretend(event:MouseEvent) : void
      {
         this.pretendMC.removeEventListener(MouseEvent.ROLL_OUT,this.onOutPretend);
         this.pretendMC.mouseEnabled = false;
         this.pretendMC.mouseChildren = false;
         this.pretendMC.gotoAndStop(3);
         setTimeout(function():void
         {
            DisplayUtil.removeForParent(pretendMC);
            sprite.addChildAt(_petMc,0);
            timer.start();
            onTimer(null);
         },400);
      }
      
      private function onClick(_arg_1:MouseEvent) : void
      {
         FightInviteManager.fightWithSpecial();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.pretendMC.removeEventListener(MouseEvent.CLICK,this.onClickPretend);
         this.pretendMC.removeEventListener(MouseEvent.ROLL_OVER,this.onOverPretend);
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         this._petMc.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._petMc = null;
         this.pretendMC = null;
      }
      
      private function onOverPretend(_arg_1:MouseEvent) : void
      {
         this.pretendMC.gotoAndStop(2);
      }
      
      private function onOutPretend(_arg_1:MouseEvent) : void
      {
         this.pretendMC.gotoAndStop(1);
      }
   }
}

