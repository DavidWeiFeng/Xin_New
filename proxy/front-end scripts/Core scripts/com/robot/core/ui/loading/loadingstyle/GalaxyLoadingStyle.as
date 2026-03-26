package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.manager.*;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.text.TextField;
   import org.taomee.utils.*;
   
   public class GalaxyLoadingStyle extends EventDispatcher implements ILoadingStyle
   {
      
      private var mc:MovieClip;
      
      private var parent:DisplayObjectContainer;
      
      private var txt:TextField;
      
      private var title:String;
      
      public function GalaxyLoadingStyle(_arg_1:DisplayObjectContainer = null, _arg_2:String = "")
      {
         super();
         this.mc = LoadingManager.getMovieClip("galaxy_loading_mc");
         this.parent = _arg_1;
         this.txt = this.mc["txt"];
         this.setTitle(_arg_2);
         this.show();
      }
      
      public function changePercent(_arg_1:Number, _arg_2:Number) : void
      {
         var _local_3:uint = uint(Math.floor(_arg_2 / _arg_1 * 100));
         this.txt.text = this.title + " " + _local_3 + "%";
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.mc);
         this.mc = null;
         this.parent = null;
      }
      
      public function show() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.addChild(this.mc);
         }
      }
      
      public function close() : void
      {
         DisplayUtil.removeForParent(this.mc);
      }
      
      public function setTitle(_arg_1:String) : void
      {
         this.title = _arg_1;
      }
      
      public function setIsShowCloseBtn(_arg_1:Boolean) : void
      {
      }
      
      public function getParentMC() : DisplayObjectContainer
      {
         return this.parent;
      }
      
      public function getLoadingMC() : DisplayObject
      {
         return this.mc;
      }
   }
}

