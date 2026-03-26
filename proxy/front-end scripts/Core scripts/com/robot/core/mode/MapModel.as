package com.robot.core.mode
{
   import com.robot.core.aimat.*;
   import com.robot.core.config.*;
   import com.robot.core.controller.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.loading.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.algo.*;
   import org.taomee.utils.*;
   
   public class MapModel implements IMapModel
   {
      
      private var _id:uint;
      
      private var _width:int = 960;
      
      private var _height:int = 560;
      
      private var _gridSize:uint = 10;
      
      private var _gridX:uint;
      
      private var _gridY:uint;
      
      private var _gridTotal:uint;
      
      private var _data:Array;
      
      private var _depthLevel:DisplayObjectContainer;
      
      private var _typeLevel:DisplayObjectContainer;
      
      private var _topLevel:DisplayObjectContainer;
      
      private var _root:DisplayObjectContainer;
      
      private var _spaceLevel:Sprite;
      
      private var _backLevel:DisplayObjectContainer;
      
      private var _controlLevel:DisplayObjectContainer;
      
      private var _btnLevel:DisplayObjectContainer;
      
      private var _animatorLevel:DisplayObjectContainer;
      
      private var _loader:MCLoader;
      
      private var _timeoutID:uint;
      
      private var _isCanClose:Boolean = true;
      
      private var _allowData:Array = new Array();
      
      private var isSwitching:Boolean = false;
      
      public function MapModel(_arg_1:uint, _arg_2:Boolean = true, _arg_3:Boolean = true)
      {
         super();
         this._isCanClose = _arg_2;
         this._id = _arg_1;
         this.loadMap(_arg_3);
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this._root;
      }
      
      public function get topLevel() : DisplayObjectContainer
      {
         return this._topLevel;
      }
      
      public function get typeLevel() : DisplayObjectContainer
      {
         return this._typeLevel;
      }
      
      public function get depthLevel() : DisplayObjectContainer
      {
         return this._depthLevel;
      }
      
      public function get backLevel() : DisplayObjectContainer
      {
         return this._backLevel;
      }
      
      public function get spaceLevel() : DisplayObjectContainer
      {
         return this._spaceLevel;
      }
      
      public function get controlLevel() : DisplayObjectContainer
      {
         return this._controlLevel;
      }
      
      public function get btnLevel() : DisplayObjectContainer
      {
         return this._btnLevel;
      }
      
      public function get animatorLevel() : DisplayObjectContainer
      {
         return this._animatorLevel;
      }
      
      public function get width() : int
      {
         return this._spaceLevel.width;
      }
      
      public function get height() : int
      {
         return this._spaceLevel.height;
      }
      
      public function get gridSize() : uint
      {
         return this._gridSize;
      }
      
      public function get gridX() : uint
      {
         return this._gridX;
      }
      
      public function get gridY() : uint
      {
         return this._gridY;
      }
      
      public function get gridTotal() : uint
      {
         return this._gridTotal;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function get allowData() : Array
      {
         return this._allowData;
      }
      
      public function addUser(_arg_1:BasePeoleModel) : void
      {
         var _local_2:uint = _arg_1.info.userID;
         if(!UserManager.contains(_local_2))
         {
            UserManager.addUser(_local_2,_arg_1);
            if(Boolean(_arg_1.pet))
            {
               _arg_1.pet.visible = !UserManager._hideOtherUserModelFlag;
            }
            if(!UserManager._hideOtherUserModelFlag)
            {
               this._depthLevel.addChild(_arg_1);
            }
         }
      }
      
      public function switchOtherUserVisible() : void
      {
         var _local_1:BasePeoleModel = null;
         if(this.isSwitching)
         {
            return;
         }
         this.isSwitching = true;
         UserManager._hideOtherUserModelFlag = !UserManager._hideOtherUserModelFlag;
         for each(_local_1 in UserManager.getUserModelList())
         {
            if(UserManager._hideOtherUserModelFlag)
            {
               this.hideUser(_local_1);
            }
            else
            {
               this.showUser(_local_1);
            }
         }
         this.isSwitching = false;
      }
      
      public function hideUser(_arg_1:BasePeoleModel) : void
      {
         if(_arg_1.info.userID != MainManager.actorID)
         {
            if(Boolean(_arg_1.pet))
            {
               _arg_1.pet.setVisible(false);
            }
            DisplayUtil.removeForParent(_arg_1,false);
         }
      }
      
      public function showUser(_arg_1:BasePeoleModel) : void
      {
         if(_arg_1.info.userID != MainManager.actorID)
         {
            if(Boolean(_arg_1.pet))
            {
               _arg_1.pet.setVisible(true);
            }
            this._depthLevel.addChild(_arg_1);
         }
      }
      
      public function removeUser(_arg_1:uint) : void
      {
         var _local_2:BasePeoleModel = UserManager.removeUser(_arg_1);
         if(Boolean(_local_2))
         {
            _local_2.stop();
            if(this._depthLevel.contains(_local_2))
            {
               this._depthLevel.removeChild(_local_2);
            }
            UserManager.dispatchEvent(new UserEvent(UserEvent.REMOVED_FROM_MAP,_local_2.info));
            _local_2.destroy();
            _local_2 = null;
         }
      }
      
      public function closeChange() : void
      {
         this._loader.clear();
         this._loader = null;
      }
      
      public function destroy() : void
      {
         var _local_1:PeopleModel = null;
         var _local_2:Array = UserManager.getUserModelList();
         for each(_local_1 in _local_2)
         {
            _local_1.stop();
            _local_1.destroy();
            _local_1 = null;
         }
         UserManager.clear();
         AimatController.destroy();
         DisplayUtil.removeAllChild(this._root);
         this._data = null;
         this._loader.clear();
         this._loader = null;
         this._backLevel = null;
         this._depthLevel = null;
         this._typeLevel = null;
         this._topLevel = null;
         this._root = null;
         this._spaceLevel = null;
         this._controlLevel = null;
         this._btnLevel = null;
      }
      
      public function isBlock(_arg_1:Point) : Boolean
      {
         var _local_2:int = int(int(_arg_1.x / this._gridSize));
         var _local_3:int = int(int(_arg_1.y / this._gridSize));
         if(_local_2 < 0 || _local_2 >= this._gridX || _local_3 < 0 || _local_3 >= this._gridY)
         {
            return false;
         }
         return this._data[_local_2][_local_3];
      }
      
      public function closeLoading() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.closeLoading();
         }
      }
      
      public function makeMapArray() : void
      {
         var _local_1:uint = 0;
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_4:Point = new Point();
         var _local_5:BitmapData = new BitmapData(this.width,this.height,true,0);
         _local_5.draw(this._typeLevel);
         this._data = new Array(this._gridX);
         _local_1 = uint(uint(int(this._gridSize / 2)));
         _local_2 = 0;
         while(_local_2 < this._gridX)
         {
            this._data[_local_2] = new Array(this._gridY);
            _local_3 = 0;
            while(_local_3 < this._gridY)
            {
               if(Boolean(_local_5.getPixel32(_local_2 * this._gridSize + _local_1,_local_3 * this._gridSize + _local_1)))
               {
                  this._data[_local_2][_local_3] = false;
               }
               else
               {
                  this._data[_local_2][_local_3] = true;
                  this._allowData.push(new Point(_local_2 * this._gridSize,_local_3 * this._gridSize));
               }
               _local_3++;
            }
            _local_2++;
         }
         _local_4 = null;
         _local_5.dispose();
         _local_5 = null;
      }
      
      private function loadMap(isShowLoading:Boolean) : void
      {
         var type:int = 0;
         isShowLoading = true;
         if(this._loader == null)
         {
            if(MainManager.actorInfo.mapID <= 9 && this._id > 9 && this._id < 100)
            {
               if(isShowLoading)
               {
                  type = Loading.TITLE_AND_PERCENT;
               }
               else
               {
                  type = Loading.NO_ALL;
               }
               this._loader = new MCLoader("",LevelManager.topLevel,type,"加载地图",false);
            }
            else
            {
               if(isShowLoading)
               {
                  type = Loading.TITLE_AND_PERCENT;
               }
               else
               {
                  type = Loading.NO_ALL;
               }
               this._loader = new MCLoader("",LevelManager.topLevel,type,"加载地图",false);
            }
         }
         this._loader.setIsShowClose(this._isCanClose);
         this._loader.addEventListener(MCLoadEvent.SUCCESS,this.onMapComplete);
         this._loader.addEventListener(MCLoadEvent.ERROR,this.onMapError);
         this._loader.addEventListener(MCLoadEvent.CLOSE,this.onMapClose);
         this._loader.doLoad(ClientConfig.getMapPath(MapManager.getResMapID(this._id)));
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_LOADER_OPEN));
      }
      
      private function onMapComplete(_arg_1:MCLoadEvent) : void
      {
         var _local_2:DisplayObject = null;
         this._loader.removeEventListener(MCLoadEvent.SUCCESS,this.onMapComplete);
         this._loader.removeEventListener(MCLoadEvent.ERROR,this.onMapError);
         this._loader.removeEventListener(MCLoadEvent.CLOSE,this.onMapClose);
         MapLibManager.setup(_arg_1.getLoader());
         this._root = _arg_1.getContent().root as DisplayObjectContainer;
         this._depthLevel = this._root["depth_mc"];
         this._typeLevel = this._root["type_mc"];
         this._topLevel = this._root["top_mc"];
         this._controlLevel = this._root["control_mc"];
         this._btnLevel = this._root["buttonLevel"];
         this._animatorLevel = this._root["animator_mc"];
         var _local_3:Sprite = this._root["rect_mc"];
         if(Boolean(_local_3))
         {
            this._spaceLevel = _local_3;
            this._spaceLevel.alpha = 0;
         }
         else
         {
            this._spaceLevel = this.creatRect();
         }
         this._backLevel = this._root["bg_mc"];
         this._root.addChildAt(this._backLevel,0);
         this._root.addChildAt(this._spaceLevel,1);
         if(Boolean(this._animatorLevel))
         {
            this._animatorLevel.mouseEnabled = false;
            this._animatorLevel.mouseChildren = false;
         }
         if(MapController.isReMap)
         {
            _local_2 = this._topLevel["title_mc"];
            if(Boolean(_local_2))
            {
               DisplayUtil.removeForParent(_local_2);
            }
         }
         this._spaceLevel.mouseChildren = false;
         this._depthLevel.mouseEnabled = false;
         this._controlLevel.mouseEnabled = false;
         this._btnLevel.mouseEnabled = false;
         this._typeLevel.mouseChildren = false;
         this._typeLevel.mouseEnabled = false;
         this._topLevel.mouseEnabled = false;
         this._gridX = int(this.width / this._gridSize);
         this._gridY = int(this.height / this._gridSize);
         this._gridTotal = this._gridX * this._gridY;
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_LOADER_COMPLETE));
         this.initFindPath();
      }
      
      private function onMapClose(_arg_1:MCLoadEvent) : void
      {
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_LOADER_CLOSE));
      }
      
      private function onMapError(_arg_1:MCLoadEvent) : void
      {
         this._loader.removeEventListener(MCLoadEvent.SUCCESS,this.onMapComplete);
         this._loader.removeEventListener(MCLoadEvent.ERROR,this.onMapError);
         this._loader.removeEventListener(MCLoadEvent.CLOSE,this.onMapClose);
         this._loader.clear();
         this._loader = null;
         MapManager.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
      
      private function initFindPath() : void
      {
         this._timeoutID = setTimeout(this.onMakMap,200);
      }
      
      private function onMakMap() : void
      {
         if(this._timeoutID != 0)
         {
            clearTimeout(this._timeoutID);
         }
         this.makeMapArray();
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_INIT));
      }
      
      private function creatRect() : Sprite
      {
         var _local_1:Sprite = new Sprite();
         _local_1.graphics.beginFill(0,0);
         _local_1.graphics.drawRect(0,0,this._width,this._height);
         _local_1.graphics.endFill();
         return _local_1;
      }
      
      private function creatBitmap(_arg_1:DisplayObjectContainer) : Bitmap
      {
         var _local_2:Bitmap = new Bitmap();
         var _local_3:BitmapData = new BitmapData(this.width,this.height);
         _local_3.draw(_arg_1);
         _local_2.bitmapData = _local_3;
         DisplayUtil.removeForParent(_arg_1);
         return _local_2;
      }
   }
}

