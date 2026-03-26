package com.robot.core.aimat
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class AimatGridPanel
   {
      
      private static var bgMC:MovieClip;
      
      private static var gridArray:Array = [];
      
      setup();
      
      public function AimatGridPanel()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:AimatGrid = null;
         var _local_2:uint = 0;
         bgMC = UIManager.getMovieClip("ui_ThrowThingPanel");
         _local_1 = new AimatGrid();
         _local_1.x = 6;
         _local_1.y = 4;
         bgMC.addChild(_local_1);
         _local_1.itemID = 0;
         _local_1.addEventListener(AimatGrid.CLICK,onGridClick);
         _local_2 = 1;
         while(_local_2 < 9)
         {
            _local_1 = new AimatGrid();
            _local_1.x = 6 + (_local_1.width + 3) * (_local_2 % 3);
            _local_1.y = 4 + (_local_1.height + 3) * Math.floor(_local_2 / 3);
            bgMC.addChild(_local_1);
            gridArray.push(_local_1);
            _local_1.addEventListener(AimatGrid.CLICK,onGridClick);
            _local_2++;
         }
         ItemManager.addEventListener(ItemEvent.THROW_LIST,onThrowList);
      }
      
      public static function show(_arg_1:DisplayObject) : void
      {
         if(DisplayUtil.hasParent(bgMC))
         {
            hide();
            return;
         }
         clear();
         PopUpManager.showForDisplayObject(bgMC,_arg_1,PopUpManager.TOP_LEFT,true,new Point((bgMC.width + _arg_1.width) / 2,0));
         ItemManager.getThrowThing();
      }
      
      public static function hide() : void
      {
         DisplayUtil.removeForParent(bgMC,false);
      }
      
      private static function onThrowList(_arg_1:Event) : void
      {
         var _local_2:uint = 0;
         var _local_3:AimatGrid = null;
         var _local_5:uint = 0;
         var _local_4:Array = ItemManager.getThrowIDs();
         for each(_local_2 in _local_4)
         {
            _local_3 = gridArray[_local_5];
            _local_3.itemID = _local_2;
            _local_5++;
         }
      }
      
      private static function clear() : void
      {
         var _local_1:AimatGrid = null;
         for each(_local_1 in gridArray)
         {
            _local_1.empty();
         }
      }
      
      private static function onGridClick(_arg_1:Event) : void
      {
         hide();
      }
   }
}

