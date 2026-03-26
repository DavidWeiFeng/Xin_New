package com.robot.app.spriteFusion2
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.ui.itemTip.ItemInfoTip;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class BtnItem extends Sprite
   {
      
      private var _info:BtnInfo;
      
      private var _mc:MovieClip;
      
      private var _icon:Sprite;
      
      public var type:uint;
      
      public function BtnItem(_arg_1:ApplicationDomain)
      {
         super();
         this._mc = new (_arg_1.getDefinition("BtnItemBg") as Class)() as MovieClip;
         this._mc.gotoAndStop(1);
         this.addChild(this._mc);
         this._icon = new Sprite();
         this.addChild(this._icon);
      }
      
      public function get info() : BtnInfo
      {
         return this._info;
      }
      
      public function get mc() : MovieClip
      {
         return this._mc;
      }
      
      public function set info(param1:BtnInfo) : void
      {
         var i:BtnInfo = null;
         i = param1;
         this._info = i;
         if(Boolean(i))
         {
            ResourceManager.getResource(ItemXMLInfo.getIconURL(i.itemInfo.itemID),function(param1:MovieClip):void
            {
               DisplayUtil.removeAllChild(_icon);
               _icon.addChild(param1);
               param1.scaleX = 0.85;
               param1.scaleY = 0.85;
               _icon.addEventListener(MouseEvent.ROLL_OVER,function():void
               {
                  ItemInfoTip.show(i.itemInfo);
               });
               _icon.addEventListener(MouseEvent.ROLL_OUT,function():void
               {
                  ItemInfoTip.hide();
               });
            });
         }
      }
   }
}

