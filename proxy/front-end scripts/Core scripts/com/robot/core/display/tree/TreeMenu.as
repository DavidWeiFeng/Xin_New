package com.robot.core.display.tree
{
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TreeMenu extends Sprite
   {
      
      private var _tree:Tree;
      
      private var _btnArr:Array;
      
      private var _display:Sprite;
      
      private var _itemname:String = "";
      
      private var _clickBtnY:Number = 0;
      
      public function TreeMenu(_arg_1:Tree)
      {
         super();
         this._tree = _arg_1;
         this._display = new Sprite();
         this.addChild(this._display);
         this.renderTree();
      }
      
      private function renderTree(_arg_1:String = "") : void
      {
         var _local_2:StatefulNode = null;
         var _local_3:Boolean = false;
         var _local_4:MovieClip = null;
         var _local_5:Btn = null;
         var _local_7:uint = 0;
         this._btnArr = new Array();
         var _local_6:Array = this._tree.toArray();
         for each(_local_2 in _local_6)
         {
            if(_local_2.isOpen() && _local_2 != this._tree.root)
            {
               _local_3 = false;
               if(_local_2.hasIsNewAndUNChilds() && !_local_2.isClick)
               {
                  _local_3 = true;
               }
               _local_4 = TreeItem.createItem(_local_2.data,_local_3);
               _local_5 = new Btn(_local_2.name,_local_4,_local_2);
               _local_5.addEventListener(MouseEvent.CLICK,this.onRelease);
               if(_local_2.layer == 1)
               {
                  _local_5.display.x = 10;
               }
               _local_5.display.y = _local_7;
               this._display.addChild(_local_5.display);
               _local_7 = _local_5.display.y + _local_5.display.height + 2;
               this._btnArr.push(_local_5);
            }
            if(_local_2.name == _arg_1)
            {
               this._clickBtnY = _local_7;
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onRelease(_arg_1:MouseEvent) : void
      {
         this.select((_arg_1.target as Btn).nameID);
         if(this._itemname == (_arg_1.target as Btn).nameID)
         {
            return;
         }
         this._itemname = (_arg_1.target as Btn).nameID;
         dispatchEvent(new ItemClickEvent(_arg_1.target as Btn,ItemClickEvent.ITEMCLICK));
      }
      
      public function select(_arg_1:String, _arg_2:Array = null, _arg_3:Boolean = true) : void
      {
         var _local_4:StatefulNode = null;
         var _local_5:StatefulNode = null;
         var _local_6:StatefulNode = null;
         var _local_7:StatefulNode = Tree.getNodeByNameID(_arg_1,this._tree.root) as StatefulNode;
         if(_local_7 == null)
         {
            return;
         }
         _local_7.isClick = true;
         for each(_local_4 in _local_7.children)
         {
            for each(_local_5 in _local_4.children)
            {
               if(_local_5.data.newOnline == "1")
               {
                  if(TasksManager.getTaskStatus(_local_5.data.id) == TasksManager.UN_ACCEPT)
                  {
                     _local_5.isNewAndUN = true;
                  }
               }
            }
         }
         if(!_local_7.hasOpenChilds())
         {
            for each(_local_6 in _local_7.children)
            {
               _local_6.setOpen(true);
               this.openClosedNodes(_local_6);
            }
            _local_7.setOpen(true);
            this.openParents(_local_7);
         }
         else
         {
            this.closeChildren(_local_7);
         }
         this.finishTree();
         this.renderTree(_local_7.name);
         this.markButton(_local_7.name);
      }
      
      public function finishTree() : void
      {
         this._clickBtnY = 0;
         while(this._display.numChildren > 0)
         {
            this._display.removeChildAt(0);
         }
      }
      
      private function markButton(_arg_1:String) : void
      {
         var _local_2:Btn = null;
         for each(_local_2 in this._btnArr)
         {
            if(_local_2.nameID == _arg_1)
            {
               _local_2.mark();
            }
            else
            {
               _local_2.unmark();
            }
         }
      }
      
      private function closeBrotherNodesChildren(_arg_1:StatefulNode, _arg_2:StatefulNode) : void
      {
         if(_arg_1.name != _arg_2.name)
         {
            this.closeChildren(_arg_2);
         }
      }
      
      private function openClosedNodes(_arg_1:StatefulNode) : void
      {
         var _local_2:StatefulNode = null;
         for each(_local_2 in _arg_1.children)
         {
            if(_local_2.isClosed())
            {
               _local_2.setOpen(true);
               this.openClosedNodes(_local_2);
            }
         }
      }
      
      private function closeChildren(_arg_1:StatefulNode) : void
      {
         var _local_2:StatefulNode = null;
         for each(_local_2 in _arg_1.children)
         {
            if(_local_2.isOpen())
            {
               _local_2.setClosed(true);
            }
            else
            {
               _local_2.setClosed(false);
            }
            _local_2.setOpen(false);
            this.closeChildren(_local_2);
         }
      }
      
      private function openParents(_arg_1:StatefulNode) : void
      {
         var _local_2:StatefulNode = null;
         var _local_3:StatefulNode = _arg_1.parent as StatefulNode;
         if(Boolean(_local_3))
         {
            _local_3.setOpen(true);
            for each(_local_2 in _local_3.children)
            {
               _local_2.setOpen(true);
               this.closeBrotherNodesChildren(_arg_1,_local_2);
            }
            this.openParents(_local_3);
         }
         else
         {
            _arg_1.setOpen(true);
         }
      }
      
      public function finalize() : void
      {
         this.finishTree();
         this._tree.finalize();
      }
      
      public function get display() : DisplayObject
      {
         return this._display;
      }
      
      public function getItemCount() : uint
      {
         return this._btnArr.length;
      }
      
      public function getClickBtnY() : Number
      {
         return this._clickBtnY;
      }
   }
}

