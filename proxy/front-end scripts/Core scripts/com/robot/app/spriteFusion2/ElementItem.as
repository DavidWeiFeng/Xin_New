package com.robot.app.spriteFusion2
{
   import com.robot.core.config.xml.*;
   import com.robot.core.ui.itemTip.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.ApplicationDomain;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ElementItem extends Sprite
   {
      
      private var _info:ElementItemInfo;
      
      private var _mc:MovieClip;
      
      private var _icon:Sprite;
      
      public var type:uint;
      
      public function ElementItem(_arg_1:ApplicationDomain)
      {
         super();
         this._mc = new (_arg_1.getDefinition("ElementItemBg") as Class)() as MovieClip;
         this._mc.gotoAndStop(1);
         this.addChild(this._mc);
         this._icon = this._mc["icon"];
      }
      
      public function setNum(_arg_1:int) : void
      {
         if(_arg_1 <= 0)
         {
            this.setVisibel(false);
         }
         else
         {
            this.setVisibel(true);
         }
         this._mc["cntTxt"].text = _arg_1;
      }
      
      public function get info() : ElementItemInfo
      {
         return this._info;
      }
      
      public function get mc() : MovieClip
      {
         return this._mc;
      }
      
      public function set info(param1:ElementItemInfo) : void
      {
         var i:ElementItemInfo = null;
         i = param1;
         this._info = i;
         if(Boolean(i))
         {
            ResourceManager.getResource(ItemXMLInfo.getIconURL(i.info.itemID),function(param1:MovieClip):void
            {
               DisplayUtil.removeAllChild(_icon);
               _icon.addChild(param1);
               param1.scaleX = 0.75;
               param1.scaleY = 0.75;
               _icon.addEventListener(MouseEvent.ROLL_OVER,function():void
               {
                  ItemInfoTip.show(i.info);
               });
               _icon.addEventListener(MouseEvent.ROLL_OUT,function():void
               {
                  ItemInfoTip.hide();
               });
               setNum(i.num);
            });
         }
         else
         {
            DisplayUtil.removeAllChild(this._icon);
            this.setVisibel(false);
         }
      }
      
      private function setVisibel(_arg_1:Boolean) : void
      {
         if(!_arg_1)
         {
            this._icon.visible = false;
            this._mc["cntTxt"].visible = false;
            this.buttonMode = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
         }
         else
         {
            this._icon.visible = true;
            this._mc["cntTxt"].visible = true;
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.mouseChildren = true;
         }
      }
   }
}

