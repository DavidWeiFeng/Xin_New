package com.robot.core.ui.alert
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class IconAlert
   {
      
      public function IconAlert()
      {
         super();
      }
      
      public static function show(str:String, itemID:uint, applyFun:Function = null, cancelFun:Function = null) : Sprite
      {
         var txt:TextField = null;
         var sprite:Sprite = null;
         var icon:Sprite = null;
         var applyBtn:SimpleButton = null;
         var cancelBtn:SimpleButton = null;
         var apply:Function = null;
         var cancel:Function = null;
         var onLoadIcon:Function = null;
         sprite = null;
         icon = null;
         applyBtn = null;
         cancelBtn = null;
         apply = null;
         cancel = null;
         apply = function(_arg_1:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            if(applyFun != null)
            {
               applyFun();
            }
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            cancelBtn.removeEventListener(MouseEvent.CLICK,cancel);
            DisplayUtil.removeForParent(sprite);
         };
         cancel = function(_arg_1:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            if(cancelFun != null)
            {
               cancelFun();
            }
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            cancelBtn.removeEventListener(MouseEvent.CLICK,cancel);
            DisplayUtil.removeForParent(sprite);
         };
         onLoadIcon = function(_arg_1:DisplayObject):void
         {
            icon.addChild(_arg_1);
         };
         sprite = UIManager.getSprite("AlertMC");
         var bgmc:Sprite = sprite["bgMc"];
         bgmc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            sprite.startDrag();
         });
         bgmc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            sprite.stopDrag();
         });
         icon = new Sprite();
         icon.mouseEnabled = false;
         icon.mouseChildren = false;
         sprite.addChild(icon);
         DisplayUtil.align(icon,new Rectangle(40,60,265 - 48,90),AlignType.TOP_CENTER);
         LevelManager.topLevel.addChild(sprite);
         DisplayUtil.align(sprite,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         txt = sprite["txt"];
         txt.autoSize = TextFormatAlign.CENTER;
         txt.width = 265;
         txt.htmlText = str;
         DisplayUtil.align(txt,new Rectangle(40,60,265,90),AlignType.BOTTOM_CENTER);
         applyBtn = sprite["applyBtn"];
         cancelBtn = sprite["cancelBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,apply);
         cancelBtn.addEventListener(MouseEvent.CLICK,cancel);
         ResourceManager.getResource(ItemXMLInfo.getIconURL(itemID),onLoadIcon);
         return sprite;
      }
   }
}

