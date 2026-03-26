package org.taomee.ds
{
   public class TreeList implements ITree
   {
      
      private var _root:TreeList;
      
      private var _data:*;
      
      private var _parent:TreeList;
      
      private var _children:Array;
      
      public function TreeList(_arg_1:* = null, _arg_2:TreeList = null)
      {
         super();
         this._data = _arg_1;
         this._children = [];
         this.parent = _arg_2;
      }
      
      public function get depth() : int
      {
         var _local_2:int = 0;
         if(this._parent == null)
         {
            return 0;
         }
         var _local_1:TreeList = this._parent;
         while(Boolean(_local_1))
         {
            _local_2++;
            _local_1 = _local_1.parent;
            if(_local_1 == this)
            {
               throw new Error("TreeList Infinite Loop");
            }
         }
         return _local_2;
      }
      
      public function remove() : void
      {
         var _local_1:TreeList = null;
         if(this._parent == null)
         {
            return;
         }
         for each(_local_1 in this._children)
         {
            _local_1.parent = this._parent;
         }
      }
      
      public function clear() : void
      {
         this._children = [];
      }
      
      public function set data(_arg_1:*) : void
      {
         this._data = _arg_1;
      }
      
      public function get numSiblings() : int
      {
         if(Boolean(this._parent))
         {
            return this._parent.numChildren;
         }
         return 0;
      }
      
      public function get root() : TreeList
      {
         return this._root;
      }
      
      public function set parent(_arg_1:TreeList) : void
      {
         var _local_2:int = 0;
         if(Boolean(this._parent))
         {
            _local_2 = int(this._parent.children.indexOf(this));
            if(_local_2 != -1)
            {
               this._parent.children.splice(_local_2,1);
            }
         }
         if(_arg_1 == this)
         {
            return;
         }
         this._parent = _arg_1;
         if(Boolean(this._parent))
         {
            this._parent.children.push(this);
         }
         this.setRoot();
      }
      
      private function setRoot() : void
      {
         if(this._parent == null)
         {
            this._root = this;
            return;
         }
         var _local_1:TreeList = this._parent;
         while(Boolean(_local_1))
         {
            if(_local_1.parent == null)
            {
               this._root = _local_1;
               return;
            }
            _local_1 = _local_1.parent;
            if(_local_1 == this)
            {
               throw new Error("TreeList Infinite Loop");
            }
         }
      }
      
      public function get length() : int
      {
         var _local_1:int = this.numChildren;
         var _local_2:TreeList = this._parent;
         while(Boolean(_local_2))
         {
            _local_1 += _local_2.numChildren;
            _local_2 = _local_2.parent;
            if(_local_2 == this)
            {
               throw new Error("TreeList Infinite Loop");
            }
         }
         return _local_1;
      }
      
      public function get isLeaf() : Boolean
      {
         return this._children.length == 0;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get isRoot() : Boolean
      {
         return this._root == this;
      }
      
      public function get numChildren() : int
      {
         return this._children.length;
      }
      
      public function get parent() : TreeList
      {
         return this._parent;
      }
      
      public function get children() : Array
      {
         return this._children;
      }
   }
}

