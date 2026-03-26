package com.robot.app.imgPanel
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.system.*;
   import org.taomee.utils.*;
   
   public class ImagePanel
   {
      
      private static var panel:MovieClip;
      
      private static var mcloader:MCLoader;
      
      private static var url:String;
      
      private static var W:uint = 342;
      
      private static var H:uint = 231;
      
      public function ImagePanel()
      {
         super();
      }
      
      public static function setup(_arg_1:String, _arg_2:uint) : void
      {
         Security.loadPolicyFile("http://" + _arg_1 + ":" + String(_arg_2) + "/crossdomain.xml");
      }
      
      public static function show(_arg_1:String) : void
      {
         url = _arg_1;
         if(!panel)
         {
            panel = UIManager.getMovieClip("ui_ImgPanel");
            panel["closeBtn"].addEventListener(MouseEvent.CLICK,closePanel);
            panel["saveBtn"].addEventListener(MouseEvent.CLICK,saveHandler);
            panel["imgMC"].mouseEnabled = false;
            panel["bgMC"].addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
            panel["bgMC"].addEventListener(MouseEvent.MOUSE_UP,upHandler);
            mcloader = new MCLoader("");
            mcloader.addEventListener(MCLoadEvent.SUCCESS,onSuccess);
            mcloader.addEventListener(MCLoadEvent.ERROR,onError);
         }
         panel["load_MC"].visible = true;
         DisplayUtil.align(panel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(panel);
         try
         {
            mcloader.loader.close();
         }
         catch(e:Error)
         {
         }
         while(panel["imgMC"].numChildren > 0)
         {
            panel["imgMC"].removeChildAt(0);
         }
         panel["bgMC"].width = W;
         panel["bgMC"].height = H;
         resetPanel();
         mcloader.doLoad(_arg_1);
      }
      
      private static function downHandler(_arg_1:MouseEvent) : void
      {
         panel.startDrag();
      }
      
      private static function upHandler(_arg_1:MouseEvent) : void
      {
         panel.stopDrag();
      }
      
      private static function resetPanel() : void
      {
         panel["closeBtn"].x = panel["bgMC"].width - 42;
         panel["saveBtn"].x = (panel["bgMC"].width - panel["saveBtn"].width) / 2;
         panel["saveBtn"].y = panel["bgMC"].height - panel["saveBtn"].height - 10;
      }
      
      private static function closePanel(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(panel,false);
      }
      
      private static function onSuccess(_arg_1:MCLoadEvent) : void
      {
         var _local_2:DisplayObject = _arg_1.getLoader();
         panel["load_MC"].visible = false;
         panel["imgMC"].addChild(_local_2);
         panel["bgMC"].width = _local_2.width + 46;
         panel["bgMC"].height = _local_2.height + 32;
         if(panel["bgMC"].width < W)
         {
            panel["bgMC"].width = W;
         }
         if(panel["bgMC"].height < H)
         {
            panel["bgMC"].height = H;
         }
         resetPanel();
      }
      
      private static function saveHandler(_arg_1:MouseEvent) : void
      {
         SaveBmp.download(url);
      }
      
      private static function onError(_arg_1:MCLoadEvent) : void
      {
         DisplayUtil.removeForParent(panel,false);
         Alarm.show("该图片已经不存在！");
      }
   }
}

