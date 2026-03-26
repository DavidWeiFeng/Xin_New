package com.robot.core.manager
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.filters.DropShadowFilter;
   import org.taomee.component.UIComponent;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.control.UIMovieClip;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Utils;
   
   public class TaskIconManager
   {
      
      private static var box:HBox;
      
      private static var _loader:Loader;
      
      private static var iconArray:HashMap = new HashMap();
      
      private static var filter:DropShadowFilter = new DropShadowFilter(5,45,0,0.6);
      
      public function TaskIconManager()
      {
         super();
      }
      
      public static function setup(_arg_1:Loader) : void
      {
         _loader = _arg_1;
         box = new HBox();
         box.width = MainManager.getStageWidth() - 15;
         box.height = 94;
         box.gap = 10;
         box.halign = FlowLayout.RIGHT;
         box.valign = FlowLayout.MIDLLE;
         LevelManager.iconLevel.addChild(box);
      }
      
      public static function getIcon(_arg_1:String) : InteractiveObject
      {
         return Utils.getDisplayObjectFromLoader(_arg_1,_loader) as InteractiveObject;
      }
      
      public static function addIcon(_arg_1:DisplayObject) : void
      {
         var _local_2:UIComponent = null;
         if(!iconArray.containsKey(_arg_1))
         {
            _local_2 = new UIMovieClip(_arg_1);
            box.appendAt(_local_2,0);
            _arg_1.filters = [filter];
            iconArray.add(_arg_1,_local_2);
         }
      }
      
      public static function delIcon(_arg_1:DisplayObject) : void
      {
         var _local_2:UIComponent = null;
         if(iconArray.containsKey(_arg_1))
         {
            _local_2 = iconArray.getValue(_arg_1) as UIComponent;
            box.remove(_local_2);
            iconArray.remove(_arg_1);
         }
      }
   }
}

