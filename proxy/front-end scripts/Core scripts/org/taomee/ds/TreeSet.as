package org.taomee.ds
{
   public class TreeSet implements ITree
   {
      
      private var _root:TreeSet;
      
      private var _data:*;
      
      private var _parent:TreeSet;
      
      private var _children:HashSet;
      
      public function TreeSet(_arg_1:* = null, _arg_2:TreeSet = null)
      {
         super();
         this._data = _arg_1;
         this._children = new HashSet();
         this.parent = _arg_2;
      }
      
      public function get depth() : int
      {
         var _local_2:int = 0;
         if(!this._parent)
         {
            return 0;
         }
         var _local_1:TreeSet = this._parent;
         while(Boolean(_local_1))
         {
            _local_2++;
            _local_1 = _local_1.parent;
            if(_local_1 == this)
            {
               throw new Error("TreeSet Infinite Loop");
            }
         }
         return _local_2;
      }
      
      public function remove() : void
      {
         if(this._parent == null)
         {
            return;
         }
         this._children.each2(function(_arg_1:TreeSet):void
         {
            _arg_1.parent = _parent;
         });
      }
      
      public function clear() : void
      {
         this._children = new HashSet();
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
      
      public function get root() : TreeSet
      {
         return this._root;
      }
      
      public function set parent(_arg_1:TreeSet) : void
      {
         if(Boolean(this._parent))
         {
            this._parent.children.remove(this);
         }
         if(_arg_1 == this)
         {
            return;
         }
         this._parent = _arg_1;
         if(Boolean(this._parent))
         {
            this._parent.children.add(this);
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
         var _local_1:TreeSet = this._parent;
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
               throw new Error("TreeSet Infinite Loop");
            }
         }
      }
      
      public function get length() : int
      {
         var _local_1:int = this.numChildren;
         var _local_2:TreeSet = this._parent;
         while(Boolean(_local_2))
         {
            _local_1 += _local_2.numChildren;
            _local_2 = _local_2.parent;
            if(_local_2 == this)
            {
               throw new Error("TreeSet Infinite Loop");
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
      
      public function get parent() : TreeSet
      {
         return this._parent;
      }
      
      public function get children() : HashSet
      {
         return this._children;
      }
   }
}

