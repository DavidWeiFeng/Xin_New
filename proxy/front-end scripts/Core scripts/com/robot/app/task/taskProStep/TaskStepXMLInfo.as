package com.robot.app.task.taskProStep
{
   import com.robot.core.manager.*;
   import org.taomee.ds.*;
   
   public class TaskStepXMLInfo
   {
      
      private static var _taskStepXML:XML;
      
      private static var _dataMap:HashMap;
      
      public function TaskStepXMLInfo()
      {
         super();
      }
      
      public static function setup(_arg_1:XML) : void
      {
         var _local_2:XML = null;
         var _local_3:uint = 0;
         if(_arg_1 == null)
         {
            return;
         }
         _dataMap = new HashMap();
         var _local_4:XMLList = _arg_1.elements("pro");
         for each(_local_2 in _local_4)
         {
            _local_3 = uint(_local_2.@id);
            _dataMap.add(_local_3,_local_2);
         }
      }
      
      public static function get proCnt() : uint
      {
         return _dataMap.length;
      }
      
      public static function getProDes(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.des);
         }
         return "";
      }
      
      public static function getProMapID(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return uint(_local_2.@mapID);
         }
         return 0;
      }
      
      public static function getStepList(_arg_1:uint) : Array
      {
         var _local_2:XML = null;
         var _local_3:Array = [];
         var _local_4:XML = _dataMap.getValue(_arg_1) as XML;
         if(_local_4 == null)
         {
            return [];
         }
         var _local_5:XMLList = _local_4.step;
         for each(_local_2 in _local_5)
         {
            _local_3.push(_local_2.@type);
         }
         return _local_3;
      }
      
      public static function getStepCnt(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         var _local_3:XMLList = _local_2.step;
         if(Boolean(_local_3))
         {
            return _local_3.length();
         }
         return 0;
      }
      
      public static function getStepXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(_local_4 == null)
         {
            return null;
         }
         var _local_5:XMLList = _local_4.step;
         for each(_local_3 in _local_5)
         {
            if(_local_3.@id == _arg_2)
            {
               return _local_3;
            }
         }
         return null;
      }
      
      public static function getStepType(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.@type;
      }
      
      public static function getStepGoto(_arg_1:uint, _arg_2:uint) : Array
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         var _local_4:String = String(_local_3["@goto"]);
         return _local_4.split("_");
      }
      
      public static function getStepIsComplete(_arg_1:uint, _arg_2:uint) : Boolean
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return Boolean(uint(_local_3.@isCompletePro));
      }
      
      public static function getStepOptionXML(_arg_1:uint, _arg_2:uint, _arg_3:uint) : XML
      {
         var _local_4:XML = getStepXML(_arg_1,_arg_2);
         return XML(_local_4.option[_arg_3]);
      }
      
      public static function getStepOptionCnt(_arg_1:uint, _arg_2:uint) : uint
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return (_local_3.option as XMLList).length();
      }
      
      public static function getStepOptionGoto(_arg_1:uint, _arg_2:uint, _arg_3:uint) : Array
      {
         var _local_4:XML = getStepOptionXML(_arg_1,_arg_2,_arg_3);
         return String(_local_4["@goto"]).split("_");
      }
      
      public static function getStepOptionDes(_arg_1:uint, _arg_2:uint, _arg_3:uint) : String
      {
         var _local_4:XML = getStepOptionXML(_arg_1,_arg_2,_arg_3);
         return _local_4.@des;
      }
      
      public static function getStepTalkXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.talk[0];
      }
      
      public static function getStepTalkNpc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepTalkXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@npcName;
         }
         return "";
      }
      
      public static function getStepTalkMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepTalkXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@talkMcName;
         }
         return "";
      }
      
      public static function getStepTalkDes(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:String = null;
         var _local_4:XML = getStepTalkXML(_arg_1,_arg_2);
         if(Boolean(_local_4))
         {
            _local_3 = String(_local_4.talkDes);
            return _local_3.replace(/#nick/g,MainManager.actorInfo.nick);
         }
         return "";
      }
      
      public static function getStepTalkFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:String = null;
         var _local_4:XML = getStepTalkXML(_arg_1,_arg_2);
         if(Boolean(_local_4))
         {
            return _local_4.@func;
         }
         return "";
      }
      
      public static function getStepMcXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.mc[0];
      }
      
      public static function getStepMcSparkMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepMcXML(_arg_1,_arg_2);
         return _local_3.@sparkMC;
      }
      
      public static function getStepMcType(_arg_1:uint, _arg_2:uint) : uint
      {
         var _local_3:XML = getStepMcXML(_arg_1,_arg_2);
         return _local_3.@type;
      }
      
      public static function getStepMcName(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepMcXML(_arg_1,_arg_2);
         return _local_3.@name;
      }
      
      public static function getStepMcVisible(_arg_1:uint, _arg_2:uint) : Boolean
      {
         var _local_3:XML = getStepMcXML(_arg_1,_arg_2);
         return Boolean(uint(_local_3.@visible));
      }
      
      public static function getStepMcFrame(_arg_1:uint, _arg_2:uint) : uint
      {
         var _local_3:XML = getStepMcXML(_arg_1,_arg_2);
         if(uint(_local_3.@frame) != 0)
         {
            return _local_3.@frame;
         }
         return 1;
      }
      
      public static function getStepMcFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepMcXML(_arg_1,_arg_2);
         return _local_3.@func;
      }
      
      public static function getStepSceenMovieXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.sceenMovie[0];
      }
      
      public static function getStepSmSparkMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepSceenMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@sparkMC;
         }
         return "";
      }
      
      public static function getStepSmPlaySceenMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepSceenMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@playSceenMC;
         }
         return "";
      }
      
      public static function getStepSmPlayMcFrame(_arg_1:uint, _arg_2:uint) : uint
      {
         var _local_3:XML = getStepSceenMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@frame;
         }
         return 0;
      }
      
      public static function getStepSmPlayMcChild(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepSceenMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@childMcName;
         }
         return "";
      }
      
      public static function getStepSmFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepSceenMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@func;
         }
         return "";
      }
      
      public static function getStepFullMovieXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.fullMovie[0];
      }
      
      public static function getStepFmSparkMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepFullMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@sparkMC;
         }
         return "";
      }
      
      public static function getStepFullMovieUrl(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepFullMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@playMovieURL;
         }
         return "";
      }
      
      public static function getStepFmFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepFullMovieXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@func;
         }
         return "";
      }
      
      public static function getStepGameXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.game[0];
      }
      
      public static function getStepGmSparkMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepGameXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@sparkMC;
         }
         return "";
      }
      
      public static function getStepGameUrl(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepGameXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@playGameURL;
         }
         return "";
      }
      
      public static function getStepGamePassFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepGameXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@passGameFunc;
         }
         return "";
      }
      
      public static function getStepGameLossFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepGameXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@loseGameFunc;
         }
         return "";
      }
      
      public static function getStepFightXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.fight[0];
      }
      
      public static function getStepFtSparkMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepFightXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@sparkMC;
         }
         return "";
      }
      
      public static function getStepFtBossID(_arg_1:uint, _arg_2:uint) : uint
      {
         var _local_3:XML = getStepFightXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@fightBossID;
         }
         return 0;
      }
      
      public static function getStepFtBossName(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepFightXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@fightBossName;
         }
         return "";
      }
      
      public static function getStepFtSuccessFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepFightXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@fightSuccessFunc;
         }
         return "";
      }
      
      public static function getStepFtLossFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepFightXML(_arg_1,_arg_2);
         if(Boolean(_local_3))
         {
            return _local_3.@fightLoseFunc;
         }
         return "";
      }
      
      public static function getStepPanelXML(_arg_1:uint, _arg_2:uint) : XML
      {
         var _local_3:XML = getStepXML(_arg_1,_arg_2);
         return _local_3.panel[0];
      }
      
      public static function getStepPanelSparkMC(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepPanelXML(_arg_1,_arg_2);
         return _local_3.@sparkMC;
      }
      
      public static function getStepPanelClass(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepPanelXML(_arg_1,_arg_2);
         return _local_3.@className;
      }
      
      public static function getStepPanelFunc(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = getStepPanelXML(_arg_1,_arg_2);
         return _local_3.@func;
      }
   }
}

