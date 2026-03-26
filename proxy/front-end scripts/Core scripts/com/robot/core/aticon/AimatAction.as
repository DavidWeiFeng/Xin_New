package com.robot.core.aticon
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimat;
   import com.robot.core.aimat.ThrowController;
   import com.robot.core.aimat.ThrowPropsController;
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.ISprite;
   import com.robot.core.utils.Direction;
   import flash.geom.Point;
   import org.taomee.utils.GeomUtil;
   import org.taomee.utils.Utils;
   
   public class AimatAction
   {
      
      private static const PATH:String = "com.robot.app.aimat.Aimat_";
      
      public function AimatAction()
      {
         super();
      }
      
      public static function execute(_arg_1:uint, _arg_2:uint, _arg_3:uint, _arg_4:ISprite, _arg_5:Point) : void
      {
         var _local_6:Class = null;
         var _local_7:Point = null;
         var _local_8:IAimat = null;
         var _local_9:AimatInfo = null;
         if(_arg_1 != 0)
         {
            if(_arg_1 == 600001)
            {
               new ThrowController(_arg_1,_arg_3,_arg_4,_arg_5);
            }
            else
            {
               new ThrowPropsController(_arg_1,_arg_3,_arg_4,_arg_5);
            }
            return;
         }
         var _local_10:uint = AimatXMLInfo.getTypeId(_arg_2);
         if(_local_10 == 0)
         {
            _local_6 = Utils.getClass(PATH + _arg_2.toString());
         }
         else
         {
            _local_6 = Utils.getClass(PATH + _local_10);
         }
         if(Boolean(_local_6))
         {
            _local_7 = _arg_4.pos.clone();
            _local_7.y -= 40;
            _arg_4.direction = Direction.angleToStr(GeomUtil.pointAngle(_local_7,_arg_5));
            _local_8 = new _local_6();
            _local_9 = new AimatInfo(_arg_2,_arg_3,_local_7,_arg_5);
            AimatController.dispatchEvent(AimatEvent.PLAY_START,_local_9);
            _local_8.execute(_local_9);
         }
      }
      
      public static function execute2(_arg_1:uint, _arg_2:uint, _arg_3:Point, _arg_4:Point) : void
      {
         var _local_5:IAimat = null;
         var _local_6:AimatInfo = null;
         var _local_7:Class = Utils.getClass(PATH + _arg_1.toString());
         if(Boolean(_local_7))
         {
            _local_5 = new _local_7();
            _local_6 = new AimatInfo(_arg_1,_arg_2,_arg_3,_arg_4);
            AimatController.dispatchEvent(AimatEvent.PLAY_START,_local_6);
            _local_5.execute(_local_6);
         }
      }
   }
}

