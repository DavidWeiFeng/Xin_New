package com.robot.core.display.tree
{
   import com.robot.core.utils.*;
   import flash.xml.*;
   
   public class Tree
   {
      
      private var _root:INode;
      
      public function Tree(_arg_1:INode)
      {
         super();
         this._root = _arg_1;
      }
      
      public static function visit(_arg_1:INode, _arg_2:Function) : void
      {
         var _local_3:INode = null;
         for each(_local_3 in _arg_1.children)
         {
            _arg_2(_local_3);
            visit(_local_3,_arg_2);
         }
      }
      
      public static function clone(_arg_1:INode) : INode
      {
         var _local_2:INode = new Node(_arg_1.name,null,_arg_1.data);
         cloneHelper(_arg_1,_local_2);
         return _local_2;
      }
      
      private static function cloneHelper(_arg_1:INode, _arg_2:INode) : void
      {
         var _local_3:INode = null;
         for each(_local_3 in _arg_1.children)
         {
            cloneHelper(_local_3,_arg_2.addChild(new Node(_local_3.name,_arg_2,_local_3.data)));
         }
      }
      
      public static function toXml(_arg_1:Tree, _arg_2:String = "tree", _arg_3:String = "node") : XML
      {
         var _local_4:XMLDocument = new XMLDocument();
         var _local_5:XMLNode = _local_4.createElement(_arg_2);
         _local_4.appendChild(_local_5);
         getXml(_arg_1.root,_local_5,_local_4,_arg_3);
         return new XML(_local_4.toString());
      }
      
      private static function getXml(_arg_1:INode, _arg_2:XMLNode, _arg_3:XMLDocument, _arg_4:String) : void
      {
         var _local_5:INode = null;
         var _local_6:XMLNode = null;
         for each(_local_5 in _arg_1.children)
         {
            if(_arg_4 == null)
            {
               _arg_4 = _local_5.name;
            }
            _local_6 = _arg_3.createElement(_arg_4);
            if(_arg_4 != _local_5.name)
            {
               _local_6.attributes = {"name":_local_5.name};
            }
            else
            {
               _arg_4 = null;
            }
            _arg_2.appendChild(_local_6);
            getXml(_local_5,_local_6,_arg_3,_arg_4);
         }
      }
      
      public static function fromXml(_arg_1:Tree, _arg_2:XML, _arg_3:Class = null) : Tree
      {
         if(_arg_3 == null)
         {
            _arg_3 = Node;
         }
         var _local_4:XMLDocument = new XMLDocument();
         _local_4.parseXML(_arg_2);
         createTree(_local_4.firstChild,_arg_1.root = new _arg_3("tree",null),_arg_3);
         return _arg_1;
      }
      
      private static function createTree(_arg_1:XMLNode, _arg_2:INode, _arg_3:Class) : void
      {
         var _local_4:XMLNode = null;
         var _local_5:INode = null;
         for each(_local_4 in _arg_1.childNodes)
         {
            if(_local_4.nodeName != null)
            {
               _local_5 = new _arg_3(_local_4.attributes["name"],_arg_2);
               _arg_2.addChild(_local_5);
               createTree(_local_4,_local_5,_arg_3);
            }
         }
      }
      
      public static function getParentNodeChain(_arg_1:INode) : Array
      {
         var _local_2:Array = new Array();
         getParentNodeChainHelper(_arg_1,_local_2);
         return _local_2;
      }
      
      private static function getParentNodeChainHelper(_arg_1:INode, _arg_2:Array) : void
      {
         var _local_3:INode = _arg_1.parent as INode;
         if(Boolean(_local_3))
         {
            _arg_2.push(_local_3);
            getParentNodeChainHelper(_local_3,_arg_2);
         }
      }
      
      public static function getCommonParent(_arg_1:INode, _arg_2:INode) : INode
      {
         var _local_3:INode = null;
         var _local_4:INode = null;
         var _local_5:Array = getParentNodeChain(_arg_1);
         var _local_6:Array = getParentNodeChain(_arg_2);
         for each(_local_3 in _local_5)
         {
            for each(_local_4 in _local_6)
            {
               if(_local_3 == _local_4)
               {
                  return _local_3;
               }
            }
         }
         return null;
      }
      
      public static function getNodesUntilCommonParent(_arg_1:INode, _arg_2:Array) : Array
      {
         var _local_3:Array = new Array();
         getNodesUntilCommonParentHelper(_arg_1,_local_3,_arg_2);
         return _local_3;
      }
      
      private static function getNodesUntilCommonParentHelper(_arg_1:INode, _arg_2:Array, _arg_3:Array) : void
      {
         _arg_2.push(_arg_1);
         var _local_4:INode = _arg_1.parent as INode;
         if(Boolean(_local_4) && (!ArrayUtils.contains(_arg_3,_local_4) && !ArrayUtils.contains(_arg_3,_arg_1)))
         {
            getNodesUntilCommonParentHelper(_local_4,_arg_2,_arg_3);
         }
      }
      
      public static function getNodeByNameID(_arg_1:String, _arg_2:INode) : INode
      {
         var _local_3:INode = null;
         var _local_4:INode = null;
         if(_arg_2.name == _arg_1)
         {
            return _arg_2;
         }
         for each(_local_3 in _arg_2.children)
         {
            _local_4 = getNodeByNameID(_arg_1,_local_3);
            if(_local_4 != null)
            {
               return _local_4;
            }
         }
         return null;
      }
      
      public static function getAllChildren(_arg_1:INode) : Array
      {
         var _local_2:Array = new Array();
         getAllChildrenHelper(_arg_1,_local_2);
         return _local_2;
      }
      
      private static function getAllChildrenHelper(_arg_1:INode, _arg_2:Array) : void
      {
         var _local_3:INode = null;
         for each(_local_3 in _arg_1.children)
         {
            _arg_2.push(_local_3);
            getAllChildrenHelper(_local_3,_arg_2);
         }
      }
      
      public function get root() : INode
      {
         return this._root;
      }
      
      public function set root(_arg_1:INode) : void
      {
         this._root = _arg_1;
      }
      
      public function toArray() : Array
      {
         var _local_1:Array = new Array();
         this.walk(this._root,_local_1);
         return _local_1;
      }
      
      private function walk(_arg_1:INode, _arg_2:Array) : void
      {
         var _local_3:INode = null;
         _arg_2.push(_arg_1);
         for each(_local_3 in _arg_1.children)
         {
            this.walk(_local_3,_arg_2);
         }
      }
      
      public function finalize() : void
      {
         this._root.finalize();
      }
   }
}

