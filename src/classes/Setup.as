package classes
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class Setup extends EventDispatcher
	{
		private static var serviceUiString:String;
		private static var ManagerEventNameClass:String;
		private static var projectAddress:String;
		public function Setup(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function load(ProjectAddress_p:String):void
		{
			//reade Manager for get name var
			projectAddress = ProjectAddress_p;
			var managerPath:File = File.applicationDirectory.resolvePath(projectAddress+'/project/src/mainClass/core/'+'Manager.as')
			var managerByte:ByteArray = FileManager.loadFile(managerPath);
				managerByte.position = 0;
			var managerString:String = managerByte.readUTFBytes(managerByte.length);
			
			//get Manager events Name classs
			ManagerEventNameClass = managerString.split(' ').join('');
			ManagerEventNameClass = ManagerEventNameClass.split('dispatchEvent(new')[1];
			ManagerEventNameClass = ManagerEventNameClass.split('(')[0];
			trace('ManagerEventNameClass :',ManagerEventNameClass);
			 
			
			

		}
		
		/**service page ui:
		 * 1-one dynamic links
		 * 2-linkItem*/
		public static function serviceFormat1(ServiceName_p:String):void
		{
			
			var serviceNameLowerCase:String = ServiceName_p.toLowerCase();
			var claseName:String = ServiceName_p+'Ui';
			
			var serviceUiPath:File = File.applicationDirectory.resolvePath('Data/ServiceUi.text'); 
			var serviceUiByte:ByteArray = FileManager.loadFile(serviceUiPath);
			serviceUiByte.position = 0 ;
			serviceUiString = serviceUiByte.readUTFBytes(serviceUiByte.length);
			
			
			serviceUiString = serviceUiString.split('className').join(claseName);
			serviceUiString = serviceUiString.split('serviceName').join('service_'+serviceNameLowerCase);
			serviceUiString = serviceUiString.split('serviceClass').join(ServiceName_p);
			serviceUiString = serviceUiString.split('ManagerEventNameClass').join(ManagerEventNameClass);
			
			
			var serviceWriteBytes:ByteArray =new ByteArray();;
			serviceWriteBytes.position = 0;
			serviceWriteBytes.writeUTFBytes(serviceUiString);
			var serviceUiWriteBytesPath:File = File.applicationDirectory.resolvePath(projectAddress+'/project/src/ui/pages/'+claseName+'.as'); 
			FileManager.seveFile(serviceUiWriteBytesPath,serviceWriteBytes);
			//trace('serviseUiString :',serviceUiString);
		}
	}
}