package com.robot.app.petUpdate.updatePanel
{
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import gs.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class UpdateLevelPanel extends Sprite
   {
      
      private var levelPanel:MovieClip;
      
      private var iconMC:Sprite;
      
      private var btn:SimpleButton;
      
      private var isEvolution:Boolean;
      
      private var oldPetMC:MovieClip;
      
      private var evoPetMC:MovieClip;
      
      private var arrowArray:Array = [];
      
      private var txtArray:Array = [];
      
      private var txtArray2:Array = [];
      
      private var effectMC:MovieClip;
      
      public function UpdateLevelPanel()
      {
         super();
         this.levelPanel = UIManager.getMovieClip("ui_PetUpdateLevelPanel");
         this.iconMC = new Sprite();
         this.iconMC.x = 95 + 10;
         this.iconMC.y = 185 + 30;
         this.iconMC.scaleY = 1.5;
         this.iconMC.scaleX = 1.5;
         this.levelPanel.addChild(this.iconMC);
         this.btn = this.levelPanel["okBtn"];
         this.btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
         addChild(this.levelPanel);
      }
      
      private function clickHandler(_arg_1:MouseEvent) : void
      {
         this.clearArrow();
         this.txtArray = [];
         this.txtArray2 = [];
         this.arrowArray = [];
         DisplayUtil.removeForParent(this);
         DisplayUtil.removeForParent(this.effectMC);
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this,true);
         this.btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this.levelPanel = null;
         this.iconMC = null;
         this.btn = null;
         this.oldPetMC = null;
         this.evoPetMC = null;
         this.effectMC = null;
      }
      
      public function setInfo(_arg_1:UpdatePropInfo, _arg_2:PetInfo) : void
      {
         this.clearArrow();
         this.txtArray.push(this.levelPanel["level_txt"],this.levelPanel["hp_txt"],this.levelPanel["a_txt"],this.levelPanel["d_txt"],this.levelPanel["sa_txt"],this.levelPanel["sd_txt"],this.levelPanel["sp_txt"]);
         this.txtArray2.push(this.levelPanel["level_txt2"],this.levelPanel["hp_txt2"],this.levelPanel["a_txt2"],this.levelPanel["d_txt2"],this.levelPanel["sa_txt2"],this.levelPanel["sd_txt2"],this.levelPanel["sp_txt2"]);
         this.levelPanel["name_txt"].text = PetXMLInfo.getName(_arg_2.id);
         this.levelPanel["exp_info_txt"].htmlText = "赛尔精灵获得经验：<font color=\'#ff0000\'>" + (_arg_1.exp - _arg_2.exp) + "\r</font>成功升级到了<font color=\'#ff0000\'>" + _arg_1.level + "</font>级";
         var _local_3:Array = [_arg_2.level,_arg_2.maxHp,_arg_2.attack,_arg_2.defence,_arg_2.s_a,_arg_2.s_d,_arg_2.speed];
         var _local_4:Array = [_arg_1.level,_arg_1.maxHp,_arg_1.attack,_arg_1.defence,_arg_1.sa,_arg_1.sd,_arg_1.sp];
         this.isEvolution = _arg_2.id < _arg_1.id;
         this.showInfo(_local_3,_local_4);
         if(this.isEvolution)
         {
            ResourceManager.getResource(ClientConfig.getPetSwfPath(_arg_2.id),this.onLoadOld,"pet");
         }
         ResourceManager.getResource(ClientConfig.getPetSwfPath(_arg_1.id),this.onLevelComplete,"pet");
      }
      
      private function showInfo(_arg_1:Array, _arg_2:Array) : void
      {
         var _local_3:uint = 0;
         var _local_4:TextField = null;
         var _local_5:TextField = null;
         var _local_6:int = 0;
         var _local_7:MovieClip = null;
         var _local_8:uint = 0;
         for each(_local_3 in _arg_1)
         {
            _local_4 = this.txtArray[_local_8];
            _local_5 = this.txtArray2[_local_8];
            _local_6 = _arg_2[_local_8] - _arg_1[_local_8];
            _local_4.text = "+" + _local_6;
            _local_5.text = _arg_2[_local_8];
            if(_local_6 > 0)
            {
               _local_4.textColor = 16711680;
               _local_7 = UIManager.getMovieClip("UpdateArrow");
               _local_7.x = _local_4.x + _local_4.width;
               _local_7.y = _local_4.y;
               this.levelPanel.addChild(_local_7);
               this.arrowArray.push(_local_7);
            }
            _local_8++;
         }
      }
      
      private function clearArrow() : void
      {
         var _local_1:MovieClip = null;
         var _local_2:TextField = null;
         if(Boolean(this.iconMC))
         {
            DisplayUtil.removeAllChild(this.iconMC);
         }
         for each(_local_1 in this.arrowArray)
         {
            DisplayUtil.removeForParent(_local_1);
         }
         this.arrowArray = [];
         for each(_local_2 in this.txtArray)
         {
            _local_2.textColor = 26112;
         }
      }
      
      private function onLoadOld(o:DisplayObject) : void
      {
         this.oldPetMC = o as MovieClip;
         if(Boolean(this.oldPetMC))
         {
            this.oldPetMC.gotoAndStop("rightdown");
            this.oldPetMC.addEventListener(Event.ENTER_FRAME,function():void
            {
               var _local_2:MovieClip = oldPetMC.getChildAt(0) as MovieClip;
               if(Boolean(_local_2))
               {
                  _local_2.gotoAndStop(1);
                  oldPetMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            this.oldPetMC.scaleX = 1.5;
            this.oldPetMC.scaleY = 1.5;
            if(this.isEvolution)
            {
               this.iconMC.addChild(this.oldPetMC);
            }
         }
      }
      
      private function onLevelComplete(o:DisplayObject) : void
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
            if(this.isEvolution)
            {
               this.evoPetMC.alpha = 0;
               this.showEvolution();
            }
         }
      }
      
      private function showEvolution() : void
      {
         TweenLite.to(this.oldPetMC,1,{
            "alpha":0,
            "onComplete":this.onComp
         });
         this.effectMC = UIManager.getMovieClip("ui_PetEvolution_MC");
         this.effectMC.x = 61;
         this.effectMC.y = 190;
         this.levelPanel.addChild(this.effectMC);
      }
      
      private function onComp() : void
      {
         TweenLite.to(this.evoPetMC,1,{"alpha":1});
      }
   }
}

