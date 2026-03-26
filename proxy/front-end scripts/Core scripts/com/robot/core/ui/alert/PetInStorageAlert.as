package com.robot.core.ui.alert
{
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PetInStorageAlert
   {
      
      public function PetInStorageAlert()
      {
         super();
      }
      
      public static function show(id:uint, str:String, par:DisplayObjectContainer = null, applyFunc:Function = null) : void
      {
         var bgmc:Sprite = null;
         var mainUI:Sprite = null;
         var applyBtn:SimpleButton = null;
         var onApply:Function = null;
         var onLoad:Function = null;
         mainUI = null;
         applyBtn = null;
         onApply = null;
         onLoad = null;
         onApply = function(_arg_1:MouseEvent):void
         {
            if(applyFunc != null)
            {
               applyFunc();
            }
            LevelManager.openMouseEvent();
            applyBtn.removeEventListener(MouseEvent.CLICK,onApply);
            ResourceManager.cancel(ClientConfig.getPetSwfPath(id),onLoad);
            DisplayUtil.removeForParent(mainUI);
            txt = null;
            applyBtn = null;
            mainUI = null;
         };
         onLoad = function(_arg_1:DisplayObject):void
         {
            var _local_2:MovieClip = null;
            _local_2 = _arg_1 as MovieClip;
            DisplayUtil.stopAllMovieClip(_local_2);
            mainUI.addChild(_local_2);
            _local_2.x = 100;
            _local_2.y = 100;
         };
         mainUI = UIManager.getSprite("UI_PetInStorageAlert");
         var txt:TextField = mainUI["txt"];
         txt.htmlText = str;
         bgmc = mainUI["bgMc"];
         bgmc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            mainUI.startDrag();
         });
         bgmc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            mainUI.stopDrag();
         });
         if(Boolean(par))
         {
            par.addChild(mainUI);
         }
         else
         {
            LevelManager.topLevel.addChild(mainUI);
         }
         DisplayUtil.align(mainUI,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         applyBtn = mainUI["applyBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,onApply);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(id),onLoad,"pet");
      }
   }
}

