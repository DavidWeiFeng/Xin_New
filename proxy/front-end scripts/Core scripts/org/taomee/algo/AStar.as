package org.taomee.algo
{
   import flash.geom.*;
   
   public class AStar
   {
      
      private static var _instance:AStar;
      
      public static const aroundsData:Array = [new Point(1,0),new Point(0,1),new Point(-1,0),new Point(0,-1),new Point(1,1),new Point(-1,1),new Point(-1,-1),new Point(1,-1)];
      
      private const NOTE_ID:int = 0;
      
      private const NOTE_CLOSED:int = 2;
      
      private const COST_DIAGONAL:int = 14;
      
      private const COST_STRAIGHT:int = 10;
      
      private const NOTE_OPEN:int = 1;
      
      private var _fatherList:Array;
      
      private var _noteMap:Array;
      
      private var _mapModel:IMapModel;
      
      private var _maxTry:int;
      
      private var _nodeList:Array;
      
      private var _openId:int;
      
      private var _openCount:int;
      
      private var _pathScoreList:Array;
      
      private var _openList:Array;
      
      private var _movementCostList:Array;
      
      public function AStar()
      {
         super();
      }
      
      public static function find(_arg_1:Point, _arg_2:Point) : Array
      {
         return getInstance()._find(_arg_1,_arg_2);
      }
      
      private static function getInstance() : AStar
      {
         if(_instance == null)
         {
            _instance = new AStar();
         }
         return _instance;
      }
      
      public static function get maxTry() : int
      {
         return getInstance()._maxTry;
      }
      
      public static function init(_arg_1:IMapModel, _arg_2:int = 1000) : void
      {
         getInstance()._mapModel = _arg_1;
         getInstance()._maxTry = _arg_2;
      }
      
      private function isBlock(_arg_1:Point) : Boolean
      {
         if(_arg_1.x < 0 || _arg_1.x >= this._mapModel.gridX || _arg_1.y < 0 || _arg_1.y >= this._mapModel.gridY)
         {
            return false;
         }
         return this._mapModel.data[_arg_1.x][_arg_1.y];
      }
      
      private function _find(_arg_1:Point, _arg_2:Point) : Array
      {
         var _local_3:int = 0;
         var _local_4:Point = null;
         var _local_5:int = 0;
         var _local_6:int = 0;
         var _local_7:int = 0;
         var _local_8:Array = null;
         var _local_9:Point = null;
         var _local_11:int = 0;
         if(this._mapModel == null)
         {
            return null;
         }
         _arg_1 = this.transPoint(_arg_1);
         var _local_10:Point = this.transPoint(_arg_2.clone());
         if(!this.isBlock(_local_10))
         {
            return null;
         }
         this.initLists();
         this._openCount = 0;
         this._openId = -1;
         this.openNote(_arg_1,0,0,0);
         while(this._openCount > 0)
         {
            if(++_local_11 > this._maxTry)
            {
               this.destroyLists();
               return null;
            }
            _local_3 = int(this._openList[0]);
            this.closeNote(_local_3);
            _local_4 = this._nodeList[_local_3];
            if(_local_10.equals(_local_4))
            {
               return this.getPath(_arg_1,_local_3);
            }
            _local_8 = this.getArounds(_local_4);
            for each(_local_9 in _local_8)
            {
               _local_6 = this._movementCostList[_local_3] + (_local_9.x == _local_4.x || _local_9.y == _local_4.y ? this.COST_STRAIGHT : this.COST_DIAGONAL);
               _local_7 = _local_6 + (Math.abs(_local_10.x - _local_9.x) + Math.abs(_local_10.y - _local_9.y)) * this.COST_STRAIGHT;
               if(this.isOpen(_local_9))
               {
                  _local_5 = int(this._noteMap[_local_9.y][_local_9.x][this.NOTE_ID]);
                  if(_local_6 < this._movementCostList[_local_5])
                  {
                     this._movementCostList[_local_5] = _local_6;
                     this._pathScoreList[_local_5] = _local_7;
                     this._fatherList[_local_5] = _local_3;
                     this.aheadNote(this._openList.indexOf(_local_5) + 1);
                  }
               }
               else
               {
                  this.openNote(_local_9,_local_7,_local_6,_local_3);
               }
            }
         }
         this.destroyLists();
         return null;
      }
      
      private function closeNote(_arg_1:int) : void
      {
         --this._openCount;
         var _local_2:Point = this._nodeList[_arg_1];
         this._noteMap[_local_2.y][_local_2.x][this.NOTE_OPEN] = false;
         this._noteMap[_local_2.y][_local_2.x][this.NOTE_CLOSED] = true;
         if(this._openCount <= 0)
         {
            this._openCount = 0;
            this._openList = [];
            return;
         }
         this._openList[0] = this._openList.pop();
         this.backNote();
      }
      
      private function isOpen(_arg_1:Point) : Boolean
      {
         if(this._noteMap[_arg_1.y] == null)
         {
            return false;
         }
         if(this._noteMap[_arg_1.y][_arg_1.x] == null)
         {
            return false;
         }
         return this._noteMap[_arg_1.y][_arg_1.x][this.NOTE_OPEN];
      }
      
      private function getArounds(_arg_1:Point) : Array
      {
         var _local_2:Point = null;
         var _local_3:Boolean = false;
         var _local_5:int = 0;
         var _local_4:Array = [];
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         var _local_6:Boolean = this.isBlock(_local_2);
         if(_local_6 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         var _local_7:Boolean = this.isBlock(_local_2);
         if(_local_7 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         var _local_8:Boolean = this.isBlock(_local_2);
         if(_local_8 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         var _local_9:Boolean = this.isBlock(_local_2);
         if(_local_9 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         _local_3 = this.isBlock(_local_2);
         if(_local_3 && _local_6 && _local_7 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         _local_3 = this.isBlock(_local_2);
         if(_local_3 && _local_8 && _local_7 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         _local_3 = this.isBlock(_local_2);
         if(_local_3 && _local_8 && _local_9 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         _local_2 = _arg_1.add(aroundsData[_local_5]);
         _local_5++;
         _local_3 = this.isBlock(_local_2);
         if(_local_3 && _local_6 && _local_9 && !this.isClosed(_local_2))
         {
            _local_4.push(_local_2);
         }
         return _local_4;
      }
      
      private function aheadNote(_arg_1:int) : void
      {
         var _local_2:int = 0;
         var _local_3:int = 0;
         while(_arg_1 > 1)
         {
            _local_2 = int(int(_arg_1 / 2));
            if(this.getScore(_arg_1) >= this.getScore(_local_2))
            {
               break;
            }
            _local_3 = int(this._openList[_arg_1 - 1]);
            this._openList[_arg_1 - 1] = this._openList[_local_2 - 1];
            this._openList[_local_2 - 1] = _local_3;
            _arg_1 = _local_2;
         }
      }
      
      private function backNote() : void
      {
         var _local_1:int = 0;
         var _local_2:int = 0;
         var _local_3:int = 1;
         while(true)
         {
            _local_1 = _local_3;
            if(2 * _local_1 <= this._openCount)
            {
               if(this.getScore(_local_3) > this.getScore(2 * _local_1))
               {
                  _local_3 = 2 * _local_1;
               }
               if(2 * _local_1 + 1 <= this._openCount)
               {
                  if(this.getScore(_local_3) > this.getScore(2 * _local_1 + 1))
                  {
                     _local_3 = 2 * _local_1 + 1;
                  }
               }
            }
            if(_local_1 == _local_3)
            {
               break;
            }
            _local_2 = int(this._openList[_local_1 - 1]);
            this._openList[_local_1 - 1] = this._openList[_local_3 - 1];
            this._openList[_local_3 - 1] = _local_2;
         }
      }
      
      private function openNote(_arg_1:Point, _arg_2:int, _arg_3:int, _arg_4:int) : void
      {
         ++this._openCount;
         ++this._openId;
         if(this._noteMap[_arg_1.y] == null)
         {
            this._noteMap[_arg_1.y] = [];
         }
         this._noteMap[_arg_1.y][_arg_1.x] = [];
         this._noteMap[_arg_1.y][_arg_1.x][this.NOTE_OPEN] = true;
         this._noteMap[_arg_1.y][_arg_1.x][this.NOTE_ID] = this._openId;
         this._nodeList.push(_arg_1);
         this._pathScoreList.push(_arg_2);
         this._movementCostList.push(_arg_3);
         this._fatherList.push(_arg_4);
         this._openList.push(this._openId);
         this.aheadNote(this._openCount);
      }
      
      private function eachArray(_arg_1:Point, _arg_2:int, _arg_3:Array) : void
      {
         _arg_1.x *= this._mapModel.gridSize;
         _arg_1.y *= this._mapModel.gridSize;
      }
      
      private function transPoint(_arg_1:Point) : Point
      {
         _arg_1.x = int(_arg_1.x / this._mapModel.gridSize);
         _arg_1.y = int(_arg_1.y / this._mapModel.gridSize);
         return _arg_1;
      }
      
      private function getPath(_arg_1:Point, _arg_2:int) : Array
      {
         var _local_3:Array = [];
         var _local_4:Point = this._nodeList[_arg_2];
         while(!_arg_1.equals(_local_4))
         {
            _local_3.push(_local_4);
            _arg_2 = int(this._fatherList[_arg_2]);
            _local_4 = this._nodeList[_arg_2];
         }
         _local_3.push(_arg_1);
         this.destroyLists();
         _local_3.reverse();
         this.optimize(_local_3);
         _local_3.forEach(this.eachArray);
         return _local_3;
      }
      
      private function getScore(_arg_1:int) : int
      {
         return this._pathScoreList[this._openList[_arg_1 - 1]];
      }
      
      private function initLists() : void
      {
         this._openList = [];
         this._nodeList = [];
         this._pathScoreList = [];
         this._movementCostList = [];
         this._fatherList = [];
         this._noteMap = [];
      }
      
      private function destroyLists() : void
      {
         this._openList = null;
         this._nodeList = null;
         this._pathScoreList = null;
         this._movementCostList = null;
         this._fatherList = null;
         this._noteMap = null;
      }
      
      private function isClosed(_arg_1:Point) : Boolean
      {
         if(this._noteMap[_arg_1.y] == null)
         {
            return false;
         }
         if(this._noteMap[_arg_1.y][_arg_1.x] == null)
         {
            return false;
         }
         return this._noteMap[_arg_1.y][_arg_1.x][this.NOTE_CLOSED];
      }
      
      private function optimize(_arg_1:Array, _arg_2:int = 0) : void
      {
         var _local_3:Point = null;
         var _local_4:int = 0;
         var _local_6:int = 0;
         var _local_7:int = 0;
         var _local_8:Point = null;
         var _local_5:Number = NaN;
         if(_arg_1 == null)
         {
            return;
         }
         var _local_9:int = _arg_1.length - 1;
         if(_local_9 < 2)
         {
            return;
         }
         var _local_10:Point = _arg_1[_arg_2];
         var _local_11:Array = [];
         var _local_12:int = _local_9;
         while(_local_12 > _arg_2)
         {
            _local_3 = _arg_1[_local_12];
            _local_4 = Point.distance(_local_10,_local_3);
            _local_5 = Math.atan2(_local_3.y - _local_10.y,_local_3.x - _local_10.x);
            _local_6 = 1;
            while(_local_6 < _local_4)
            {
               _local_8 = _local_10.add(Point.polar(_local_6,_local_5));
               _local_8.x = int(_local_8.x);
               _local_8.y = int(_local_8.y);
               if(!Boolean(this._mapModel.data[_local_8.x][_local_8.y]))
               {
                  _local_11 = [];
                  break;
               }
               _local_11.push(_local_8);
               _local_6++;
            }
            _local_7 = int(_local_11.length);
            if(_local_7 > 0)
            {
               _arg_1.splice(_arg_2 + 1,_local_12 - _arg_2 - 1);
               _arg_2 += _local_7 - 1;
               break;
            }
            _local_12--;
         }
         if(_arg_2 < _local_9)
         {
            this.optimize(_arg_1,++_arg_2);
         }
      }
   }
}

