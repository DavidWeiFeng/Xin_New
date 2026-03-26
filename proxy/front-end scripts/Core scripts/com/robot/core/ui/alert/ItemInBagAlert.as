package com.robot.core.ui.alert
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ItemInBagAlert
   {
      
      public function ItemInBagAlert()
      {
         super();
      }
      
      public static function show(id:uint, str:String, applyFun:Function = null, isMouse:Boolean = false) : Sprite
      {
         var bgmc:Sprite = null;
         var txt:TextField = null;
         var sprite:Sprite = null;
         var icon:Sprite = null;
         var applyBtn:SimpleButton = null;
         var apply:Function = null;
         var onLoadIcon:Function = null;
         sprite = null;
         icon = null;
         applyBtn = null;
         apply = null;
         apply = function(_arg_1:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            if(applyFun != null)
            {
               applyFun();
            }
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            DisplayUtil.removeForParent(sprite);
         };
         onLoadIcon = function(_arg_1:DisplayObject):void
         {
            icon.addChild(_arg_1);
         };
         sprite = UIManager.getSprite("TaskItemAlarmMC");
         icon = new Sprite();
         icon.y = 70;
         icon.x = 70;
         sprite.addChild(icon);
         bgmc = sprite["bgMc"];
         bgmc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            sprite.startDrag();
         });
         bgmc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            sprite.stopDrag();
         });
         LevelManager.topLevel.addChild(sprite);
         DisplayUtil.align(sprite,null,AlignType.MIDDLE_CENTER);
         if(!isMouse)
         {
            LevelManager.closeMouseEvent();
         }
         txt = sprite["txt"];
         txt.htmlText = str;
         applyBtn = sprite["applyBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,apply);
         ResourceManager.getResource(ItemXMLInfo.getIconURL(id),onLoadIcon);
         return sprite;
      }
   }
}

