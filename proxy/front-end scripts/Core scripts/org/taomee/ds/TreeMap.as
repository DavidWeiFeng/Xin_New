package org.taomee.ds
{
   public class TreeMap implements ITree
   {
      
      private var _root:TreeMap;
      
      private var _data:*;
      
      private var _parent:TreeMap;
      
      private var _children:HashMap;
      
      private var _key:*;
      
      public function TreeMap(_arg_1:*, _arg_2:* = null, _arg_3:TreeMap = null)
      {
         super();
         this._key = _arg_1;
         this._data = _arg_2;
         this._children = new HashMap();
         this.parent = _arg_3;
      }
      
      public function get depth() : int
      {
         var _local_2:int = 0;
         if(this._parent == null)
         {
            return 0;
         }
         var _local_1:TreeMap = this._parent;
         while(Boolean(_local_1))
         {
            _local_2++;
            _local_1 = _local_1.parent;
            if(_local_1 == this)
            {
               throw new Error("TreeMap Infinite Loop");
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
         this._children.eachValue(function(_arg_1:TreeMap):void
         {
            _arg_1.parent = _parent;
         });
      }
      
      public function get parent() : TreeMap
      {
         return this._parent;
      }
      
      public function clear() : void
      {
         this._children = new HashMap();
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
      
      public function get key() : *
      {
         return this._key;
      }
      
      public function get root() : TreeMap
      {
         return this._root;
      }
      
      public function set parent(_arg_1:TreeMap) : void
      {
         if(Boolean(this._parent))
         {
            this._parent.children.remove(this._key);
         }
         if(_arg_1 == this)
         {
            return;
         }
         this._parent = _arg_1;
         if(Boolean(this._parent))
         {
            this._parent.children.add(this._key,this);
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
         var _local_1:TreeMap = this._parent;
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
               throw new Error("TreeMap Infinite Loop");
            }
         }
      }
      
      public function get length() : int
      {
         var _local_1:int = this.numChildren;
         var _local_2:TreeMap = this._parent;
         while(Boolean(_local_2))
         {
            _local_1 += _local_2.numChildren;
            _local_2 = _local_2.parent;
            if(_local_2 == this)
            {
               throw new Error("TreeMap Infinite Loop");
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
      
      public function set key(_arg_1:*) : void
      {
         if(Boolean(this._parent))
         {
            this._parent.children.remove(this._key);
            this._parent.children.add(_arg_1,this);
         }
         this._key = _arg_1;
      }
      
      public function get children() : HashMap
      {
         return this._children;
      }
   }
}

