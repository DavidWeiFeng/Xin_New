package com.robot.app.bag
{
   import com.robot.core.config.xml.*;
   import com.robot.core.info.userItem.SingleItemInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.effect.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class BagListItem extends Sprite
   {
      
      private var _info:SingleItemInfo;
      
      private var _obj:DisplayObject;
      
      private var _con:Sprite;
      
      private var _txt:TextField;
      
      private var _hasPrev:Boolean;
      
      public function BagListItem(_arg_1:Sprite)
      {
         super();
         mouseChildren = false;
         addChild(_arg_1);
         this._con = _arg_1["mc"];
         this._txt = _arg_1["num_txt"];
      }
      
      public function setInfo(_arg_1:SingleItemInfo, _arg_2:Boolean = false) : void
      {
         if(Boolean(this._info))
         {
            ResourceManager.cancel(ItemXMLInfo.getIconURL(this._info.itemID,this._info.itemLevel),this.onLoad);
         }
         this._info = _arg_1;
         this._hasPrev = _arg_2;
         if(this._info.itemNum > 1)
         {
            this._txt.text = this._info.itemNum.toString();
         }
         if(this._info.leftTime == 0)
         {
            this._con.filters = [ColorFilter.setGrayscale()];
         }
         if(Boolean(this._obj))
         {
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
         ResourceManager.getResource(ItemXMLInfo.getIconURL(this._info.itemID,this._info.itemLevel),this.onLoad);
      }
      
      public function get info() : SingleItemInfo
      {
         return this._info;
      }
      
      public function set text(_arg_1:String) : void
      {
         this._txt.text = _arg_1;
      }
      
      public function clear() : void
      {
         if(Boolean(this._info))
         {
            ResourceManager.cancel(ItemXMLInfo.getIconURL(this._info.itemID,this._info.itemLevel),this.onLoad);
         }
         this._info = null;
         if(Boolean(this._obj))
         {
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
         this._con.filters = [];
         this._txt.text = "";
      }
      
      private function onLoad(_arg_1:DisplayObject) : void
      {
         this._obj = _arg_1;
         this._con.addChild(this._obj);
         if(this._info.itemNum == 0)
         {
            DisplayUtil.FillColor(this._obj,3355443);
            this._txt.text = "0";
         }
         else if(BagShowType.currType == BagShowType.SUIT)
         {
            if(this._hasPrev)
            {
               this._obj.alpha = 0.4;
               this._txt.text = "0";
            }
            else
            {
               this._txt.text = "1";
            }
         }
      }
   }
}

