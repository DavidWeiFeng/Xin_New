package com.robot.app.help
{
   import com.robot.app.newspaper.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   
   public class HelpManager
   {
      
      private static var panel:AppModel;
      
      public function HelpManager()
      {
         super();
      }
      
      public static function show(_arg_1:uint) : void
      {
         var _local_2:Array = HelpXMLInfo.getIdList();
         if(_local_2.indexOf(_arg_1) < 0)
         {
            Alarm.show("帮助XML配置ID错误。");
            return;
         }
         var _local_3:uint = uint(HelpXMLInfo.getType(_arg_1));
         switch(_local_3)
         {
            case 0:
               showPanel(_arg_1);
               return;
            case 1:
               showTalk(_arg_1);
               return;
            case 2:
               showMes(_arg_1);
               return;
            default:
               Alarm.show("帮助XML配置类型错误。");
               return;
         }
      }
      
      private static function showMes(_arg_1:uint) : void
      {
         var _local_2:uint = uint(HelpXMLInfo.getComment(_arg_1));
         switch(_local_2)
         {
            case 1:
               ContributeAlert.show(ContributeAlert.NEWS_TYPE);
               return;
            case 2:
               ContributeAlert.show(ContributeAlert.SHIPER_TYPE);
               return;
            case 3:
               ContributeAlert.show(ContributeAlert.DOCTOR_TYPE);
               return;
            case 4:
               ContributeAlert.show(ContributeAlert.NONO);
               return;
            case 5:
               ContributeAlert.show(ContributeAlert.LYMAN);
               return;
            default:
               Alarm.show("帮助XML配置写信错误");
               return;
         }
      }
      
      public static function nullPanel() : void
      {
         panel = null;
      }
      
      private static function showPanel(_arg_1:uint) : void
      {
         var _local_2:String = HelpXMLInfo.getComment(_arg_1);
         var _local_3:Array = HelpXMLInfo.getItemAry(_arg_1);
         var _local_4:Boolean = Boolean(HelpXMLInfo.getIsBack(_arg_1));
         var _local_5:Object = new Object();
         _local_5.str = _local_2;
         _local_5.arr = _local_3;
         _local_5.isBack = _local_4;
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getHelpModule("HelpListPanel"),"正在打开帮助信息");
            panel.setup();
            panel.init(_local_5);
            panel.show();
         }
         else
         {
            panel.hide();
            panel.init(_local_5);
            panel.show();
         }
      }
      
      private static function enterFrameHandler(_arg_1:Event) : void
      {
         var _local_2:MovieClip = _arg_1.currentTarget as MovieClip;
         if(_local_2.currentFrame == 70)
         {
            _local_2.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            LevelManager.appLevel.removeChild(_local_2);
         }
      }
      
      private static function arrowRot(_arg_1:MovieClip, _arg_2:Point) : void
      {
         var _local_3:int = 0;
         var _local_4:Number = _arg_2.x;
         var _local_5:Number = _arg_2.y;
         if(!(_local_4 > 288 && _local_4 < 711 && _local_5 > 167 && _local_5 < 405))
         {
            _local_3 = int(int(Math.atan2(_local_5 - 280,_local_4 - 480) * 180 / Math.PI));
            _arg_1.rotation = _local_3 + 90;
         }
         _arg_1.x = _local_4;
         _arg_1.y = _local_5;
      }
      
      private static function showTalk(id:uint) : void
      {
         var mapid:uint = 0;
         var point:Point = null;
         var myArrow:MovieClip = null;
         var str:String = null;
         mapid = 0;
         mapid = uint(HelpXMLInfo.getMapId(id));
         if(!mapid || mapid == MainManager.actorInfo.mapID)
         {
            point = HelpXMLInfo.getArrowPoint(id);
            myArrow = CoreAssetsManager.getMovieClip("HelpUI_Arrow");
            LevelManager.appLevel.addChild(myArrow);
            arrowRot(myArrow,point);
            myArrow.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
         }
         else
         {
            str = HelpXMLInfo.getComment(id);
            Alert.show(str,function():void
            {
               MapManager.changeMap(mapid);
            },null);
         }
      }
      
      public static function getType(_arg_1:uint) : uint
      {
         return HelpXMLInfo.getType(_arg_1);
      }
      
      public static function getObj(_arg_1:uint) : Object
      {
         var _local_2:String = HelpXMLInfo.getComment(_arg_1);
         var _local_3:Array = HelpXMLInfo.getItemAry(_arg_1);
         var _local_4:Boolean = Boolean(HelpXMLInfo.getIsBack(_arg_1));
         var _local_5:Object = new Object();
         _local_5.str = _local_2;
         _local_5.arr = _local_3;
         _local_5.isBack = _local_4;
         return _local_5;
      }
      
      public static function getBack(_arg_1:uint) : Boolean
      {
         return HelpXMLInfo.getIsBack(_arg_1);
      }
   }
}

