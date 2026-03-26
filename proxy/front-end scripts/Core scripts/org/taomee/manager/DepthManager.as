package org.taomee.manager
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.*;
   
   public class DepthManager
   {
      
      private static var managers:Dictionary;
      
      private var depths:Dictionary;
      
      public function DepthManager()
      {
         super();
         this.depths = new Dictionary(true);
      }
      
      public static function swapDepth(_arg_1:DisplayObject, _arg_2:Number) : int
      {
         return getManager(_arg_1.parent).swapChildDepth(_arg_1,_arg_2);
      }
      
      public static function swapDepthAll(doc:DisplayObjectContainer) : void
      {
         var dm:DepthManager = null;
         var child:DisplayObject = null;
         var i:int = 0;
         dm = null;
         dm = getManager(doc);
         var len:int = doc.numChildren;
         var arr:Array = [];
         i = 0;
         while(i < len)
         {
            child = doc.getChildAt(i);
            arr.push(child);
            i += 1;
         }
         arr.sortOn("y",Array.NUMERIC);
         arr.forEach(function(_arg_1:DisplayObject, _arg_2:int, _arg_3:Array):void
         {
            doc.setChildIndex(_arg_1,_arg_2);
            dm.setDepth(_arg_1,_arg_1.y);
         });
         arr = null;
      }
      
      public static function clearAll() : void
      {
         managers = null;
      }
      
      public static function getManager(_arg_1:DisplayObjectContainer) : DepthManager
      {
         if(!managers)
         {
            managers = new Dictionary(true);
         }
         var _local_2:DepthManager = managers[_arg_1];
         if(!_local_2)
         {
            _local_2 = new DepthManager();
            managers[_arg_1] = _local_2;
         }
         return _local_2;
      }
      
      public static function bringToBottom(_arg_1:DisplayObject) : void
      {
         var _local_2:DisplayObjectContainer = _arg_1.parent;
         if(_local_2 == null)
         {
            return;
         }
         if(_local_2.getChildIndex(_arg_1) != 0)
         {
            _local_2.setChildIndex(_arg_1,0);
         }
      }
      
      public static function clear(_arg_1:DisplayObjectContainer) : void
      {
         delete managers[_arg_1];
      }
      
      public static function bringToTop(_arg_1:DisplayObject) : void
      {
         var _local_2:DisplayObjectContainer = _arg_1.parent;
         if(_local_2 == null)
         {
            return;
         }
         _local_2.addChild(_arg_1);
      }
      
      public function setDepth(_arg_1:DisplayObject, _arg_2:Number) : void
      {
         this.depths[_arg_1] = _arg_2;
      }
      
      private function countDepth(_arg_1:DisplayObject, _arg_2:int, _arg_3:Number = 0) : Number
      {
         if(this.depths[_arg_1] == null)
         {
            if(_arg_2 == 0)
            {
               return 0;
            }
            return this.countDepth(_arg_1.parent.getChildAt(_arg_2 - 1),_arg_2 - 1,_arg_3 + 1);
         }
         return this.depths[_arg_1] + _arg_3;
      }
      
      public function swapChildDepth(_arg_1:DisplayObject, _arg_2:Number) : int
      {
         var _local_3:int = 0;
         var _local_9:int = 0;
         var _local_13:int = 0;
         var _local_4:Number = NaN;
         var _local_5:DisplayObjectContainer = _arg_1.parent;
         if(_local_5 == null)
         {
            throw new Error("child is not in a container!!");
         }
         var _local_6:int = _local_5.getChildIndex(_arg_1);
         var _local_7:Number = this.getDepth(_arg_1);
         if(_arg_2 == _local_7)
         {
            this.setDepth(_arg_1,_arg_2);
            return _local_6;
         }
         var _local_8:int = _local_5.numChildren;
         if(_local_8 < 2)
         {
            this.setDepth(_arg_1,_arg_2);
            return _local_6;
         }
         if(_arg_2 < this.getDepth(_local_5.getChildAt(0)))
         {
            _local_5.setChildIndex(_arg_1,0);
            this.setDepth(_arg_1,_arg_2);
            return 0;
         }
         if(_arg_2 >= this.getDepth(_local_5.getChildAt(_local_8 - 1)))
         {
            _local_5.setChildIndex(_arg_1,_local_8 - 1);
            this.setDepth(_arg_1,_arg_2);
            return _local_8 - 1;
         }
         var _local_10:int = _local_8 - 1;
         if(_arg_2 > _local_7)
         {
            _local_9 = _local_6;
            _local_10 = _local_8 - 1;
         }
         else
         {
            _local_9 = 0;
            _local_10 = _local_6;
         }
         while(_local_10 > _local_9 + 1)
         {
            _local_3 = int(_local_9 + (_local_10 - _local_9) / 2);
            _local_4 = this.getDepth(_local_5.getChildAt(_local_3));
            if(_local_4 > _arg_2)
            {
               _local_10 = _local_3;
            }
            else
            {
               if(_local_4 >= _arg_2)
               {
                  _local_5.setChildIndex(_arg_1,_local_3);
                  this.setDepth(_arg_1,_arg_2);
                  return _local_3;
               }
               _local_9 = _local_3;
            }
         }
         var _local_11:Number = this.getDepth(_local_5.getChildAt(_local_9));
         var _local_12:Number = this.getDepth(_local_5.getChildAt(_local_10));
         if(_arg_2 >= _local_12)
         {
            if(_local_6 <= _local_10)
            {
               _local_13 = Math.min(_local_10,_local_8 - 1);
            }
            else
            {
               _local_13 = Math.min(_local_10 + 1,_local_8 - 1);
            }
         }
         else if(_arg_2 < _local_11)
         {
            if(_local_6 < _local_9)
            {
               _local_13 = Math.max(_local_9 - 1,0);
            }
            else
            {
               _local_13 = _local_9;
            }
         }
         else if(_local_6 <= _local_9)
         {
            _local_13 = _local_9;
         }
         else
         {
            _local_13 = Math.min(_local_9 + 1,_local_8 - 1);
         }
         _local_5.setChildIndex(_arg_1,_local_13);
         this.setDepth(_arg_1,_arg_2);
         return _local_13;
      }
      
      public function getDepth(_arg_1:DisplayObject) : Number
      {
         if(this.depths[_arg_1] == null)
         {
            return this.countDepth(_arg_1,_arg_1.parent.getChildIndex(_arg_1),0);
         }
         return this.depths[_arg_1];
      }
   }
}

