package com.robot.core.ui.skillBtn
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import org.taomee.utils.*;
   
   [Event(name="click",type="flash.events.MouseEvent")]
   public class NormalSkillBtn extends Sprite
   {
      
      private var _mc:MovieClip;
      
      public var skillID:uint;
      
      private var currentPP:int;
      
      public function NormalSkillBtn(_arg_1:uint = 0, _arg_2:int = -1)
      {
         super();
         this._mc = this.getMC();
         this._mc.gotoAndStop(1);
         this._mc["iconMC"].gotoAndStop(1);
         this._mc["nameTxt"].mouseEnabled = false;
         this._mc["migTxt"].mouseEnabled = false;
         this._mc["ppTxt"].mouseEnabled = false;
         addChild(this._mc);
         this.init(_arg_1,_arg_2);
      }
      
      protected function getMC() : MovieClip
      {
         return UIManager.getMovieClip("ui_Normal_PetSkilBtn");
      }
      
      public function init(_arg_1:uint, _arg_2:int = -1) : void
      {
         this.skillID = _arg_1;
         this.currentPP = _arg_2;
         if(this.skillID <= 0)
         {
            return;
         }
         this._mc["nameTxt"].text = SkillXMLInfo.getName(_arg_1);
         var _local_3:String = SkillXMLInfo.getTypeEN(_arg_1);
         this._mc["iconMC"].gotoAndStop(_local_3);
         this._mc["migTxt"].text = "威力:" + SkillXMLInfo.getDamage(_arg_1).toString();
         var _local_4:String = SkillXMLInfo.getPP(_arg_1).toString();
         if(_arg_2 == -1)
         {
            this._mc["ppTxt"].text = "PP:" + _local_4 + "/" + _local_4;
         }
         else
         {
            this._mc["ppTxt"].text = "PP:" + _arg_2.toString() + "/" + _local_4;
         }
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      public function get mc() : Sprite
      {
         return this._mc;
      }
      
      public function setSelect(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this._mc.gotoAndStop(2);
         }
         else
         {
            this._mc.gotoAndStop(1);
         }
      }
      
      public function clear() : void
      {
         this._mc["iconMC"].gotoAndStop(1);
         this._mc["nameTxt"].text = "";
         this._mc["migTxt"].text = "";
         this._mc["ppTxt"].text = "";
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      public function destroy() : void
      {
         this.clear();
         DisplayUtil.removeForParent(this);
         this._mc = null;
      }
      
      private function overHandler(_arg_1:MouseEvent) : void
      {
         SkillInfoTip.show(this.skillID);
      }
      
      private function outHandler(_arg_1:MouseEvent) : void
      {
         SkillInfoTip.hide();
      }
   }
}

