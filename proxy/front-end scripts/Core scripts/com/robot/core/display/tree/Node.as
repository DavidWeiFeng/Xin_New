package com.robot.core.display.tree
{
   public class Node implements INode
   {
      
      private var _name:String;
      
      private var _children:Array;
      
      private var _data:*;
      
      private var _parent:INode;
      
      public function Node(_arg_1:String, _arg_2:INode, _arg_3:* = null)
      {
         super();
         this._name = _arg_1;
         this._parent = _arg_2;
         this._data = _arg_3;
      }
      
      public function get children() : Array
      {
         if(this._children == null)
         {
            return new Array();
         }
         return this._children;
      }
      
      public function addChild(_arg_1:INode) : INode
      {
         if(this._children == null)
         {
            this._children = new Array();
         }
         this._children.push(_arg_1);
         return _arg_1;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(_arg_1:*) : void
      {
         this._data = _arg_1;
      }
      
      public function get layer() : uint
      {
         return this.parent != null ? uint(this._parent.layer + 1) : 0;
      }
      
      public function get parent() : INode
      {
         return this._parent;
      }
      
      public function set parent(_arg_1:INode) : void
      {
         this._parent = _arg_1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function finalize() : void
      {
         var _local_1:INode = null;
         for each(_local_1 in this._children)
         {
            _local_1.finalize();
         }
         this._children = null;
         this._data = null;
         this._parent = null;
      }
      
      public function toString() : String
      {
         var _local_1:String = this.parent != null ? this._parent.name : null;
         return "Node name " + this.name + " parent id " + _local_1 + " layer " + this.layer + " data " + this.data;
      }
   }
}

