package com.robot.core.display.tree
{
   public class StatefulNode extends Node
   {
      
      private var _open:Boolean = false;
      
      private var _closed:Boolean;
      
      private var _isNewAndUN:Boolean = false;
      
      private var _isClick:Boolean = false;
      
      public function StatefulNode(_arg_1:String, _arg_2:INode, _arg_3:* = null)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
      
      public function hasOpenChilds() : Boolean
      {
         var _local_1:StatefulNode = null;
         for each(_local_1 in children)
         {
            if(_local_1.isOpen())
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasIsNewAndUNChilds() : Boolean
      {
         var _local_1:StatefulNode = null;
         for each(_local_1 in children)
         {
            if(_local_1.isNewAndUN)
            {
               return true;
            }
         }
         return false;
      }
      
      public function setClosed(_arg_1:Boolean) : void
      {
         this._closed = _arg_1;
      }
      
      public function isClosed() : Boolean
      {
         return this._closed;
      }
      
      public function setOpen(_arg_1:Boolean) : void
      {
         this._open = _arg_1;
      }
      
      public function isOpen() : Boolean
      {
         return this._open;
      }
      
      public function set isNewAndUN(_arg_1:Boolean) : void
      {
         this._isNewAndUN = _arg_1;
      }
      
      public function get isNewAndUN() : Boolean
      {
         return this._isNewAndUN;
      }
      
      public function set isClick(_arg_1:Boolean) : void
      {
         this._isClick = _arg_1;
      }
      
      public function get isClick() : Boolean
      {
         return this._isClick;
      }
   }
}

