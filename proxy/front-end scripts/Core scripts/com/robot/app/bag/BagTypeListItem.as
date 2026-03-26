package com.robot.app.bag
{
   import flash.display.*;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import org.taomee.utils.*;
   
   public class BagTypeListItem extends Sprite
   {
      
      private var _width:Number;
      
      private var _id:int = 0;
      
      private var _txt:TextField;
      
      private var _bgMC:MovieClip;
      
      public function BagTypeListItem(_arg_1:ApplicationDomain)
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         this._bgMC = new (_arg_1.getDefinition("ListItemMc") as Class)() as MovieClip;
         this._bgMC.gotoAndStop(1);
         addChild(this._bgMC);
         this._txt = this._bgMC["txt"];
         visible = true;
         this.width = 80;
      }
      
      override public function set width(_arg_1:Number) : void
      {
         this._width = _arg_1;
         this._bgMC.width = _arg_1;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      public function setInfo(_arg_1:int, _arg_2:String) : void
      {
         this._id = _arg_1;
         this._txt.text = _arg_2;
         visible = true;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set select(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this._bgMC.gotoAndStop(2);
         }
         else
         {
            this._bgMC.gotoAndStop(1);
         }
      }
      
      public function clear() : void
      {
         this._txt.text = "";
         visible = false;
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeAllChild(this);
         this._txt = null;
      }
   }
}

