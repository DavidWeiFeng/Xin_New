package com.robot.app.taskPanel
{
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.TextField;
   import org.taomee.effect.*;
   
   public class TaskListItem extends Sprite
   {
      
      private var mc:MovieClip;
      
      private var _id:uint;
      
      private var _status:uint;
      
      public function TaskListItem(_arg_1:uint)
      {
         var _local_2:uint = 0;
         super();
         this._id = _arg_1;
         this.mc = CoreAssetsManager.getMovieClip("ui_listItemMC");
         this.mc["bgMC"].gotoAndStop(1);
         addChild(this.mc);
         var _local_3:TextField = this.mc["txt"];
         _local_3.text = TasksXMLInfo.getName(_arg_1);
         this.mouseChildren = false;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         if(this.id == 1 || this._id == 2 || this._id == 3 || this._id == 4)
         {
            _local_2 = uint(TasksManager.ALR_ACCEPT);
            if(TasksManager.getTaskStatus(1) == _local_2 || TasksManager.getTaskStatus(2) == _local_2 || TasksManager.getTaskStatus(3) == _local_2 || TasksManager.getTaskStatus(4) == _local_2)
            {
               this._status = TasksManager.ALR_ACCEPT;
            }
         }
         else
         {
            this._status = TasksManager.getTaskStatus(_arg_1);
         }
         if(this._status == TasksManager.ALR_ACCEPT)
         {
            this.filters = [ColorFilter.setHue(180),ColorFilter.setContrast(30)];
         }
      }
      
      public function get status() : uint
      {
         return this._status;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      private function overHandler(_arg_1:MouseEvent) : void
      {
         this.mc["bgMC"].gotoAndStop(2);
      }
      
      private function outHandler(_arg_1:MouseEvent) : void
      {
         this.mc["bgMC"].gotoAndStop(1);
      }
      
      public function destroy() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.mc = null;
      }
   }
}

