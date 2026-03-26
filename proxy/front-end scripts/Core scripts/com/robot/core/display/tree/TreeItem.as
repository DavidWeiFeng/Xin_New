package com.robot.core.display.tree
{
   import com.robot.core.effect.GlowTween;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.text.*;
   import org.taomee.component.control.*;
   import org.taomee.manager.*;
   
   public class TreeItem extends Sprite
   {
      
      private static var glowTween:GlowTween;
      
      private static var _addGlow:Boolean = false;
      
      public function TreeItem()
      {
         super();
      }
      
      private static function setTaskState(_arg_1:*, _arg_2:MovieClip) : void
      {
         var _local_3:uint = 0;
         if(_arg_1.isVip == "1")
         {
            _local_3 = 4;
         }
         if(TasksManager.getTaskStatus(uint(_arg_1.id)) == TasksManager.COMPLETE)
         {
            _arg_2["taskstate"].gotoAndStop(4 + _local_3);
         }
         else if(_arg_1.newOnline == "1")
         {
            if(TasksManager.getTaskStatus(uint(_arg_1.id)) == TasksManager.ALR_ACCEPT)
            {
               _arg_2["taskstate"].gotoAndStop(2 + _local_3);
            }
            else
            {
               _arg_2["taskstate"].gotoAndStop(1 + _local_3);
            }
         }
         else if(_arg_1.offline == "1")
         {
            _arg_2["taskstate"].gotoAndStop(3 + _local_3);
         }
         else if(TasksManager.getTaskStatus(uint(_arg_1.id)) == TasksManager.UN_ACCEPT)
         {
            _arg_2["taskstate"].gotoAndStop(9);
         }
         else
         {
            _arg_2["taskstate"].gotoAndStop(2 + _local_3);
         }
      }
      
      public static function createItem(_arg_1:*, _arg_2:Boolean) : MovieClip
      {
         var _local_3:MovieClip = null;
         _addGlow = _arg_2;
         switch(uint(_arg_1.itemtype))
         {
            case 1:
               _local_3 = CoreAssetsManager.getMovieClip("item1");
               break;
            case 2:
               _local_3 = CoreAssetsManager.getMovieClip("item2");
               break;
            case 3:
               _local_3 = CoreAssetsManager.getMovieClip("item3");
               setInfo3(_local_3,_arg_1);
               break;
            case 4:
               _local_3 = CoreAssetsManager.getMovieClip("item4");
               setInfo4(_local_3,_arg_1);
               setTaskState(_arg_1,_local_3);
               break;
            case 5:
               _local_3 = CoreAssetsManager.getMovieClip("item5");
               setInfo5(_local_3,_arg_1);
               setTaskState(_arg_1,_local_3);
               break;
            default:
               _local_3 = CoreAssetsManager.getMovieClip("item5");
               setInfo5(_local_3,_arg_1);
         }
         (_local_3["bg"] as MovieClip).gotoAndStop(1);
         return _local_3;
      }
      
      private static function setInfo3(_arg_1:MovieClip, _arg_2:*) : void
      {
         getStarIconByID(_arg_2.starid,_arg_1["icon"] as MovieClip);
         (_arg_1["bg"] as MovieClip).gotoAndStop(1);
         (_arg_1["titlename"] as TextField).htmlText = _arg_2.name;
         (_arg_1["star"] as MovieClip).gotoAndStop(uint(_arg_2.starlevel) + 1);
         (_arg_1["leveltxt"] as TextField).htmlText = _arg_2.spanlevel;
         if(_addGlow)
         {
            _arg_1["tip_mc"].visible = true;
         }
         else
         {
            _arg_1["tip_mc"].visible = false;
         }
      }
      
      private static function setInfo4(_arg_1:MovieClip, _arg_2:*) : void
      {
         makeTaskIcon(_arg_2.id,_arg_1["icon"] as MovieClip);
         (_arg_1["titletxt"] as TextField).htmlText = _arg_2.name;
         (_arg_1["star"] as MovieClip).gotoAndStop(uint(_arg_2.starlevel) + 1);
         (_arg_1["taskstate"] as MovieClip).gotoAndStop(1);
      }
      
      private static function setInfo5(_arg_1:MovieClip, _arg_2:*) : void
      {
         makeTaskIcon(_arg_2.id,_arg_1["icon"] as MovieClip);
         (_arg_1["titletxt"] as TextField).htmlText = _arg_2.name;
      }
      
      public static function getStarIconByID(id:String, iconContainer:MovieClip) : void
      {
         var _url:String = null;
         iconContainer.scaleX = 1;
         iconContainer.scaleY = 1;
         _url = "resource/planet/icon/" + id + ".swf";
         ResourceManager.getResource(_url,function(_arg_1:DisplayObject):void
         {
            var _local_2:MLoadPane = null;
            if(Boolean(_arg_1))
            {
               _local_2 = new MLoadPane(_arg_1);
               if(_arg_1.width > _arg_1.height)
               {
                  _local_2.fitType = MLoadPane.FIT_WIDTH;
               }
               else
               {
                  _local_2.fitType = MLoadPane.FIT_HEIGHT;
               }
               _local_2.setSizeWH(40,40);
               iconContainer.addChild(_local_2);
            }
         },"star");
      }
      
      private static function makeTaskIcon(taskID:String, iconContainer:MovieClip) : void
      {
         var url:String = "resource/task/icon/" + taskID + ".swf";
         ResourceManager.getResource(url,function(_arg_1:DisplayObject):void
         {
            if(Boolean(_arg_1))
            {
               _arg_1.scaleX = 0.5;
               _arg_1.scaleY = 0.5;
               iconContainer.addChild(_arg_1);
            }
         },"item");
      }
   }
}

