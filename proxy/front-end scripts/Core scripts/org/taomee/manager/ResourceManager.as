package org.taomee.manager
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.resource.*;
   import org.taomee.utils.*;
   
   public class ResourceManager
   {
      
      public static const RESOUCE_ERROR:String = "resourceError";
      
      public static const RESOUCE_REFLECT_ERROR:String = "resourceReflectError";
      
      public static const HIGHEST:int = 0;
      
      public static const HIGH:int = 1;
      
      public static const STANDARD:int = 2;
      
      public static const LOW:int = 3;
      
      public static const LOWEST:int = 4;
      
      public static var maxLpt:uint = 2;
      
      public static var maxCache:uint = 300;
      
      private static var _dataList:Array = [];
      
      private static var _loaderList:Array = [];
      
      private static var _cacheList:Array = [];
      
      private static var _cacheMultiList:Array = [];
      
      private static var _isStop:Boolean = false;
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function play() : void
      {
         _isStop = false;
         nextLoad();
      }
      
      private static function cancelEmpl(_arg_1:String, _arg_2:Function = null) : void
      {
         var _local_3:ResLoader = null;
         var _local_4:int = 0;
         var _local_5:int = 0;
         var _local_6:int = 0;
         for each(_local_3 in _loaderList)
         {
            if(_local_3.resInfo.url == _arg_1)
            {
               if(_arg_2 != null)
               {
                  _local_6 = int(_local_3.resInfo.eventList.indexOf(_arg_2));
                  if(_local_6 == -1)
                  {
                     return;
                  }
                  _local_3.resInfo.eventList.splice(_local_6,1);
                  if(_local_3.resInfo.eventList.length > 0)
                  {
                     return;
                  }
               }
               removeLoader(_local_3);
               _local_4 = int(_dataList.length);
               _local_5 = 0;
               while(_local_5 < _local_4)
               {
                  if(_dataList[_local_5].url == _arg_1)
                  {
                     _dataList.splice(_local_5,1);
                     break;
                  }
                  _local_5++;
               }
               nextLoad();
               return;
            }
         }
      }
      
      public static function getResourceList(_arg_1:String, _arg_2:Function, _arg_3:Array, _arg_4:int = 3, _arg_5:Boolean = true) : void
      {
         var _local_6:Array = null;
         var _local_7:Object = null;
         var _local_8:HashMap = null;
         var _local_9:String = null;
         var _local_10:Class = null;
         var _local_11:ResInfo = null;
         var _local_12:ResInfo = null;
         var _local_13:ResLoader = null;
         var _local_14:Boolean = false;
         if(_cacheMultiList.length > 0)
         {
            _local_6 = [];
            for each(_local_7 in _cacheMultiList)
            {
               if(_local_7.url == _arg_1)
               {
                  _local_8 = _local_7.map;
                  for(_local_9 in _arg_3)
                  {
                     _local_10 = _local_8.getValue(_local_9);
                     if(Boolean(_local_10))
                     {
                        if(_local_10 is BitmapData)
                        {
                           _local_6.push(new Bitmap(_local_10 as BitmapData));
                        }
                        else
                        {
                           _local_6.push(new _local_10());
                        }
                     }
                  }
                  break;
               }
            }
            if(_local_6.length == _arg_3.length)
            {
               _arg_2(_local_6);
               return;
            }
         }
         var _local_15:int = int(_dataList.length);
         if(_local_15 > 0)
         {
            for each(_local_11 in _dataList)
            {
               if(_local_11.url == _arg_1)
               {
                  if(_local_11.name == "")
                  {
                     _local_11.eventList.push(_arg_2);
                     _local_14 = true;
                  }
                  break;
               }
            }
         }
         if(!_local_14)
         {
            _local_12 = new ResInfo();
            _local_12.eventList.push(_arg_2);
            _local_12.isCache = _arg_5;
            _local_12.level = _arg_4;
            _local_12.url = _arg_1;
            _arg_3.sort();
            _local_12.nameList = _arg_3;
            _dataList.push(_local_12);
            _dataList.sortOn("level",Array.NUMERIC);
            _local_13 = getEmptyLoader(_arg_4);
            if(Boolean(_local_13))
            {
               _local_13.load(_local_12);
            }
         }
      }
      
      private static function getEmptyLoader(_arg_1:int = 3) : ResLoader
      {
         var _local_2:ResLoader = null;
         var _local_3:int = int(_loaderList.length);
         if(_local_3 < maxLpt)
         {
            _local_2 = new ResLoader();
            _local_2.addEventListener(Event.COMPLETE,onLoadComplete);
            _local_2.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
            _loaderList.push(_local_2);
            return _local_2;
         }
         _loaderList.sortOn("level",Array.NUMERIC | Array.DESCENDING);
         _local_2 = _loaderList[0] as ResLoader;
         if(_arg_1 == HIGHEST)
         {
            _local_2.close();
            return _local_2;
         }
         if(_arg_1 != LOWEST)
         {
            if(_local_2.level == LOWEST)
            {
               _local_2.close();
               return _local_2;
            }
         }
         return null;
      }
      
      private static function onLoadComplete(e:Event) : void
      {
         var resInfo:ResInfo = null;
         var cacheMap:HashMap = null;
         var bd:BitmapData = null;
         var d:Function = null;
         var cla:Class = null;
         var nlen:int = 0;
         var dd:Function = null;
         var outArr:Array = null;
         var nameList:Array = null;
         var resName:String = null;
         var hasURL:Boolean = false;
         var nl:Function = null;
         var n:Function = null;
         resInfo = null;
         cacheMap = null;
         var resLoader:ResLoader = e.target as ResLoader;
         var loaderInfo:LoaderInfo = resLoader.loaderInfo;
         resInfo = resLoader.resInfo;
         var eventList:Array = resInfo.eventList;
         if(loaderInfo.content is Bitmap)
         {
            bd = (loaderInfo.content as Bitmap).bitmapData.clone();
            if(resInfo.isCache)
            {
               _cacheList.push({
                  "url":resInfo.url,
                  "res":bd
               });
            }
            for each(d in eventList)
            {
               d(new Bitmap(bd));
            }
         }
         else if(resInfo.name == "")
         {
            nlen = int(resInfo.nameList.length);
            if(nlen == 0)
            {
               cla = loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(loaderInfo.content)) as Class;
               if(resInfo.isCache)
               {
                  _cacheList.push({
                     "url":resInfo.url,
                     "res":cla
                  });
               }
               for each(dd in eventList)
               {
                  dd(new cla());
               }
            }
            else
            {
               outArr = [];
               cacheMap = new HashMap();
               nameList = resInfo.nameList;
               for each(resName in nameList)
               {
                  if(loaderInfo.applicationDomain.hasDefinition(resName))
                  {
                     cla = loaderInfo.applicationDomain.getDefinition(resName) as Class;
                     if(Boolean(cla))
                     {
                        cacheMap.add(resName,cla);
                        if(cla is BitmapData)
                        {
                           outArr.push(new Bitmap(cla as BitmapData));
                        }
                        else
                        {
                           outArr.push(new cla());
                        }
                     }
                  }
                  else
                  {
                     EventManager.dispatchEvent(new Event(RESOUCE_REFLECT_ERROR));
                  }
               }
               if(resInfo.isCache)
               {
                  hasURL = Boolean(_cacheMultiList.some(function(item:Object, index:int, array:Array):Boolean
                  {
                     var cmap:* = undefined;
                     cmap = undefined;
                     cmap = undefined;
                     if(item.url == resInfo.url)
                     {
                        cmap = item.map;
                        cacheMap.each2(function(_arg_1:*, _arg_2:*):void
                        {
                           cmap.add(_arg_1,_arg_2);
                        });
                        return true;
                     }
                     return false;
                  }));
                  if(!hasURL)
                  {
                     _cacheMultiList.push({
                        "url":resInfo.url,
                        "map":cacheMap
                     });
                  }
               }
               else
               {
                  cacheMap = null;
               }
               if(outArr.length > 0)
               {
                  for each(nl in eventList)
                  {
                     nl(outArr);
                  }
               }
               if(_cacheMultiList.length > maxCache)
               {
                  _cacheMultiList.shift();
               }
            }
         }
         else
         {
            if(loaderInfo.applicationDomain.hasDefinition(resInfo.name))
            {
               cla = loaderInfo.applicationDomain.getDefinition(resInfo.name) as Class;
            }
            else
            {
               EventManager.dispatchEvent(new Event(RESOUCE_REFLECT_ERROR));
            }
            if(Boolean(cla))
            {
               if(resInfo.isCache)
               {
                  _cacheList.push({
                     "url":resInfo.url,
                     "res":cla
                  });
               }
               for each(n in eventList)
               {
                  n(new cla());
               }
            }
         }
         removeLoader(resLoader);
         if(_cacheList.length > maxCache)
         {
            _cacheList.shift();
         }
         ArrayUtil.removeValueFromArray(_dataList,resInfo);
         nextLoad();
      }
      
      public static function stop() : void
      {
         var _local_1:ResLoader = null;
         _isStop = true;
         for each(_local_1 in _loaderList)
         {
            if(_local_1.level == LOWEST)
            {
               removeLoader(_local_1);
            }
         }
      }
      
      public static function cancel(_arg_1:String, _arg_2:Function) : void
      {
         cancelEmpl(_arg_1,_arg_2);
      }
      
      public static function getResource(url:String, event:Function, name:String = "item", level:int = 3, isCache:Boolean = true) : void
      {
         var isHas:Boolean = false;
         var n:Object = null;
         var resInfo:ResInfo = null;
         var resLoader:ResLoader = null;
         if(_cacheList.length > 0)
         {
            for each(n in _cacheList)
            {
               if(n.url == url)
               {
                  if(n.res is BitmapData)
                  {
                     event(new Bitmap(n.res as BitmapData));
                  }
                  else
                  {
                     event(new n.res());
                  }
                  return;
               }
            }
         }
         isHas = Boolean(_dataList.some(function(_arg_1:ResInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1.url == url)
            {
               _arg_1.eventList.push(event);
               return true;
            }
            return false;
         }));
         if(!isHas)
         {
            resInfo = new ResInfo();
            resInfo.eventList.push(event);
            resInfo.isCache = isCache;
            resInfo.level = level;
            resInfo.url = url;
            resInfo.name = name;
            _dataList.push(resInfo);
            _dataList.sortOn("level",Array.NUMERIC);
            resLoader = getEmptyLoader(level);
            if(Boolean(resLoader))
            {
               resLoader.load(resInfo);
            }
         }
      }
      
      public static function cancelURL(_arg_1:String) : void
      {
         cancelEmpl(_arg_1);
      }
      
      public static function cancelAll() : void
      {
         var _local_1:ResLoader = null;
         for each(_local_1 in _loaderList)
         {
            removeLoader(_local_1);
         }
         _loaderList = [];
         _dataList = [];
      }
      
      private static function onIOError(_arg_1:IOErrorEvent) : void
      {
         var _local_2:ResLoader = _arg_1.target as ResLoader;
         var _local_3:ResInfo = _local_2.resInfo;
         removeLoader(_local_2);
         ArrayUtil.removeValueFromArray(_dataList,_local_3);
         nextLoad();
         EventManager.dispatchEvent(new Event(RESOUCE_ERROR));
      }
      
      public static function addBef(_arg_1:String, _arg_2:String = "item", _arg_3:Boolean = true) : void
      {
         var _local_4:ResInfo = null;
         var _local_5:ResInfo = null;
         var _local_6:Boolean = false;
         var _local_7:int = int(_dataList.length);
         if(_local_7 > 0)
         {
            for each(_local_4 in _dataList)
            {
               if(_local_4.url == _arg_1)
               {
                  _local_6 = true;
                  break;
               }
            }
         }
         if(!_local_6)
         {
            _local_5 = new ResInfo();
            _local_5.isCache = _arg_3;
            _local_5.level = LOWEST;
            _local_5.url = _arg_1;
            _local_5.name = _arg_2;
            _dataList.push(_local_5);
         }
      }
      
      private static function removeLoader(_arg_1:ResLoader) : void
      {
         ArrayUtil.removeValueFromArray(_loaderList,_arg_1);
         if(_arg_1.isLoading)
         {
            _arg_1.close();
         }
         _arg_1.removeEventListener(Event.COMPLETE,onLoadComplete);
         _arg_1.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
         _arg_1.destroy();
         _arg_1 = null;
      }
      
      private static function nextLoad() : void
      {
         var _local_1:int = 0;
         var _local_2:ResInfo = null;
         var _local_3:ResLoader = null;
         if(_isStop)
         {
            return;
         }
         var _local_4:int = int(_dataList.length);
         if(_local_4 > 0)
         {
            _local_1 = 0;
            while(_local_1 < _local_4)
            {
               _local_2 = _dataList[_local_1] as ResInfo;
               if(!_local_2.isLoading)
               {
                  _local_3 = getEmptyLoader();
                  if(Boolean(_local_3))
                  {
                     _local_3.load(_local_2);
                  }
                  return;
               }
               _local_1++;
            }
         }
      }
   }
}

