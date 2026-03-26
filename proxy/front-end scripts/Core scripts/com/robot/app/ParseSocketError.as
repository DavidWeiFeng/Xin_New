package com.robot.app
{
   import com.robot.app.superParty.SPChannelController;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.teacher.TeacherSysManager;
   import com.robot.app.toolBar.ToolBarController;
   import com.robot.core.CommandID;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.teamPK.TeamPKManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import org.taomee.manager.EventManager;
   
   public class ParseSocketError
   {
      
      private static var instance:EventDispatcher;
      
      public static const NAME_BAD_LANGUAGE:String = "nameBadLanguage";
      
      public static const TIME_PASSWORD_ERROR:String = "timePasswordError";
      
      private static var isSingle:Boolean = false;
      
      public function ParseSocketError()
      {
         super();
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            isSingle = true;
            instance = new EventDispatcher();
         }
         isSingle = false;
         return instance;
      }
      
      public static function addErrorListener(_arg_1:uint, _arg_2:Function, _arg_3:Boolean = false, _arg_4:int = 0, _arg_5:Boolean = false) : void
      {
         getInstance().addEventListener("ERROR_" + _arg_1,_arg_2,_arg_3,_arg_4,_arg_5);
      }
      
      public static function removeErrorListener(_arg_1:uint, _arg_2:Function, _arg_3:Boolean = false) : void
      {
         getInstance().removeEventListener("ERROR_" + _arg_1,_arg_2,_arg_3);
      }
      
      public static function dispatchEvent(_arg_1:Event) : void
      {
         getInstance().dispatchEvent(_arg_1);
      }
      
      public static function hasEventListener(_arg_1:String) : Boolean
      {
         return getInstance().hasEventListener(_arg_1);
      }
      
      public static function willTrigger(_arg_1:String) : Boolean
      {
         return getInstance().willTrigger(_arg_1);
      }
      
      public static function parse(num:int, cmdID:int) : void
      {
         var s:* = undefined;
         dispatchEvent(new Event("ERROR_" + num));
         switch(num)
         {
            case 13024:
               Alarm.show("还没有加载超能NoNo技能排序芯片");
               return;
            case 10401:
               return;
            case 10402:
               Alarm.show("已经完成了领奖");
               return;
            case 10023:
               Alarm.show("领取新年礼物时间不对,快去看看纽斯身后的公告板吧！");
               return;
            case 11025:
               Alarm.show("要冰系的精灵才能应战的哦！");
               return;
            case 11027:
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.ERROR_11027));
               return;
            case 11028:
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.ERROR_11028));
               return;
            case 10029:
               Alarm.show("你的铭牌数量不够哦!赶快去答题得奖吧!");
               return;
            case 14004:
               NpcTipDialog.show("NoNo无重力能量仓还处于试验阶段，为了每个NoNo的健康，明天再来吧！",null,NpcTipDialog.SHAWN);
               return;
            case 19001:
               Alarm.show("没有跟随精灵哦");
               return;
            case 19002:
               Alarm.show("仔细观察圆圈的颜色，然后将对应属性的精灵带在身边才能开启这个机关。");
               return;
            case 10101:
               Alarm.show("这个位置已经有人了");
               return;
            case 103106:
               Alarm.show("你今天获得的骄阳豆已经到上限了 ");
               return;
            case 10009:
               Alarm.show("骄阳计划进入休眠巡航模式！\r系统即将关闭！",function():void
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("function() { location.reload(); }");
                  }
               });
               return;
            case 10001:
               Alarm.show("对不起，你的密码不正确，请尝试刷新网页获取新链接",function():void
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("function() { location.reload(); }");
                  }
               },false,true);
               return;
            case 10002:
               MainManager.getStage().addChild(Alarm.show("系统出错"));
               return;
            case 10003:
               Alarm.show("系统繁忙");
               return;
            case 10007:
               Alarm.show("获取黑名单错误");
               return;
            case 10017:
               Alarm.show("购买失败");
               return;
            case 11001:
               Alarm.show("战斗已经取消");
               return;
            case 11002:
               Alarm.show("战斗已经结束");
               return;
            case 11012:
               Alarm.show("你本回合已经做过操作");
               return;
            case 11005:
               Alarm.show("当前不能取消对战");
               return;
            case 11013:
               Alarm.show("你的精灵已经没有体力了，请更换对战精灵！");
               return;
            case 11008:
               Alarm.show("对方跟你不在同一个场景中，不能进行对战");
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.CLOSE_FIGHT_WAIT));
               return;
            case 11009:
               Alarm.show("关卡场景中没有要挑战的boss");
               return;
            case 11030:
               Alarm.show("你背包中的精灵不满足出战的要求");
               return;
            case 11010:
               Alarm.show("你已经在线超过六小时，不能进行战斗了");
               return;
            case 10030:
               Alarm.show("你还不能做这个动作！");
               return;
            case 10004:
               s = Alarm.show("你的帐号已经在别的地方登录！",function():void
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("function() { location.reload(); }");
                  }
               });
               MainManager.getStage().addChild(s);
               return;
            case 103301:
               Alarm.show("任务已经存在");
               return;
            case 13001:
               Alarm.show("需收集的精灵不齐备");
               return;
            case 13002:
               Alarm.show("你已经兑换过这个精灵了");
               return;
            case 103103:
               Alarm.show("好友已经存在");
               return;
            case 103105:
               Alarm.show("到达好友个数上限");
               return;
            case 103102:
               Alarm.show("对方在你的黑名单中");
               return;
            case 103104:
               Alarm.show("好友不存在");
               return;
            case 103117:
               Alarm.show("用户已经存在于黑名单");
               return;
            case 103118:
               Alarm.show("黑名单个数超过限制");
               return;
            case 103116:
               Alarm.show("被删除的用户不在黑名单中");
               return;
            case 103203:
               Alarm.show("你不能拥有过多此物品！");
               return;
            case 103204:
               Alarm.show("物品ID不存在");
               return;
            case 103208:
               Alarm.show("对不起，你的物品数量不够");
               return;
            case 103013:
               MainManager.getStage().addChild(Alarm.show("精灵个数已经超过上限"));
               return;
            case 103207:
               Alarm.show("某些衣服过期了");
               return;
            case 103202:
               if(cmdID == CommandID.GET_LAS_EGG)
               {
                  Alarm.show("这是专为已战胜里奥斯但没有获得胡里亚的赛尔而开设的精元补领设施！");
               }
               else if(cmdID == 1109)
               {
                  NpcTipDialog.show("很抱歉，您没有<font color=\'#ff0000\'>精灵邀请函</font>，所以不能查看稀有精灵大拜年时刻表，HELP建议您可以去问问其他小赛尔，希望您可以谅解。",null,NpcTipDialog.HELPMACH);
               }
               else if(cmdID == CommandID.OPEN_DARKPORTAL)
               {
                  Alarm.show("你的暗黑之匙不够,不能够进入暗黑之门哦!");
               }
               else
               {
                  Alarm.show("对不起，你的物品数量不够");
               }
               return;
            case 103303:
               Alarm.show("每周每天任务的次数达到了最大值");
               return;
            case 103107:
               Alarm.show("你的骄阳豆余额不足");
               return;
            case 13006:
               Alarm.show("这只精灵还不满足进化的条件！");
               return;
            case 13007:
               Alarm.show("你的精灵等级太低，还不能进化！");
               return;
            case 13017:
               Alarm.show("不能展示背包里的精灵！");
               return;
            case 17018:
               Alarm.show("你今天已经被吃掉过一回了,明天再来吧！");
               return;
            case 13023:
               Alarm.show("该道具已经在使用中，无法重复使用。");
               return;
            case 103011:
               Alarm.show("赛尔精灵不存在");
               return;
            case 13009:
               Alarm.show("你的精灵不能被进化！");
               return;
            case 103012:
               Alarm.show("超过可带出来的精灵个数限制");
               return;
            case 13003:
               Alarm.show("需要治疗的精灵不在身边");
               return;
            case 11006:
               Alarm.show("你没有可出战的精灵哦！");
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.CLOSE_FIGHT_WAIT));
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.NO_PET_CAN_FIGHT));
               return;
            case 11007:
               Alarm.show("单挑模式中不允许替换精灵");
               return;
            case 11003:
               Alarm.show("对方没有可以出战的精灵");
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.CLOSE_FIGHT_WAIT));
               return;
            case 103232:
               Alarm.show("系统繁忙，请稍后再试");
               return;
            case 10005:
               Alarm.show("你使用了非法语言！");
               EventManager.dispatchEvent(new Event(NAME_BAD_LANGUAGE));
               return;
            case 10006:
               Alarm.show("对方不在线");
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.CLOSE_FIGHT_WAIT));
               return;
            case 11004:
               Alarm.show("这只精灵似乎已经不在这个地方了");
               return;
            case 11011:
               Alarm.show("boss目前不接受挑战");
               return;
            case 101105:
               Alarm.show("米米号不存在");
               return;
            case 103240:
               Alarm.show("你不能拥有过多该物品！");
               return;
            case 103241:
               Alarm.show("基地道具的类型数量超过限制（400个）");
               return;
            case 103242:
               Alarm.show("仓库中可贩卖的道具数量少于欲贩卖的道具数量");
               return;
            case 103108:
               Alarm.show("小屋电量不足");
               return;
            case 10008:
               Alarm.show("该能源目前不能被采集");
               return;
            case 10009:
               Alarm.show("在线时间超时（6小时）");
               return;
            case 103010:
               EventManager.dispatchEvent(new PetFightEvent(PetFightEvent.PET_HAS_EXIST));
               return;
            case 10010:
               Alarm.show("报告！你的电池能量已经耗尽，现在只能维持最基本的运行模式。");
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.CLOSE_FIGHT_WAIT));
               return;
            case 10011:
               Alarm.show("对方的在线时长已经超过最大时长！");
               EventManager.dispatchEvent(new RobotEvent(RobotEvent.CLOSE_FIGHT_WAIT));
               return;
            case 103111:
               Alarm.show("你已经能够独挡一面了，去迎接更大的挑战吧！");
               TeacherSysManager.hideSendTip();
               return;
            case 103109:
               Alarm.show("你已经有一个教官了，要珍惜哦！");
               TeacherSysManager.hideSendTip();
               return;
            case 103110:
               Alarm.show("你已经有一个学员了，要专心哦");
               TeacherSysManager.hideSendTip();
               return;
            case 12001:
               Alarm.show("对方不具备教官资格，不能接收你为学员哦！");
               TeacherSysManager.hideSendTip();
               return;
            case 12002:
               Alarm.show("对方已经能够独挡一面了，不需要教官的带领了！");
               TeacherSysManager.hideSendTip();
               return;
            case 12003:
               Alarm.show("对方已经有自己的教官了，去找别的新手试试吧！");
               TeacherSysManager.hideSendTip();
               return;
            case 12004:
               Alarm.show("对方已经有学员了，去找别的教官试试吧！");
               TeacherSysManager.hideSendTip();
               return;
            case 12005:
               Alarm.show("你还不能做别人的教官");
               TeacherSysManager.hideSendTip();
               return;
            case 12006:
               Alarm.show("你已经能够独挡一面了，不需要教官来帮助你了");
               TeacherSysManager.hideSendTip();
               return;
            case 13008:
               Alarm.show("不能学习重复的技能");
               return;
            case 13025:
               Alarm.show("你并没有使用过<font color=\'#ff0000\'>自动战斗器S型</font>");
               return;
            case 13027:
            case 13028:
            case 13029:
               Alarm.show("你的精灵还未达到参与融合的要求，换别的精灵试试吧");
               return;
            case 13030:
               Alarm.show(" 融合转生仓已进入自动能源补充模式，一天后能源将补充完毕");
               return;
            case 13031:
               Alarm.show("你已经拥有足够多的元神珠啦，请将它们孵化后再来继续融合噢");
               return;
            case 13032:
               Alarm.show("你没有元神珠");
               return;
            case 13034:
            case 103548:
               Alarm.show("你已经有一个元神珠正在赋形噢");
               return;
            case 103547:
               Alarm.show("你的元神珠不存在");
               return;
            case 10012:
               Alarm.show("他是你的教官！请先与他解除教官与学员的关系！");
               return;
            case 10013:
               Alarm.show("他是你的学员！请先与他解除教官与学员的关系！");
               return;
            case 10014:
               Alarm.show("他是你的教官！请先与他解除教官与学员的关系！");
               return;
            case 10015:
               Alarm.show("他是你的学员！请先与他解除教官与学员的关系！");
               return;
            case 103113:
               Alarm.show("请先与他解除教官与学员的关系！");
               return;
            case 101001:
               Alarm.show("数据库繁忙");
               return;
            case 101002:
               Alarm.show("数据库出错");
               return;
            case 101003:
               Alarm.show("数据库网络出错");
               return;
            case 10009:
               Alarm.show("现在还不能采燃气");
               return;
            case 103530:
               Alarm.show("战队徽章不够！");
               return;
            case 200002:
               Alarm.show("分子密码不存在");
               return;
            case 200003:
               Alarm.show("分子密码未激活");
               return;
            case 200004:
               Alarm.show("分子密码不在有效期内");
               return;
            case 200005:
               Alarm.show("分子密码被冻结");
               return;
            case 200006:
               Alarm.show("分子密码礼物领完");
               return;
            case 200007:
               Alarm.show("系统错误");
               return;
            case 10050:
               Alarm.show("快邀请更多的勇士加入我们其中吧，让我们一起携手捍卫家园！");
               return;
            case 10052:
               Alarm.show("你已经领过奖品了！");
               return;
            case 12007:
               Alarm.show("经验池已经没有经验");
               return;
            case 12008:
               Alarm.show("你不是学员身份！");
               break;
            case 13003:
               break;
            case 13010:
               Alarm.show("已经有一个精元在孵化了（不能同时孵化两个蛋）");
               return;
            case 16001:
               Alarm.show("你今天已经打过工了");
               return;
            case 16002:
               Alarm.show("你没有捐赠任何东西");
               return;
            case 12009:
               Alarm.show("你不是教官身份！");
               return;
            case 13002:
               Alarm.show("你已经兑换过这个精灵了");
               return;
            case 13004:
               Alarm.show("要求奖励的精灵不在可奖励的范围");
               return;
            case 13011:
               Alarm.show("精灵王获胜场数不足10场");
               return;
            case 14001:
               Alarm.show("每天只可以做5项每日任务噢，明天再来吧");
               return;
            case 14002:
               Alarm.show("你今天不能再接日常任务了");
               return;
            case 14003:
               Alarm.show("你没有做够足够的任务，不能领奖励");
               return;
            case 14005:
               Alarm.show("你还没有完成露希欧星勘探任务,不能进行采矿!");
            case 15001:
               Alarm.show("你已经报过名了");
               return;
            case 15002:
               Alarm.show("你还没有加入一支队伍");
               return;
            case 15003:
               Alarm.show("你的队伍人气还不够，还不能领取宝箱");
               return;
            case 15004:
               Alarm.show("你已经领取过宝箱了");
               return;
            case 15005:
               Alarm.show("你已经领取过精灵大赛的奖励了");
               return;
            case 10301:
               Alarm.show("你的扭蛋牌不足，无法兑换奖励。");
               return;
            case 15006:
               Alarm.show("你进出集合区域太过频繁。");
               return;
            case 100101:
               Alarm.show("由于使用不文明昵称,你的号码被永久封停");
               return;
            case 100102:
               Alarm.show("由于使用不文明昵称,你的号码被24小时封停");
               return;
            case 100103:
               Alarm.show("由于你的账号严重作弊违规，你的号码被永久封停");
               return;
            case 100104:
               Alarm.show("由于使用不文明昵称,你的号码被14天封停");
               return;
            case 100201:
               Alarm.show("由于使用不文明用语,你的号码被永久封停");
               return;
            case 100202:
               Alarm.show("由于使用不文明用语,你的号码被24小时封停");
               return;
            case 100203:
               Alarm.show("由于使用不文明用语,你的号码被7天封停");
               return;
            case 100204:
               Alarm.show("由于使用不文明用语,你的号码被14天封停");
               return;
            case 100301:
               Alarm.show("由于索要个人信息,你的号码被永久封停");
               return;
            case 100302:
               Alarm.show("由于索要个人信息,你的号码被24小时封停");
               return;
            case 100303:
               Alarm.show("由于索要个人信息,你的号码被7天封停");
               return;
            case 100304:
               Alarm.show("由于索要个人信息,你的号码被14天封停");
               return;
            case 100401:
               Alarm.show("由于使用外挂,你的号码被永久封停");
               return;
            case 100402:
               Alarm.show("由于使用外挂,你的号码被24小时封停");
               return;
            case 100403:
               Alarm.show("由于使用外挂,你的号码被7天封停");
               return;
            case 100404:
               Alarm.show("由于使用外挂,你的号码被14天封停");
               return;
            case 100501:
               Alarm.show("由于强制改名,你的号码被踢下线");
               return;
            case 103245:
               Alarm.show("分配器中经验值不够");
               return;
            case 103542:
               NpcTipDialog.show("我们要可持续发展的利用资源，今天你的精灵已经获得了3000经验，明天再来吧！",null,NpcTipDialog.NONO);
               return;
            case 11018:
               Alarm.show("已经与这个时间稀有野怪对战过");
               return;
            case 11015:
               Alarm.show("擂主已经存在");
               return;
            case 11017:
               Alarm.show("擂台赛战斗已经开始,等会再挑战吧！");
               return;
            case 11014:
               LevelManager.root.addChild(Alarm.show("用户之间对战不能随便逃跑哦！"));
               return;
            case 13012:
               Alarm.show("擂主不能更换精灵");
               return;
            case 13013:
               Alarm.show("擂主不能给精灵加血");
               return;
            case 11023:
               Alarm.show("擂主还没有准备好，不能挑战");
               return;
            case 11021:
               Alarm.show("擂主不能加入其它战斗");
               return;
            case 11020:
               Alarm.show("不能邀请擂主对战");
               return;
            case 11022:
               Alarm.show("擂主不能取消战斗");
               return;
            case 13014:
               Alarm.show("已经拥有的精灵太多,大于1000，不能回收");
               return;
            case 13015:
               Alarm.show("你的精灵与你的感情已经非常亲密了\n舍不得离开你。");
               return;
            case 13016:
               Alarm.show("非仓库中的精灵不能放生");
               return;
            case 103013:
               Alarm.show("已经拥有的精灵太多,大于1000，不能回收");
               return;
            case 103014:
               Alarm.show("放生仓库中的精灵多于1000个");
               return;
            case 103015:
               Alarm.show("非仓库中的精灵不能放生");
               return;
            case 103016:
               Alarm.show("精灵id和捕捉时间不匹配");
               return;
            case 103017:
               Alarm.show("精灵处在放生状态，不能再次放生");
               return;
            case 15007:
               Alarm.show("你今天已经领了10次礼物了,不能再领了!",function():void
               {
                  if(MapManager.currentMap.id == 104)
                  {
                     MapManager.changeMap(1);
                     ToolBarController.panel.show();
                  }
               });
               return;
            case 10016:
               Alarm.show("你的骄阳豆余额不足");
               if(SPChannelController.isSuerChannel)
               {
                  SPChannelController.isSuerChannel = false;
               }
               return;
            case 10041:
               Alarm.show("你还没有开通超能NoNo，无法使用相关服务。");
               return;
            case 10043:
               Alarm.show("没有完成任务不能领奖品");
               return;
            case 10501:
               Alarm.show("该装扮未达到所需的升级!");
               return;
            case 10502:
               Alarm.show("该装扮不可以升级!");
               return;
            case 10503:
               if(cmdID == CommandID.PEOPLE_TRANSFROM)
               {
                  Alarm.show("你没有足够的能量块\r<font color=\'#ff0000\'>（你可以在赛尔工厂或者米币手册里购买到哦！）</font>");
               }
               else
               {
                  Alarm.show("你没有该装扮!");
               }
               return;
            case 11009:
               Alarm.show("Boss不存在");
               return;
            case 11026:
               Alarm.show("今天已经挑战过该精灵了,明天再来吧！");
               return;
            case 13018:
               Alarm.show("你的精灵这项能力已经达到顶峰了");
               return;
            case 13033:
               Alarm.show("该精灵不能执行元神还原哦！");
               return;
            case 13020:
               Alarm.show("战斗中不能改变属性上限");
               return;
            case 17001:
               Alarm.show("你已经有NoNo了！");
               return;
            case 17002:
               Alarm.show("你还没有开通NoNo！");
               return;
            case 17003:
               Alarm.show("你的NoNo处在关机状态中！");
               return;
            case 17004:
               Alarm.show("你的NoNo能量不足！");
               return;
            case 17005:
               Alarm.show("你的NoNo没有开通这个功能哦！");
               if(SPChannelController.isSuerChannel)
               {
                  SPChannelController.isSuerChannel = false;
               }
               return;
            case 17006:
               Alarm.show("这个物品目前没有办法使用！");
               return;
            case 17007:
               Alarm.show("你NoNo的AI等级不够！");
               return;
            case 17012:
               Alarm.show("完成相关超能NoNo的开通手续以后，才能使用此项功能哦。");
               return;
            case 17013:
               Alarm.show("你的NoNo不在身边哦！");
               return;
            case 17014:
               Alarm.show("呼，你已经领取过这周的奖励了呢下周再来领取吧。");
               return;
            case 17015:
               Alarm.show("你的NoNo没有开通这个功能哦！");
               if(SPChannelController.isSuerChannel)
               {
                  SPChannelController.isSuerChannel = false;
               }
               return;
            case 17016:
               Alarm.show("已经开通过超能NoNo了，不必重复开通");
               return;
            case 17019:
               Alarm.show("身边没有跟随要求的精灵");
               return;
            case 13021:
               Alarm.show("你的精灵是100级的精灵哟，没法再获得能量长大了！");
               return;
            case 14004:
               Alarm.show("你今天已经玩过一次了");
               return;
            case 1:
               return;
            case 10018:
               Alarm.show("你只要战胜了火山星山洞深处的里奥斯就能获得它的精元哦。");
               return;
            case 13022:
               Alarm.show("你已经获得了里奥斯，不能太贪心哦。");
               return;
            case 17017:
               Alarm.show("你已经领过该芯片");
               return;
            case 17015:
               Alarm.show("你没有超能NoNo，不能领取超能芯片");
               return;
            case 103512:
               Alarm.show("该赛尔已经是战队成员");
               return;
            case 103513:
               Alarm.show("战队不存在");
               return;
            case 103514:
               Alarm.show("战队成员已经存在");
               return;
            case 103515:
               Alarm.show("战队中没有这个成员");
               return;
            case 103516:
               Alarm.show("战队成员超过上限");
               return;
            case 103517:
               Alarm.show("战队ID不存在");
               return;
            case 103518:
               Alarm.show("要塞设施已存在");
               return;
            case 103519:
               Alarm.show("战队指挥官不存在");
               return;
            case 103520:
               Alarm.show("设施不存在");
               return;
            case 103523:
               Alarm.show("设施数量达到上限");
               return;
            case 103528:
               Alarm.show("你今天已经领取过战队能量了");
               return;
            case 103529:
               Alarm.show("能量不足");
               return;
            case 18001:
               Alarm.show("你已经加入了一个战队了");
               return;
            case 18002:
               Alarm.show("你不在这个战队中，不能做此操作");
               return;
            case 18003:
               Alarm.show("你没有审核验证的权限");
               return;
            case 18004:
               if(cmdID == 4001)
               {
                  TeamPKManager.closeWait();
                  Alarm.show("只有指挥官能报名参加要塞保卫战。快让你的指挥官带领你们一起争取荣耀吧！");
               }
               else
               {
                  Alarm.show("你不是指挥官");
               }
               return;
            case 18005:
               Alarm.show("不能设置指挥官");
               return;
            case 18006:
               if(cmdID == CommandID.TEAM_PK_SIGN)
               {
                  Alarm.show("只有战队指挥官和主将才能报名参加要塞保卫战。");
               }
               else
               {
                  Alarm.show("你的权限不够");
               }
               return;
            case 18007:
               Alarm.show("不在要塞中");
               return;
            case 18008:
               Alarm.show("不能建造该设施");
               return;
            case 18009:
               Alarm.show("你每天只能建造5次，请明天再来吧。");
               return;
            case 103526:
               return;
            case 18010:
               Alarm.show("设施建造次数达到每日上限");
               return;
            case 18011:
               Alarm.show("该设施已经建造完毕，快让你的指挥官来升级设施吧！");
               return;
            case 18012:
               Alarm.show("不能对该设施捐赠");
               return;
            case 18013:
               Alarm.show("设施不需要捐赠此类物资");
               return;
            case 18014:
               Alarm.show("战队成员每天最多可以捐献" + TextFormatUtil.getRedTxt("100") + "个物资，请明天再来吧！");
               return;
            case 18015:
               Alarm.show("设施被捐赠物资超过当日上限");
               return;
            case 18016:
               Alarm.show("设施不再需要这类资源了");
               return;
            case 18017:
               Alarm.show("该设施还不能升级");
               return;
            case 18018:
               Alarm.show("摆放出来的可升级设施超过上限");
               return;
            case 18019:
               Alarm.show("不能设置总部");
               return;
            case 18020:
               Alarm.show("不能购买这个养成型设施");
               return;
            case 18021:
               Alarm.show("不能升级到那种形态");
               return;
            case 18022:
               Alarm.show("所需战队等级不够，还不能升级");
               return;
            case 18023:
               Alarm.show("所需资源不够，还不能升级");
               return;
            case 18024:
               Alarm.show("没有摆放出前置设施");
               return;
            case 18025:
               Alarm.show("该设施仅VIP用户可以购买买/使用");
               return;
            case 18027:
               Alarm.show("你已经为战队提供过超级能量了！");
               return;
            case 18030:
               Alarm.show("你的电池能量已经无法支持保卫战所需的模拟呈现功能，请明天蓄满电池后再来参加保卫战！");
               MapManager.changeMap(1);
               return;
            case 11024:
               Alarm.show("正在精灵对战中");
               return;
            case 18221:
               Alarm.show("你们战队还没有报名参加对抗赛");
               TeamPKManager.closeWait();
               return;
            case 18222:
               Alarm.show("你的战队的其他成员已经报名参加保卫战，请耐心等待比赛集合令提示。");
               TeamPKManager.closeWait();
               return;
            case 18223:
               Alarm.show("不在对抗赛地图中");
               return;
            case 18224:
               Alarm.show("报名签名无效");
               TeamPKManager.closeWait();
               return;
            case 18225:
               return;
            case 18226:
               Alarm.show("屏障还没打开");
               return;
            case 18227:
               Alarm.show("对抗赛已经开始");
               TeamPKManager.closeWait();
               return;
            case 18228:
               Alarm.show("你已经加入了对抗赛，不能再次加入");
               TeamPKManager.closeWait();
               return;
            case 18229:
               Alarm.show("你还没有加入对抗赛");
               return;
            case 18230:
               Alarm.show("本周参加对抗赛的次数已达上限");
               TeamPKManager.closeWait();
               return;
            case 18231:
               Alarm.show("你不是对抗赛的任何一方的成员");
               TeamPKManager.closeWait();
               return;
            case 18232:
               Alarm.show("对抗赛加入成员已达上限");
               TeamPKManager.closeWait();
               return;
            case 18233:
               Alarm.show("你们的队伍还不满足胜利条件");
               return;
            case 18234:
               Alarm.show("你已经没有护盾了");
               return;
            case 18235:
               Alarm.show("当前系统繁忙，请稍后再试");
               TeamPKManager.closeWait();
               return;
            case 18236:
               Alarm.show("战队要塞保卫战只在每周<font color=\'#ff0000\'>五、六、日</font>举行，请各位小赛尔们做好准备，为自己的战队争取荣耀噢！");
               TeamPKManager.closeWait();
               return;
            case 18237:
               Alarm.show("因为逃跑的惩罚规则，你在5分钟内无法再次报名。");
               TeamPKManager.closeWait();
               return;
            case 18238:
               Alarm.show("对战还没有开始");
               TeamPKManager.closeWait();
               MapManager.changeMap(1);
               return;
            case 18239:
               Alarm.show("你今天不能再获得<font color=\'#ff0000\'>露西欧坚钢</font>了");
               return;
            case 220001:
               Alarm.show("时空密码参数错误");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220002:
               Alarm.show("时空密码不存在");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220003:
               Alarm.show("时空密码未激活");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220004:
               Alarm.show("时空密码不在有效期内");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220005:
               Alarm.show("时空密码被冻结");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220006:
               Alarm.show("您输入的时空密码已经使用过");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220007:
               Alarm.show("该种礼物已经被抽取完了");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220008:
               Alarm.show("你当天领取礼物已经达到上限，不能再领取更多");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220009:
               Alarm.show("你已经拥有所有物品，不能再拥有了");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220010:
               Alarm.show("没有礼品");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 220011:
               Alarm.show("内部数据库出错");
               EventManager.dispatchEvent(new Event(TIME_PASSWORD_ERROR));
               return;
            case 210004:
               Alarm.show("系统处理过程中出错");
               return;
            case 210010:
               Alarm.show("商品不存在");
               return;
            case 210011:
               Alarm.show("米米号不存在");
               return;
            case 210012:
               Alarm.show("购买支付密码不正确");
               return;
            case 210013:
               Alarm.show("请求购的买商品数量超出当前商品库存");
               return;
            case 210014:
               Alarm.show("你不是VIP用户，无法购买此商品");
               return;
            case 210015:
            case 210016:
            case 210017:
            case 210019:
               Alarm.show("你不能拥有过多该商品");
               return;
            case 210018:
               Alarm.show("该商品不存在");
               return;
            case 210102:
               Alarm.show("你的米币帐户不存在");
               return;
            case 210104:
               Alarm.show("你的米币帐户未激活");
               return;
            case 210105:
               Alarm.show("你的米币帐户余额不足");
               return;
            case 210106:
               Alarm.show("购买数量出错");
               return;
            case 210107:
               Alarm.show("你的米币帐户超过当月的消费限制了");
               return;
            case 210108:
               Alarm.show("你的米币帐户单笔消费超过限制了");
               return;
            case 210202:
               Alarm.show("你的金豆帐户不存在");
               return;
            case 210204:
               Alarm.show("你的金豆帐户未激活");
               return;
            case 210205:
               Alarm.show("你的金豆帐户余额不足");
               return;
            case 210206:
               Alarm.show("购买数量出错");
               return;
            case 210207:
               Alarm.show("你的金豆帐户超过当月的消费限制了");
               return;
            case 210208:
               Alarm.show("你的金豆帐户单笔消费超过限制了");
               return;
            case 10024:
               Alarm.show("你没有穿上可变形的套装！");
               return;
            case 10504:
               Alarm.show("不能重复注入药丸");
               return;
            case 10505:
               Alarm.show("不能注入过多能量珠");
               return;
            case 500103:
               Alarm.show("登录服务器错误，请尝试登录上次登录的服务器进入游戏",function():void
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("function() { location.reload(); }");
                  }
               },false,true);
               return;
            default:
               if(num > 900)
               {
                  Alarm.show("错误码：" + num);
               }
               return;
         }
         Alarm.show("你现在还没有精灵,没有办法分享教官经验");
      }
   }
}

