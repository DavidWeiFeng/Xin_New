package org.taomee.manager
{
   import com.robot.core.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.net.SharedObject;
   import flash.utils.*;
   import org.taomee.ds.*;
   
   public class TaomeeManager
   {
      
      private static var _root:DisplayObjectContainer;
      
      public static var stageHeight:int;
      
      public static var stageWidth:int;
      
      private static var _stage:Stage;
      
      public static var md5List:HashMap;
      
      public static var fightSpeed:Number = 1;
      
      public static var nonoSpriteTrack:Number = 0;
      
      public function TaomeeManager()
      {
         super();
      }
      
      public static function set root(_arg_1:DisplayObjectContainer) : void
      {
         _root = _arg_1;
      }
      
      public static function get root() : DisplayObjectContainer
      {
         return _root;
      }
      
      public static function get stage() : Stage
      {
         return _stage;
      }
      
      public static function set stage(_arg_1:Stage) : void
      {
         _stage = _arg_1;
      }
      
      public static function setup(_arg_1:DisplayObjectContainer, _arg_2:Stage) : void
      {
         _root = _arg_1;
         _stage = _arg_2;
         md5List = new HashMap();
         md5List.add("1","66b6e29fd6757f8919c3e6c9f0e32f15");
         md5List.add("4","f232ae0dbb64817e6ba698c4eb85ade5");
         md5List.add("7","688638ffa8b4a7e67218eb03f5793587");
         md5List.add("19","38ff4118b30751bf9f4f9eab1b02a4e5");
         md5List.add("27","5997c8ddf4ec12af7ae0c61f641d0cef");
         md5List.add("53","24b9aca9481f0cf93b643fe9644cc827");
         md5List.add("59","a9cf153678da3249c1bb51a9edc1c79c");
         md5List.add("62","99b9c52eccd88e5d82bc695c6e960d94");
         md5List.add("65","5ca7019e2c91f52ba7912a39c5ed82b0");
         md5List.add("102","ac5a0406a162e68ad71dd422eafd0971");
         md5List.add("108","d5fee59874ea44986fde1efeda2e31a8");
         md5List.add("133","b8fd6c6799af5739e9f0fe5bc8dab000");
         md5List.add("143","f0cfbaad6ae24213d9aad1ccf20e2031");
         md5List.add("164","547c846ba34a61516d1dba863bfa367e");
         md5List.add("203","2a861e16d6ed09f14c7b56ed2563a22e");
         md5List.add("237","0fef233a05a37ac6ba61f85e5ca31705");
         md5List.add("240","f4932ed584c305b965ddd28ab4dd62b1");
         md5List.add("254","71ec22161c03ff09836b7a26d6e1cdec");
         md5List.add("269","8cfd9c98640d2773826246376ec2ac5f");
         md5List.add("10","82b1f4a475d64e81531838cd3592df78");
         md5List.add("13","2043e044452b9d555525e4fc9926fa15");
         md5List.add("16","940b318f3dee75c722be5a5e527d6db1");
         md5List.add("22","7576e71c5a5a0ad0d14f83f009c163c6");
         md5List.add("25","1bf2aedb5f1b029bc88a2e599651578a");
         md5List.add("30","f14470e8b78ea2a70ec1e32179c0cfa9");
         md5List.add("33","707bdc628d180fccf9b55171f2f00319");
         md5List.add("35","ef520e8d8e1c02691d3f9ab108bf92f7");
         md5List.add("38","dcc5b1031a61f16482e6e4562ecdcaf9");
         md5List.add("43","9cdc6e4c486e1ac839739ccb2f9afc3a");
         md5List.add("51","835f564950f7d78403a30b66abe0c735");
         md5List.add("89","47f136d1ab01a9f4e95c046c17d04d44");
         md5List.add("97","317604ea85d021afc5347b8bfece517c");
         md5List.add("105","62756ea34b5a0d7af6be664cb53d69e5");
         md5List.add("116","f33afcf77a8279d13746cc8a2e622f07");
         md5List.add("119","173c29b370ac67349e8a046ecbe48255");
         md5List.add("136","fa06c700e70446447d21a7d4382e8160");
         md5List.add("145","4ca4fba12b99a320c02612075c453b7b");
         md5List.add("156","72d8acf37614e2e4ff3fcab6451a5b3e");
         md5List.add("158","4767a91d795b034e3f6c719082c71c3f");
         md5List.add("172","f53d46db6384c8550702d80db02a0447");
         md5List.add("184","f192632dedda312bd3fe64cde40bc6bf");
         md5List.add("185","26f5263959aa4df4f8e477d696bb4a5d");
         md5List.add("188","9b93a9fbe67c76e8bc93ea42bc558ea2");
         md5List.add("198","8efc1f22db21120c522157e03ae4ebc2");
         md5List.add("205","9003ccc4ca3f6db11ab887daa380d9bb");
         md5List.add("208","1b5b16de9f19659c059e41e47d949c8e");
         md5List.add("211","76a287e6fbc858d9a1f8818fcbbb0391");
         md5List.add("228","97c0d5de5c9a5b8412bac33a4076adf4");
         md5List.add("232","de17778bb1dda3ad00295ffda878b88a");
         md5List.add("235","3f752ca4f68d2bc19e9085492e1df6fa");
         md5List.add("249","20d3e18914c4f404a955e6ed65290f79");
         md5List.add("252","28dbbdd8c84f343a6b63c3b1dc280767");
         md5List.add("257","390ae6771d957df3ad58307de94bd841");
         md5List.add("265","64626852c8d2b1a495a8e88618948899");
         md5List.add("267","0da74973842bf787404b71a6ff13725d");
         md5List.add("278","04b5ed3a09afd2277b2e2f2e0a88ce67");
         md5List.add("291","af482f8026e94caaf01ed20ce5015632");
      }
      
      public static function initFightSpeed() : void
      {
         var _local_1:SharedObject = SOManager.getUserSO(SOManager.LOCAL_CONFIG);
         if(!_local_1.data["speed"])
         {
            _local_1.data["speed"] = 1;
            SOManager.flush(_local_1);
         }
         else
         {
            fightSpeed = _local_1.data["speed"];
         }
         TaomeeManager.stage.frameRate = 24 * fightSpeed;
         MainManager.getStage().frameRate = 24 * fightSpeed;
      }
      
      public static function setFightSpeed(e:int) : void
      {
         var _local_1:SharedObject = SOManager.getUserSO(SOManager.LOCAL_CONFIG);
         _local_1.data["speed"] = e;
         SOManager.flush(_local_1);
         fightSpeed = e;
         TaomeeManager.stage.frameRate = 24 * fightSpeed;
         _stage.frameRate = 24 * fightSpeed;
      }
      
      public static function xinCheck(_arg_1:int, _arg_2:String) : void
      {
         var _local_6:int = 0;
         var _local_3:String = _arg_2;
         var _local_4:ByteArray = new ByteArray();
         var _local_5:int = _local_3.length;
         _local_5 = _local_3.length;
         _local_6 = 0;
         while(_local_6 < _local_5)
         {
            _local_4.writeUTFBytes(_local_3.charAt(_local_6));
            _local_6++;
         }
         _local_4.writeUTFBytes("0");
      }
   }
}

