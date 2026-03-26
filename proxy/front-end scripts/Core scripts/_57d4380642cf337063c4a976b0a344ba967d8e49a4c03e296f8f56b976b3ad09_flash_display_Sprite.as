package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _57d4380642cf337063c4a976b0a344ba967d8e49a4c03e296f8f56b976b3ad09_flash_display_Sprite extends Sprite
   {
      
      public function _57d4380642cf337063c4a976b0a344ba967d8e49a4c03e296f8f56b976b3ad09_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... _args) : void
      {
         Security.allowDomain.apply(null,_args);
      }
      
      public function allowInsecureDomainInRSL(... _args) : void
      {
         Security.allowInsecureDomain.apply(null,_args);
      }
   }
}

