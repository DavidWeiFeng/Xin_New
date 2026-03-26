package com.robot.core.manager
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   
   [Event(name="added",type="com.robot.core.event.PetEvent")]
   [Event(name="removed",type="com.robot.core.event.PetEvent")]
   [Event(name="setDefault",type="com.robot.core.event.PetEvent")]
   [Event(name="cureComplete",type="com.robot.core.event.PetEvent")]
   [Event(name="cureOneComplete",type="com.robot.core.event.PetEvent")]
   [Event(name="updateInfo",type="com.robot.core.event.PetEvent")]
   [Event(name="storageUpdateInfo",type="com.robot.core.event.PetEvent")]
   [Event(name="storageAdded",type="com.robot.core.event.PetEvent")]
   [Event(name="storageRemoved",type="com.robot.core.event.PetEvent")]
   [Event(name="storageList",type="com.robot.core.event.PetEvent")]
   public class PetManager
   {
      
      public static var defaultTime:uint;
      
      public static var currentShowCatchTime:uint;
      
      public static var handleCatchTime:uint;
      
      private static var _isgetdata:Boolean;
      
      private static var _curEndPetInfo:PetInfo;
      
      private static var curRoweiPetInfo:PetListInfo;
      
      private static var curRetrievePetInfo:PetListInfo;
      
      private static var _instance:EventDispatcher;
      
      private static var _bagMap:HashMap = new HashMap();
      
      public static var novicePet:uint = 0;
      
      public static var npcPet:uint = 0;
      
      public static var showInfo:PetInfo = null;
      
      private static var b:Boolean = true;
      
      private static var _storageMap:HashMap = new HashMap();
      
      private static var _exePetListMap:HashMap = new HashMap();
      
      private static var roweiPetMap:HashMap = new HashMap();
      
      public function PetManager()
      {
         super();
      }
      
      public static function checkHandlePet(_arg_1:uint) : void
      {
         if(handleCatchTime > 0)
         {
            _bagMap.remove(handleCatchTime);
            _bagMap.add(_arg_1,null);
            upDate();
            handleCatchTime = 0;
         }
      }
      
      public static function initData(_arg_1:IDataInput, _arg_2:uint) : void
      {
         var _local_3:PetInfo = null;
         var _local_4:int = 0;
         while(_local_4 < _arg_2)
         {
            _local_3 = new PetInfo(_arg_1);
            if(_local_4 == 0)
            {
               _local_3.isDefault = true;
               defaultTime = _local_3.catchTime;
            }
            _bagMap.add(_local_3.catchTime,_local_3);
            _local_4++;
         }
      }
      
      public static function upDate() : void
      {
         var ts:Array = null;
         ts = null;
         var upLoop:Function = function(i:int):void
         {
            var catchTime:uint = 0;
            if(i == length)
            {
               dispatchEvent(new PetEvent(PetEvent.UPDATE_INFO,0));
               ts = null;
               b = true;
               return;
            }
            catchTime = uint(ts[i]);
            SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(_arg_1:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
               var _local_3:PetInfo = _arg_1.data as PetInfo;
               if(_local_3.catchTime == defaultTime)
               {
                  _local_3.isDefault = true;
               }
               if(containsBagForCapTime(_local_3.catchTime))
               {
                  _bagMap.add(_local_3.catchTime,_local_3);
               }
               ++i;
               upLoop(i);
            });
            SocketConnection.send(CommandID.GET_PET_INFO,catchTime);
         };
         if(!b)
         {
            return;
         }
         b = false;
         ts = catchTimes;
         upLoop(0);
      }
      
      public static function add(_arg_1:PetInfo) : void
      {
         if(_bagMap.length >= 6)
         {
            addStorage(_arg_1.id,_arg_1.catchTime);
            return;
         }
         if(_bagMap.length == 0)
         {
            _arg_1.isDefault = true;
            defaultTime = _arg_1.catchTime;
         }
         _bagMap.add(_arg_1.catchTime,_arg_1);
         dispatchEvent(new PetEvent(PetEvent.ADDED,_arg_1.catchTime));
      }
      
      public static function remove(_arg_1:uint) : PetInfo
      {
         var _local_2:PetInfo = _bagMap.remove(_arg_1);
         if(Boolean(_local_2))
         {
            if(Boolean(showInfo))
            {
               if(showInfo.catchTime == _arg_1)
               {
                  showInfo = null;
               }
            }
            dispatchEvent(new PetEvent(PetEvent.REMOVED,_arg_1));
            return _local_2;
         }
         return null;
      }
      
      public static function deletePet(_arg_1:uint) : void
      {
         _bagMap.remove(_arg_1);
         _storageMap.remove(_arg_1);
      }
      
      public static function containsBagForID(id:uint) : Boolean
      {
         var arr:Array = _bagMap.getValues();
         return arr.some(function(_arg_1:PetInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(id == _arg_1.id)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function containsBagForCapTime(cap:uint) : Boolean
      {
         var arr:Array = _bagMap.getValues();
         return arr.some(function(_arg_1:PetInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(cap == _arg_1.catchTime)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getPetInfo(_arg_1:uint) : PetInfo
      {
         return _bagMap.getValue(_arg_1);
      }
      
      public static function get length() : uint
      {
         return _bagMap.length;
      }
      
      public static function get catchTimes() : Array
      {
         return _bagMap.getKeys();
      }
      
      public static function get infos() : Array
      {
         return _bagMap.getValues();
      }
      
      public static function setIn(catchTime:uint, flag:uint, id:uint = 0) : void
      {
         SocketConnection.addCmdListener(CommandID.PET_RELEASE,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_RELEASE,arguments.callee);
            var _local_3:PetTakeOutInfo = _arg_1.data as PetTakeOutInfo;
            if(_local_3.flag == 1)
            {
               add(_local_3.petInfo);
            }
            else
            {
               addStorage(id,catchTime);
            }
            _setDefault(_local_3.firstPetTime);
         });
         SocketConnection.send(CommandID.PET_RELEASE,catchTime,flag);
      }
      
      public static function bagToInStorage(catchTime:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.PET_RELEASE,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_RELEASE,arguments.callee);
            var _local_3:PetTakeOutInfo = _arg_1.data as PetTakeOutInfo;
            var _local_4:PetInfo = remove(catchTime);
            if(Boolean(_local_4))
            {
               addStorage(_local_4.id,_local_4.catchTime);
            }
            _setDefault(_local_3.firstPetTime);
         });
         SocketConnection.send(CommandID.PET_RELEASE,catchTime,0);
      }
      
      public static function storageToInBag(catchTime:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.PET_RELEASE,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_RELEASE,arguments.callee);
            var _local_3:PetTakeOutInfo = _arg_1.data as PetTakeOutInfo;
            removeStorage(catchTime);
            add(_local_3.petInfo);
            _setDefault(_local_3.firstPetTime);
         });
         SocketConnection.send(CommandID.PET_RELEASE,catchTime,1);
      }
      
      public static function setDefault(catchTime:uint, isNet:Boolean = true) : void
      {
         if(defaultTime == catchTime)
         {
            return;
         }
         if(isNet)
         {
            SocketConnection.addCmdListener(CommandID.PET_DEFAULT,function(_arg_1:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.PET_DEFAULT,arguments.callee);
               _setDefault(catchTime);
            });
            SocketConnection.send(CommandID.PET_DEFAULT,catchTime);
         }
         else
         {
            _setDefault(catchTime);
         }
      }
      
      private static function _setDefault(_arg_1:uint) : void
      {
         var _local_2:PetInfo = _bagMap.getValue(defaultTime) as PetInfo;
         if(Boolean(_local_2))
         {
            _local_2.isDefault = false;
         }
         _local_2 = _bagMap.getValue(_arg_1) as PetInfo;
         if(Boolean(_local_2))
         {
            defaultTime = _arg_1;
            _local_2.isDefault = true;
            dispatchEvent(new PetEvent(PetEvent.SET_DEFAULT,defaultTime));
         }
      }
      
      public static function showCurrent() : void
      {
         showPet(currentShowCatchTime);
      }
      
      public static function showPet(_arg_1:uint) : void
      {
         if(_arg_1 == 0)
         {
            _arg_1 = uint(catchTimes[0]);
         }
         currentShowCatchTime = _arg_1;
         var _local_2:PetInfo = _bagMap.getValue(_arg_1);
         if(!_local_2)
         {
            Alarm.show("你还没有精灵");
            return;
         }
         if(showInfo == null)
         {
            showInfo = _local_2;
            SocketConnection.send(CommandID.PET_SHOW,_local_2.catchTime,1);
         }
         else if(showInfo.catchTime == _arg_1)
         {
            showInfo = null;
            SocketConnection.send(CommandID.PET_SHOW,_local_2.catchTime,0);
         }
         else
         {
            SocketConnection.send(CommandID.PET_SHOW,showInfo.catchTime,0);
            showInfo = _local_2;
            SocketConnection.send(CommandID.PET_SHOW,_local_2.catchTime,1);
         }
      }
      
      public static function cureAll(isTip:Boolean = true) : void
      {
         var isCure:Boolean = false;
         _bagMap.eachValue(function(_arg_1:PetInfo):void
         {
            var _local_2:PetSkillInfo = null;
            var _local_3:int = 0;
            if(_arg_1.hp != _arg_1.maxHp)
            {
               isCure = true;
               return;
            }
            while(_local_3 < _arg_1.skillNum)
            {
               _local_2 = _arg_1.skillArray[_local_3] as PetSkillInfo;
               if(_local_2.pp != SkillXMLInfo.getPP(_local_2.id))
               {
                  isCure = true;
                  return;
               }
               _local_3++;
            }
         });
         if(!isCure)
         {
            Alarm.show("你的精灵们不需要恢复体力");
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_CURE,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_CURE,arguments.callee);
            _bagMap.eachValue(function(_arg_1:PetInfo):void
            {
               var _local_2:PetSkillInfo = null;
               var _local_3:int = 0;
               _arg_1.hp = _arg_1.maxHp;
               while(_local_3 < _arg_1.skillNum)
               {
                  _local_2 = _arg_1.skillArray[_local_3] as PetSkillInfo;
                  _local_2.pp = SkillXMLInfo.getPP(_local_2.id);
                  _local_3++;
               }
            });
            dispatchEvent(new PetEvent(PetEvent.CURE_COMPLETE,0));
            if(isTip)
            {
               Alarm.show("已花费50个骄阳豆使你的精灵重新充满活力了");
            }
            MainManager.actorInfo.coins -= 50;
         });
         SocketConnection.send(CommandID.PET_CURE);
      }
      
      public static function cure(catchTime:uint) : void
      {
         var i:int = 0;
         var info:PetSkillInfo = null;
         var isCure:Boolean = false;
         var petInfo:PetInfo = _bagMap.getValue(catchTime);
         if(!petInfo)
         {
            Alarm.show("没有找到精灵");
            return;
         }
         if(petInfo.hp != petInfo.maxHp)
         {
            isCure = true;
         }
         i = 0;
         while(i < petInfo.skillNum)
         {
            info = petInfo.skillArray[i] as PetSkillInfo;
            if(info.pp != SkillXMLInfo.getPP(info.id))
            {
               isCure = true;
               break;
            }
            i += 1;
         }
         if(!isCure)
         {
            Alarm.show("你的精灵不需要恢复体力");
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_ONE_CURE,function(_arg_1:SocketEvent):void
         {
            var _local_3:int = 0;
            var _local_4:PetSkillInfo = null;
            SocketConnection.removeCmdListener(CommandID.PET_ONE_CURE,arguments.callee);
            var _local_5:ByteArray = _arg_1.data as ByteArray;
            var _local_6:uint = _local_5.readUnsignedInt();
            var _local_7:PetInfo = _bagMap.getValue(_local_6);
            if(Boolean(_local_7))
            {
               _local_7.hp = _local_7.maxHp;
               _local_3 = 0;
               while(_local_3 < _local_7.skillNum)
               {
                  _local_4 = _local_7.skillArray[_local_3] as PetSkillInfo;
                  _local_4.pp = SkillXMLInfo.getPP(_local_4.id);
                  _local_3++;
               }
            }
            dispatchEvent(new PetEvent(PetEvent.CURE_ONE_COMPLETE,_local_6));
            MainManager.actorInfo.coins -= 20;
         });
         SocketConnection.send(CommandID.PET_ONE_CURE,catchTime);
      }
      
      public static function get storageLength() : int
      {
         return _storageMap.length - _bagMap.length;
      }
      
      public static function get allLength() : int
      {
         return _storageMap.length;
      }
      
      public static function getAll() : Array
      {
         var _local_1:int = 0;
         var _local_2:PetListInfo = null;
         var _local_3:Array = _storageMap.getValues();
         if(_bagMap.length > 0)
         {
            _local_1 = 0;
            while(_local_1 < _bagMap.length)
            {
               if(containsStorageForCapTime((_bagMap.getValues()[_local_1] as PetInfo).catchTime) == false)
               {
                  _local_2 = new PetListInfo();
                  _local_2.catchTime = (_bagMap.getValues()[_local_1] as PetInfo).catchTime;
                  _local_2.id = (_bagMap.getValues()[_local_1] as PetInfo).id;
                  _local_3.push(_local_2);
               }
               _local_1++;
            }
         }
         return _local_3;
      }
      
      public static function getCanExePetList() : Array
      {
         var _local_1:int = 0;
         var _local_2:int = 0;
         var _local_3:PetListInfo = null;
         var _local_4:Array = _storageMap.getValues();
         if(Boolean(_local_4))
         {
            _local_1 = 0;
            while(_local_1 < _local_4.length)
            {
               if((_local_4[_local_1] as PetListInfo).course != 0)
               {
                  _local_4.splice(_local_1,1);
                  _local_1--;
               }
               _local_1++;
            }
         }
         if(_bagMap.length > 0)
         {
            _local_2 = 0;
            while(_local_2 < _bagMap.length)
            {
               if(containsStorageForCapTime((_bagMap.getValues()[_local_2] as PetInfo).catchTime) == false)
               {
                  _local_3 = new PetListInfo();
                  _local_3.catchTime = (_bagMap.getValues()[_local_2] as PetInfo).catchTime;
                  _local_3.id = (_bagMap.getValues()[_local_2] as PetInfo).id;
                  _local_4.push(_local_3);
               }
               _local_2++;
            }
         }
         return _local_4;
      }
      
      public static function getStorage() : Array
      {
         var arr:Array = _storageMap.getValues();
         return arr.filter(function(_arg_1:PetListInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(!_bagMap.containsKey(_arg_1.catchTime))
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getStorageList() : void
      {
         if(_isgetdata)
         {
            dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_PET_LIST,function(_arg_1:SocketEvent):void
         {
            var _local_3:PetListInfo = null;
            var _local_6:int = 0;
            SocketConnection.removeCmdListener(CommandID.GET_PET_LIST,arguments.callee);
            var _local_4:ByteArray = _arg_1.data as ByteArray;
            var _local_5:uint = _local_4.readUnsignedInt();
            while(_local_6 < _local_5)
            {
               _local_3 = new PetListInfo(_local_4);
               _storageMap.add(_local_3.catchTime,_local_3);
               _local_6++;
            }
            if(MainManager.actorInfo.hasNono)
            {
               if(Boolean(NonoManager.info))
               {
                  if(Boolean(NonoManager.info.func[3]))
                  {
                     getExePetList();
                  }
                  else
                  {
                     _isgetdata = true;
                     dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
                  }
               }
               else
               {
                  _isgetdata = true;
                  dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
               }
            }
            else
            {
               _isgetdata = true;
               dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
            }
         });
         SocketConnection.send(CommandID.GET_PET_LIST);
      }
      
      private static function getExePetList() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_EXE_LIST,onGetListSucHandler);
         SocketConnection.send(CommandID.NONO_EXE_LIST);
      }
      
      private static function onGetListSucHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:int = 0;
         var _local_3:ExeingPetInfo = null;
         var _local_4:PetListInfo = null;
         SocketConnection.removeCmdListener(CommandID.NONO_EXE_LIST,onGetListSucHandler);
         var _local_5:ByteArray = _arg_1.data as ByteArray;
         var _local_6:uint = _local_5.readUnsignedInt();
         if(_local_6 > 0)
         {
            _local_2 = 0;
            while(_local_2 < _local_6)
            {
               _local_3 = new ExeingPetInfo(_local_5);
               _exePetListMap.add(_local_3._capTm,_local_3);
               _local_4 = new PetListInfo();
               _local_4.id = _local_3._petId;
               _local_4.catchTime = _local_3._capTm;
               _local_4.course = _local_3._course;
               _storageMap.add(_local_3._capTm,_local_4);
               if(containsBagForCapTime(_local_3._capTm))
               {
                  _bagMap.remove(_local_3._capTm);
               }
               _local_2++;
            }
         }
         _isgetdata = true;
         dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
      }
      
      public static function get exePetListMap() : HashMap
      {
         return _exePetListMap;
      }
      
      public static function getBagMap() : Array
      {
         var _local_1:Array = null;
         var _local_2:int = 0;
         var _local_3:PetListInfo = null;
         if(Boolean(_bagMap))
         {
            if(_bagMap.getValues().length <= 0)
            {
               return [];
            }
            _local_1 = new Array();
            _local_2 = 0;
            while(_local_2 < _bagMap.getValues().length)
            {
               _local_3 = new PetListInfo();
               _local_3.catchTime = (_bagMap.getValues()[_local_2] as PetInfo).catchTime;
               _local_3.id = (_bagMap.getValues()[_local_2] as PetInfo).id;
               _local_1.push(_local_3);
               _local_2++;
            }
            return _local_1;
         }
         return [];
      }
      
      public static function startExePet(capTime:uint, type:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_START_EXE,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.NONO_START_EXE,arguments.callee);
            var _local_3:ByteArray = _arg_1.data as ByteArray;
            var _local_4:Number = _local_3.readUnsignedInt();
            var _local_5:Number = _local_3.readUnsignedInt();
            var _local_6:Number = _local_3.readUnsignedInt();
            var _local_7:Number = _local_3.readUnsignedInt();
            var _local_8:ExeingPetInfo = new ExeingPetInfo();
            _local_8._flag = 0;
            _local_8._capTm = _local_4;
            _local_8._petId = _local_5;
            _local_8._remainDay = _local_7 * 24;
            _local_8._course = _local_7;
            _exePetListMap.add(_local_8._capTm,_local_8);
            var _local_9:PetListInfo = new PetListInfo();
            _local_9.id = _local_8._petId;
            _local_9.catchTime = _local_8._capTm;
            _local_9.course = _local_8._course;
            _storageMap.add(_local_8._capTm,_local_9);
            if(containsBagForCapTime(_local_8._capTm))
            {
               _bagMap.remove(_local_8._capTm);
            }
            dispatchEvent(new PetEvent(PetEvent.START_EXE_PET,0));
         });
         SocketConnection.send(CommandID.NONO_START_EXE,capTime,type);
      }
      
      public static function stopExePet(id:uint, cap:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_END_EXE,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.NONO_END_EXE,arguments.callee);
            var _local_3:ByteArray = _arg_1.data as ByteArray;
            var _local_4:uint = _local_3.readUnsignedInt();
            if(_local_4 == 0)
            {
               Alarm.show("训练完成，你的精灵已经回到仓库中！");
            }
            else
            {
               Alarm.show("训练完成，你的精灵获得了 " + TextFormatUtil.getRedTxt(_local_4.toString()) + " 经验！");
            }
            _exePetListMap.remove(cap);
            var _local_5:PetListInfo = new PetListInfo();
            _local_5.id = id;
            _local_5.catchTime = cap;
            _local_5.course = 0;
            _storageMap.add(_local_5.catchTime,_local_5);
            if(containsBagForCapTime(_local_5.catchTime))
            {
               _bagMap.remove(_local_5.catchTime);
            }
            dispatchEvent(new PetEvent(PetEvent.STOP_EXE_PET,0));
         });
         SocketConnection.send(CommandID.NONO_END_EXE,cap);
      }
      
      public static function set curEndPetInfo(_arg_1:PetInfo) : void
      {
         _curEndPetInfo = _arg_1;
      }
      
      public static function get curEndPetInfo() : PetInfo
      {
         return _curEndPetInfo;
      }
      
      public static function getRoweiPetList() : void
      {
         roweiPetMap.clear();
         SocketConnection.addCmdListener(CommandID.PET_ROWEI_LIST,onRoweiListHandler);
         SocketConnection.send(CommandID.PET_ROWEI_LIST);
      }
      
      private static function onRoweiListHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:PetListInfo = null;
         var _local_5:int = 0;
         SocketConnection.removeCmdListener(CommandID.PET_ROWEI_LIST,onRoweiListHandler);
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         while(_local_5 < _local_4)
         {
            _local_2 = new PetListInfo(_local_3);
            roweiPetMap.add(_local_2.catchTime,_local_2);
            _local_5++;
         }
         dispatchEvent(new PetEvent(PetEvent.GET_ROWEI_PET_LIST,0));
      }
      
      public static function get roweiPetLength() : uint
      {
         return roweiPetMap.length;
      }
      
      public static function getRoweiTypeList(t:uint) : Array
      {
         var arr:Array = roweiPetMap.getValues();
         return arr.filter(function(_arg_1:PetListInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(PetXMLInfo.getType(_arg_1.id) == t.toString())
            {
               return true;
            }
            return false;
         });
      }
      
      public static function roweiPet(_arg_1:uint, _arg_2:uint) : void
      {
         curRoweiPetInfo = new PetListInfo();
         curRoweiPetInfo.id = _arg_1;
         curRoweiPetInfo.catchTime = _arg_2;
         SocketConnection.addCmdListener(CommandID.PET_ROWEI,onRoweiPetSuccessHandler);
         SocketConnection.send(CommandID.PET_ROWEI,_arg_1,_arg_2);
      }
      
      public static function onRoweiPetSuccessHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_ROWEI,onRoweiPetSuccessHandler);
         _storageMap.remove(curRoweiPetInfo.catchTime);
         roweiPetMap.add(curRoweiPetInfo.catchTime,curRoweiPetInfo);
         dispatchEvent(new PetEvent(PetEvent.ROWEI_PET,curRoweiPetInfo.catchTime));
      }
      
      public static function retrievePet(_arg_1:uint, _arg_2:uint) : void
      {
         curRetrievePetInfo = new PetListInfo();
         curRetrievePetInfo.id = _arg_1;
         curRetrievePetInfo.catchTime = _arg_2;
         SocketConnection.addCmdListener(CommandID.PET_RETRIEVE,onRetrievePetSuccessHandler);
         SocketConnection.send(CommandID.PET_RETRIEVE,_arg_2);
      }
      
      private static function onRetrievePetSuccessHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_RETRIEVE,onRetrievePetSuccessHandler);
         _storageMap.add(curRetrievePetInfo.catchTime,curRetrievePetInfo);
         roweiPetMap.remove(curRetrievePetInfo.catchTime);
         dispatchEvent(new PetEvent(PetEvent.RETRIEVE_PET,curRetrievePetInfo.catchTime));
      }
      
      public static function storageUpDate(catchTime:uint, event:Function) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
            event(_arg_1.data as PetInfo);
         });
         SocketConnection.send(CommandID.GET_PET_INFO,catchTime);
      }
      
      public static function getStorageTypeList(t:uint) : Array
      {
         var arr:Array = getStorage();
         return arr.filter(function(_arg_1:PetListInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(PetXMLInfo.getType(_arg_1.id) == t.toString())
            {
               return true;
            }
            return false;
         });
      }
      
      public static function addStorage(_arg_1:uint, _arg_2:uint) : void
      {
         var _local_3:PetListInfo = new PetListInfo();
         _local_3.id = _arg_1;
         _local_3.catchTime = _arg_2;
         _storageMap.add(_arg_2,_local_3);
         dispatchEvent(new PetEvent(PetEvent.STORAGE_ADDED,_arg_2));
      }
      
      public static function removeStorage(_arg_1:uint) : PetListInfo
      {
         var _local_2:PetListInfo = _storageMap.remove(_arg_1);
         if(Boolean(_local_2))
         {
            dispatchEvent(new PetEvent(PetEvent.STORAGE_REMOVED,_arg_1));
            return _local_2;
         }
         return null;
      }
      
      public static function containsStorageForID(id:uint) : Boolean
      {
         var arr:Array = _storageMap.getValues();
         return arr.some(function(_arg_1:PetListInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(id == _arg_1.id)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function containsStorageForCapTime(cap:uint) : Boolean
      {
         var arr:Array = _storageMap.getValues();
         return arr.some(function(_arg_1:PetListInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(cap == _arg_1.catchTime)
            {
               return true;
            }
            return false;
         });
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener(_arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener(_arg_1,_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:Event) : void
      {
         if(hasEventListener(_arg_1.type))
         {
            getInstance().dispatchEvent(_arg_1);
         }
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
      
      public static function willTrigger(_arg_1:String) : Boolean
      {
         return getInstance().willTrigger(_arg_1);
      }
   }
}

