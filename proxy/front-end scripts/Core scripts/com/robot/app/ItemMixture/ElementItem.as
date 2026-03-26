package com.robot.app.ItemMixture
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.ui.itemTip.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   
   public class ElementItem extends Sprite
   {
      
      public var _info:SingleItemInfo;
      
      public var _mc:MovieClip;
      
      private var _icon:MovieClip;
      
      public function ElementItem(_arg_1:MovieClip)
      {
         super();
         this._mc = _arg_1;
         this._icon = this._mc["_icon"] as MovieClip;
      }
      
      public function setIcon(itemInfo:SingleItemInfo) : void
      {
         var onLoadIcon:Function;
         this._info = itemInfo;
         onLoadIcon = function(_arg_1:DisplayObject):void
         {
            _icon.addChild(_arg_1);
            _arg_1.addEventListener(MouseEvent.ROLL_OVER,showTip);
            _arg_1.addEventListener(MouseEvent.ROLL_OUT,hideTip);
         };
         ResourceManager.getResource(ItemXMLInfo.getIconURL(itemInfo.itemID),onLoadIcon);
      }
      
      private function showTip(_arg_1:MouseEvent) : void
      {
         ItemInfoTip.show(this._info);
      }
      
      private function hideTip(_arg_1:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
   }
}

