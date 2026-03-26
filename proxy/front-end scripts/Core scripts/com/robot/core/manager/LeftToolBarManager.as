package com.robot.core.manager
{
   import com.robot.core.manager.bean.BaseBeanController;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import gs.*;
   import org.taomee.component.containers.*;
   import org.taomee.component.control.*;
   import org.taomee.component.layout.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class LeftToolBarManager extends BaseBeanController
   {
      
      private static var box:VBox;
      
      private static var map:HashMap;
      
      private static var mc:MovieClip;
      
      private var btn:MovieClip;
      
      private var isShow:Boolean = false;
      
      public function LeftToolBarManager()
      {
         super();
      }
      
      public static function addIcon(_arg_1:DisplayObject) : void
      {
         var _local_2:UIMovieClip = new UIMovieClip(_arg_1);
         map.add(_arg_1,_local_2);
         box.append(_local_2);
         checkLengh();
      }
      
      public static function delIcon(_arg_1:DisplayObject) : void
      {
         var _local_2:UIMovieClip = map.getValue(_arg_1) as UIMovieClip;
         map.remove(_arg_1);
         if(Boolean(_local_2))
         {
            box.remove(_local_2);
         }
         checkLengh();
      }
      
      private static function checkLengh() : void
      {
         if(map.length > 0)
         {
            LevelManager.toolsLevel.addChild(mc);
         }
         else
         {
            DisplayUtil.removeForParent(mc);
         }
      }
      
      override public function start() : void
      {
         map = new HashMap();
         mc = CoreAssetsManager.getMovieClip("lib_left_toolBar");
         DisplayUtil.align(mc,null,AlignType.MIDDLE_LEFT);
         mc.x = -56;
         this.btn = mc["btn"];
         this.btn.buttonMode = true;
         this.btn.gotoAndStop(1);
         this.btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
         box = new VBox();
         box.mouseEnabled = false;
         box.isMask = false;
         box.setSizeWH(50,256);
         DisplayUtil.align(box,mc.getRect(mc),AlignType.MIDDLE_CENTER);
         box.x = 0;
         box.halign = FlowLayout.CENTER;
         box.valign = FlowLayout.MIDLLE;
         mc.addChild(box);
         checkLengh();
         finish();
      }
      
      private function clickHandler(_arg_1:MouseEvent) : void
      {
         this.isShow = !this.isShow;
         if(this.isShow)
         {
            this.btn.gotoAndStop(2);
            TweenLite.to(mc,0.3,{"x":0});
         }
         else
         {
            this.btn.gotoAndStop(1);
            TweenLite.to(mc,0.3,{"x":-56});
         }
      }
   }
}

