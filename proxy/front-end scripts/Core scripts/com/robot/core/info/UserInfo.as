package com.robot.core.info
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.pet.PetGlowFilter;
   import com.robot.core.info.team.TeamInfo;
   import com.robot.core.info.teamPK.TeamPKInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TasksManager;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.BitUtil;
   
   public class UserInfo
   {
      
      public var priorLevel:uint;
      
      public var userID:uint;
      
      public var timePoke:uint;
      
      public var hasSimpleInfo:Boolean = false;
      
      public var hasMoreInfo:Boolean = false;
      
      public var nick:String = "";
      
      public var vip:uint;
      
      public var viped:uint;
      
      public var color:uint;
      
      public var texture:uint;
      
      public var energy:uint;
      
      public var coins:uint;
      
      public var evpool:uint;
      
      public var fightBadge:uint;
      
      public var status:uint;
      
      public var mapType:uint;
      
      public var mapID:uint;
      
      public var actionType:uint;
      
      public var pos:Point = new Point();
      
      public var spiritTime:uint;
      
      public var spiritID:uint;
      
      public var petDV:uint;
      
      public var isshiny:uint;
      
      public var petShiny:PetGlowFilter;
      
      public var petSkin:uint;
      
      public var clothes:Array = [];
      
      public var ore:uint;
      
      public var serverID:uint;
      
      public var action:uint;
      
      public var direction:uint;
      
      public var changeShape:uint;
      
      public var petNum:uint;
      
      public var timeToday:uint;
      
      public var loginCnt:uint;
      
      public var inviter:uint;
      
      public var teamID:uint;
      
      public var isCanBeTeacher:Boolean;
      
      public var teacherID:uint;
      
      public var studentID:uint;
      
      public var graduationCount:uint;
      
      public var maxPuniLv:uint;
      
      public var regTime:uint;
      
      public var petAllNum:uint;
      
      public var petMaxLev:uint;
      
      public var bossAchievement:Array = [];
      
      public var fightFlag:uint;
      
      public var monKingWin:uint;
      
      public var messWin:uint;
      
      public var curStage:uint;
      
      public var maxStage:uint;
      
      public var curFreshStage:uint;
      
      public var maxFreshStage:uint;
      
      public var maxArenaWins:uint;
      
      public var badge:uint;
      
      public var reserved:ByteArray;
      
      public var superNono:Boolean;
      
      public var hasNono:Boolean;
      
      public var nonoState:Array = [];
      
      public var nonoNick:String = "";
      
      public var nonoColor:uint;
      
      public var timeLimit:uint;
      
      public var dsFlag:uint;
      
      public var newInviteeCnt:uint;
      
      public var freshManBonus:uint;
      
      public var dailyResArr:Array = [];
      
      public var nonoChipList:Array = [];
      
      public var teamInfo:TeamInfo;
      
      public var teamPKInfo:TeamPKInfo;
      
      public var playerForm:Boolean;
      
      public var transTime:uint;
      
      public var vipLevel:uint;
      
      public var vipValue:uint;
      
      public var vipStage:uint;
      
      public var autoCharge:uint;
      
      public var vipEndTime:uint;
      
      public var autoFight:uint;
      
      public var autoFightTimes:uint;
      
      public var twoTimes:uint;
      
      public var threeTimes:uint;
      
      public var monBtlMedal:uint;
      
      public var energyTimes:uint;
      
      public var learnTimes:uint;
      
      public var recordCnt:uint;
      
      public var obtainTm:uint;
      
      public var soulBeadItemID:uint;
      
      public var expireTm:uint;
      
      public var fuseTimes:uint;
      
      public var canReadSchedule:Boolean;
      
      public var curTitle:uint;
      
      public function UserInfo()
      {
         super();
      }
      
      public static function setForPeoleInfo(_arg_1:UserInfo, _arg_2:IDataInput) : void
      {
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_6:int = 0;
         var _local_8:int = 0;
         var _local_11:int = 0;
         _arg_1.hasSimpleInfo = true;
         _arg_1.userID = _arg_2.readUnsignedInt();
         _arg_1.nick = _arg_2.readUTFBytes(16);
         _arg_1.curTitle = _arg_2.readUnsignedInt();
         _arg_1.color = _arg_2.readUnsignedInt();
         _arg_1.texture = _arg_2.readUnsignedInt();
         var _local_5:uint = _arg_2.readUnsignedInt();
         _arg_1.vip = BitUtil.getBit(_local_5,0);
         _arg_1.viped = BitUtil.getBit(_local_5,1);
         _arg_1.vipStage = _arg_2.readUnsignedInt();
         _arg_1.actionType = _arg_2.readUnsignedInt();
         _arg_1.pos = new Point(_arg_2.readUnsignedInt(),_arg_2.readUnsignedInt());
         _arg_1.action = _arg_2.readUnsignedInt();
         _arg_1.direction = _arg_2.readUnsignedInt();
         _arg_1.changeShape = _arg_2.readUnsignedInt();
         _arg_1.spiritTime = _arg_2.readUnsignedInt();
         _arg_1.spiritID = _arg_2.readUnsignedInt();
         _arg_1.petDV = _arg_2.readUnsignedInt();
         _arg_1.isshiny = _arg_2.readUnsignedInt();
         if(Boolean(_arg_1.isshiny))
         {
            _arg_1.petShiny = new PetGlowFilter(_arg_2);
         }
         _arg_1.petSkin = _arg_2.readUnsignedInt();
         while(_local_6 < 3)
         {
            _arg_2.readUnsignedInt();
            _local_6++;
         }
         _arg_1.fightFlag = _arg_2.readUnsignedInt();
         _arg_1.teacherID = _arg_2.readUnsignedInt();
         _arg_1.studentID = _arg_2.readUnsignedInt();
         var _local_7:uint = _arg_2.readUnsignedInt();
         while(_local_8 < 32)
         {
            _arg_1.nonoState.push(BitUtil.getBit(_local_7,_local_8));
            _local_8++;
         }
         _arg_1.nonoColor = _arg_2.readUnsignedInt();
         _arg_1.superNono = Boolean(_arg_2.readUnsignedInt());
         _arg_1.playerForm = Boolean(_arg_2.readUnsignedInt());
         _arg_1.transTime = _arg_2.readUnsignedInt();
         var _local_9:TeamInfo = new TeamInfo();
         _local_9.id = _arg_2.readUnsignedInt();
         _local_9.coreCount = _arg_2.readUnsignedInt();
         _local_9.isShow = Boolean(_arg_2.readUnsignedInt());
         _arg_1.teamInfo = _local_9;
         _local_9.logoBg = _arg_2.readShort();
         _local_9.logoIcon = _arg_2.readShort();
         _local_9.logoColor = _arg_2.readShort();
         _local_9.txtColor = _arg_2.readShort();
         _local_9.logoWord = _arg_2.readUTFBytes(4);
         var _local_10:uint = _arg_2.readUnsignedInt();
         while(_local_11 < _local_10)
         {
            _local_3 = _arg_2.readUnsignedInt();
            _local_4 = _arg_2.readUnsignedInt();
            _arg_1.clothes.push(new PeopleItemInfo(_local_3,_local_4));
            _local_11++;
         }
      }
      
      public static function setForLoginInfo(_arg_1:UserInfo, _arg_2:IDataInput) : void
      {
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_6:int = 0;
         var _local_7:int = 0;
         var _local_9:int = 0;
         var _local_14:uint = 0;
         trace("setForLoginInfo");
         _arg_1.hasSimpleInfo = true;
         _arg_1.userID = _arg_2.readUnsignedInt();
         _arg_1.regTime = _arg_2.readUnsignedInt();
         _arg_1.nick = _arg_2.readUTFBytes(16);
         _arg_1.curTitle = _arg_2.readUnsignedInt();
         var _local_5:uint = _arg_2.readUnsignedInt();
         _arg_1.vip = BitUtil.getBit(_local_5,0);
         _arg_1.viped = BitUtil.getBit(_local_5,1);
         _arg_1.dsFlag = _arg_2.readUnsignedInt();
         _arg_1.color = _arg_2.readUnsignedInt();
         _arg_1.texture = _arg_2.readUnsignedInt();
         _arg_1.energy = _arg_2.readUnsignedInt();
         _arg_1.coins = _arg_2.readUnsignedInt();
         _arg_1.evpool = _arg_2.readUnsignedInt();
         _arg_1.fightBadge = _arg_2.readUnsignedInt();
         _arg_1.mapID = _arg_2.readUnsignedInt();
         _arg_1.pos = new Point(_arg_2.readUnsignedInt(),_arg_2.readUnsignedInt());
         _arg_1.timeToday = _arg_2.readUnsignedInt();
         _arg_1.timeLimit = _arg_2.readUnsignedInt();
         MainManager.isClothHalfDay = Boolean(_arg_2.readByte());
         MainManager.isRoomHalfDay = Boolean(_arg_2.readByte());
         MainManager.iFortressHalfDay = Boolean(_arg_2.readByte());
         MainManager.isHQHalfDay = Boolean(_arg_2.readByte());
         _arg_1.loginCnt = _arg_2.readUnsignedInt();
         _arg_1.inviter = _arg_2.readUnsignedInt();
         _arg_1.newInviteeCnt = _arg_2.readUnsignedInt();
         _arg_1.vipLevel = _arg_2.readUnsignedInt();
         _arg_1.vipValue = _arg_2.readUnsignedInt();
         _arg_1.vipStage = _arg_2.readUnsignedInt();
         if(_arg_1.vipStage > 4)
         {
            _arg_1.vipStage = 4;
         }
         if(_arg_1.vipStage == 0)
         {
            _arg_1.vipStage = 1;
         }
         _arg_1.autoCharge = _arg_2.readUnsignedInt();
         _arg_1.vipEndTime = _arg_2.readUnsignedInt();
         _arg_1.freshManBonus = _arg_2.readUnsignedInt();
         while(_local_6 < 80)
         {
            _arg_1.nonoChipList.push(true);
            _local_6++;
         }
         while(_local_7 < 50)
         {
            _arg_1.dailyResArr.push(_arg_2.readByte());
            _local_7++;
         }
         _arg_1.teacherID = _arg_2.readUnsignedInt();
         _arg_1.studentID = _arg_2.readUnsignedInt();
         _arg_1.graduationCount = _arg_2.readUnsignedInt();
         _arg_1.maxPuniLv = _arg_2.readUnsignedInt();
         _arg_1.petMaxLev = _arg_2.readUnsignedInt();
         _arg_1.petAllNum = _arg_2.readUnsignedInt();
         _arg_1.monKingWin = _arg_2.readUnsignedInt();
         _arg_1.curStage = _arg_2.readUnsignedInt() + 1;
         _arg_1.maxStage = _arg_2.readUnsignedInt();
         _arg_1.curFreshStage = _arg_2.readUnsignedInt();
         _arg_1.maxFreshStage = _arg_2.readUnsignedInt();
         _arg_1.maxArenaWins = _arg_2.readUnsignedInt();
         _arg_1.twoTimes = _arg_2.readUnsignedInt();
         _arg_1.threeTimes = _arg_2.readUnsignedInt();
         _arg_1.autoFight = _arg_2.readUnsignedInt();
         _arg_1.autoFightTimes = _arg_2.readUnsignedInt();
         _arg_1.energyTimes = _arg_2.readUnsignedInt();
         _arg_1.learnTimes = _arg_2.readUnsignedInt();
         _arg_1.monBtlMedal = _arg_2.readUnsignedInt();
         _arg_1.recordCnt = _arg_2.readUnsignedInt();
         _arg_1.obtainTm = _arg_2.readUnsignedInt();
         _arg_1.soulBeadItemID = _arg_2.readUnsignedInt();
         _arg_1.expireTm = _arg_2.readUnsignedInt();
         _arg_1.fuseTimes = _arg_2.readUnsignedInt();
         _arg_1.hasNono = Boolean(_arg_2.readUnsignedInt());
         _arg_1.superNono = Boolean(_arg_2.readUnsignedInt());
         var _local_8:uint = _arg_2.readUnsignedInt();
         while(_local_9 < 32)
         {
            _arg_1.nonoState.push(BitUtil.getBit(_local_8,_local_9));
            _local_9++;
         }
         _arg_1.nonoColor = _arg_2.readUnsignedInt();
         _arg_1.nonoNick = _arg_2.readUTFBytes(16);
         _arg_1.teamInfo = new TeamInfo(_arg_2);
         _arg_1.teamPKInfo = new TeamPKInfo(_arg_2);
         _arg_2.readByte();
         _arg_1.badge = _arg_2.readUnsignedInt();
         var _local_10:ByteArray = new ByteArray();
         _arg_2.readBytes(_local_10,0,27);
         _arg_1.reserved = _local_10;
         var tasklist:ByteArray = new ByteArray();
         _arg_2.readBytes(tasklist,0,1000);
         TasksManager.parseTasks(tasklist);
         _arg_1.isCanBeTeacher = TasksManager.getTaskStatus(201) == 3;
         _arg_1.petNum = _arg_2.readUnsignedInt();
         PetManager.initData(_arg_2,_arg_1.petNum);
         var _local_13:uint = _arg_2.readUnsignedInt();
         while(_local_14 < _local_13)
         {
            _local_3 = _arg_2.readUnsignedInt();
            _local_4 = _arg_2.readUnsignedInt();
            _arg_1.clothes.push(new PeopleItemInfo(_local_3,_local_4));
            _local_14++;
         }
      }
      
      public static function setForSimpleInfo(_arg_1:UserInfo, _arg_2:IDataInput) : void
      {
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_7:int = 0;
         _arg_1.hasSimpleInfo = true;
         ByteArray(_arg_2).position = 0;
         _arg_1.userID = _arg_2.readUnsignedInt();
         _arg_1.nick = _arg_2.readUTFBytes(16);
         _arg_1.curTitle = _arg_2.readUnsignedInt();
         _arg_1.color = _arg_2.readUnsignedInt();
         _arg_1.texture = _arg_2.readUnsignedInt();
         _arg_1.vip = _arg_2.readUnsignedInt();
         _arg_1.status = _arg_2.readUnsignedInt();
         _arg_1.mapType = _arg_2.readUnsignedInt();
         _arg_1.mapID = _arg_2.readUnsignedInt();
         _arg_1.isCanBeTeacher = _arg_2.readUnsignedInt() == 1;
         _arg_1.teacherID = _arg_2.readUnsignedInt();
         _arg_1.studentID = _arg_2.readUnsignedInt();
         _arg_1.graduationCount = _arg_2.readUnsignedInt();
         _arg_1.vipLevel = _arg_2.readUnsignedInt();
         var _local_5:TeamInfo = new TeamInfo();
         _local_5.id = _arg_2.readUnsignedInt();
         _local_5.isShow = Boolean(_arg_2.readUnsignedInt());
         _arg_1.teamInfo = _local_5;
         _arg_1.teamID = _local_5.id;
         var _local_6:uint = _arg_2.readUnsignedInt();
         while(_local_7 < _local_6)
         {
            _local_3 = _arg_2.readUnsignedInt();
            _local_4 = _arg_2.readUnsignedInt();
            _arg_1.clothes.push(new PeopleItemInfo(_local_3,_local_4));
            _local_7++;
         }
      }
      
      public static function setForMoreInfo(_arg_1:UserInfo, _arg_2:IDataInput) : void
      {
         var _local_3:int = 0;
         _arg_1.hasMoreInfo = true;
         _arg_1.userID = _arg_2.readUnsignedInt();
         _arg_1.nick = _arg_2.readUTFBytes(16);
         _arg_1.curTitle = _arg_2.readUnsignedInt();
         _arg_1.regTime = _arg_2.readUnsignedInt();
         _arg_1.petAllNum = _arg_2.readUnsignedInt();
         _arg_1.petMaxLev = _arg_2.readUnsignedInt();
         while(_local_3 < 20)
         {
            _arg_1.bossAchievement.push(Boolean(_arg_2.readByte()));
            _local_3++;
         }
         _arg_1.graduationCount = _arg_2.readUnsignedInt();
         _arg_1.monKingWin = _arg_2.readUnsignedInt();
         _arg_1.messWin = _arg_2.readUnsignedInt();
         _arg_1.maxStage = _arg_2.readUnsignedInt();
         _arg_1.maxArenaWins = _arg_2.readUnsignedInt();
      }
      
      public function get clothIDs() : Array
      {
         var _local_1:PeopleItemInfo = null;
         var _local_2:Array = [];
         for each(_local_1 in this.clothes)
         {
            _local_2.push(_local_1.id);
         }
         return _local_2;
      }
      
      public function get clothMaxLevel() : uint
      {
         var _local_1:PeopleItemInfo = null;
         var _local_2:uint = 0;
         for each(_local_1 in this.clothes)
         {
            _local_2 = Math.max(_local_2,_local_1.level);
         }
         return _local_2;
      }
   }
}

