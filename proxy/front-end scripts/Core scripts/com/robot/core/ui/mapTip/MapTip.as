package com.robot.core.ui.mapTip
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class MapTip
   {
      
      private static var bgMC:MovieClip;
      
      private static var _info:MapTipInfo;
      
      private static var tipMC:Sprite;
      
      private static var itemContainer:Sprite;
      
      private static var leftGap:Number = 5;
      
      private static var rightGap:Number = 5;
      
      public function MapTip()
      {
         super();
      }
      
      public static function show(_arg_1:MapTipInfo, _arg_2:DisplayObjectContainer = null) : void
      {
         var _local_4:MapTipItem = null;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         var _local_7:MapTipItem = null;
         var _local_8:MapItemTipInfo = null;
         var _local_3:Number = NaN;
         tipMC = getTipMC();
         itemContainer = new Sprite();
         bgMC = UIManager.getMovieClip("MapTipBg");
         tipMC.addChild(bgMC);
         tipMC.addChild(itemContainer);
         if(Boolean(_arg_1))
         {
            _local_3 = 0;
            _local_5 = 0;
            for each(_local_6 in _arg_1.contentList)
            {
               _local_7 = new MapTipItem();
               _local_8 = new MapItemTipInfo(_arg_1.id,_local_6);
               _local_7.info = _local_8;
               if(Boolean(_local_4))
               {
                  _local_7.y = _local_3 + _local_4.height + 2;
               }
               itemContainer.addChild(_local_7);
               _local_4 = _local_7;
               _local_3 = _local_7.y;
               _local_5++;
            }
            bgMC.width = itemContainer.width + leftGap * 2;
            bgMC.height = itemContainer.height + rightGap * 2;
            itemContainer.x = leftGap;
            itemContainer.y = rightGap;
         }
         if(Boolean(_arg_2))
         {
            _arg_2.addChild(tipMC);
         }
         else
         {
            LevelManager.appLevel.addChild(tipMC);
         }
         tipMC.x = -200;
         tipMC.y = -500;
         tipMC.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
      }
      
      public static function hide() : void
      {
         if(Boolean(tipMC))
         {
            tipMC.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            DisplayUtil.removeAllChild(tipMC);
            DisplayUtil.removeForParent(tipMC);
         }
      }
      
      private static function enterFrameHandler(_arg_1:Event) : void
      {
         if(tipMC == null)
         {
            return;
         }
         if(MainManager.getStage().mouseX + tipMC.width + 20 >= MainManager.getStageWidth())
         {
            tipMC.x = MainManager.getStageWidth() - tipMC.width - 10;
         }
         else
         {
            tipMC.x = MainManager.getStage().mouseX + 10;
         }
         if(MainManager.getStage().mouseY + tipMC.height + 20 >= MainManager.getStageHeight())
         {
            tipMC.y = MainManager.getStageHeight() - tipMC.height - 10;
         }
         else
         {
            tipMC.y = MainManager.getStage().mouseY - tipMC.height / 2;
         }
      }
      
      private static function getTipMC() : Sprite
      {
         if(tipMC == null)
         {
            tipMC = new Sprite();
         }
         return tipMC;
      }
   }
}

