package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _7c729e9b20e8957a2020269e0f070cd5476cb87055ffdef7291fae6b0a7aeb76_flash_display_Sprite extends Sprite
   {
      
      public function _7c729e9b20e8957a2020269e0f070cd5476cb87055ffdef7291fae6b0a7aeb76_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

