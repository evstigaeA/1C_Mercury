
Процедура ЗагрузитьПользователей() Экспорт 
	
	Если ЗначениеЗаполнено(Настройка) Тогда
		ДанныеОбмена = Новый Структура;
		ДанныеОбмена.Вставить("Ключ",Настройка.Ключ);
		ДанныеОбмена.Вставить("ЛогинДляЗагрузкиНСИ",Настройка.ЛогинДляЗагрузкиНСИ);
		ДанныеОбмена.Вставить("ПарольДляЗагрузкиНСИ",Настройка.ПарольДляЗагрузкиНСИ);
		ДанныеОбмена.Вставить("ИдентификаторСервиса",Настройка.ИдентификаторСервиса);
		ДанныеОбмена.Вставить("ИдентификаторХозяйствующегоСубъекта",Настройка.ИдентификаторХозяйствующегоСубъекта);
		ДанныеОбмена.Вставить("СистемаМеркурийЛогин",Пользователь.ПользовательСистемыМеркурий.Логин);
		ДанныеОбмена.Вставить("Успешно",Ложь);
		ДанныеОбмена.Вставить("АдресСервиса",Настройка.АдресСервиса);
		ЗагрузитьПользователейМеркурия(ДанныеОбмена);		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ЗагрузитьПользователейМеркурия(пНастройка)
	
	пПользователь = "Test";
	ВидСервераВетисAPI = ОбщегоНазначенияУВССервер.ВидСервераВетисAPI();
	Если ВидСервераВетисAPI = Перечисления.ВидыСерверовВетисAPI.Основной Тогда
		ОпределениеWS = WSСсылки.EnterpriseService_v2_1_production.ПолучитьWSОпределения();
	Иначе
		ОпределениеWS = WSСсылки.EnterpriseService_v2_1_pilot.ПолучитьWSОпределения();  
	КонецЕсли;
	
	МассивURI = Новый Массив;  
	МассивURI.Добавить("http://api.vetrf.ru/schema/cdm/application/ws-definitions");  
	МассивURI.Добавить("http://api.vetrf.ru/schema/cdm/base/ws-definitions");
	
	ФабрикаWS = Новый ФабрикаXDTO(ОпределениеWS.ФабрикаXDTO.ЭкспортМоделиXDTO(МассивURI), ФабрикаXDTO.Пакеты);  
	  
	Пакеты = Новый Массив;  
	Пакеты.Добавить(ФабрикаXDTO.Пакеты.Получить("http://api.vetrf.ru/schema/cdm/mercury/g2b/applications/v2"));  
	Пакеты.Добавить(ФабрикаXDTO.Пакеты.Получить("http://schemas.xmlsoap.org/soap/envelope/"));  
		
	Для Каждого Пакет Из ФабрикаWS.Пакеты Цикл  
		Пакеты.Добавить(Пакет);  
	КонецЦикла;  
	
	ФабрикаXD = Новый ФабрикаXDTO(, Пакеты);  
	
	Строка = "
	|<SOAP-ENV:Envelope xmlns:bs=""http://api.vetrf.ru/schema/cdm/base""
	|xmlns:merc=""http://api.vetrf.ru/schema/cdm/mercury/g2b/applications/v2""
	|xmlns:apldef=""http://api.vetrf.ru/schema/cdm/application/ws-definitions"" 
	|xmlns:apl=""http://api.vetrf.ru/schema/cdm/application"" 
	|xmlns:vd=""http://api.vetrf.ru/schema/cdm/mercury/vet-document/v2"" 
	|xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/"">	
	|<SOAP-ENV:Header/>
	|<SOAP-ENV:Body>
	|<apldef:submitApplicationRequest>
	|<apldef:apiKey></apldef:apiKey>
	|<apl:application>
	|<apl:serviceId>mercury-g2b.service:2.0</apl:serviceId>
	|<apl:issuerId></apl:issuerId>
	|<apl:issueDate></apl:issueDate>
	|<apl:data>
	|<merc:getBusinessEntityUserListRequest>
	|<merc:localTransactionId></merc:localTransactionId>
	|<merc:initiator>
	|<vd:login></vd:login>
	|</merc:initiator>
	|<bs:listOptions>
	|<bs:count>10</bs:count>
	|<bs:offset>0</bs:offset>
	|</bs:listOptions>
	|</merc:getBusinessEntityUserListRequest>
	|</apl:data>
	|</apl:application>
	|</apldef:submitApplicationRequest>
	|</SOAP-ENV:Body>
	|</SOAP-ENV:Envelope>";
		
	СтрокаПодтвереждения = "
	|<SOAP-ENV:Envelope xmlns:bs=""http://api.vetrf.ru/schema/cdm/base"" 
	|xmlns:merc=""http://api.vetrf.ru/schema/cdm/mercury/g2b/applications/v2"" 
	|xmlns:apldef=""http://api.vetrf.ru/schema/cdm/application/ws-definitions"" 
	|xmlns:apl=""http://api.vetrf.ru/schema/cdm/application"" 
	|xmlns:vd=""http://api.vetrf.ru/schema/cdm/mercury/vet-document/v2"" 
	|xmlns:SOAP-ENV=""http://schemas.xmlsoap.org/soap/envelope/"">
	|<SOAP-ENV:Header/>
	|<SOAP-ENV:Body>
	|<apldef:receiveApplicationResultRequest>
	|<apldef:apiKey></apldef:apiKey>
	|<apldef:issuerId></apldef:issuerId>
	|<apldef:applicationId></apldef:applicationId>
	|</apldef:receiveApplicationResultRequest>
	|</SOAP-ENV:Body>
	|</SOAP-ENV:Envelope>";
	
	ОтветXML = Новый ЧтениеXML;  
	ОтветXML.УстановитьСтроку(Строка);
	EnvelopeDO = ФабрикаXD.ПрочитатьXML(ОтветXML, ФабрикаXD.Тип("http://schemas.xmlsoap.org/soap/envelope/", "Envelope"));
	
	submitApplicationRequest = EnvelopeDO.Body.submitApplicationRequest;
	submitApplicationRequest.apiKey = пНастройка.Ключ;
	
	application = submitApplicationRequest.application;
	application.issuerId = пНастройка.ИдентификаторХозяйствующегоСубъекта;
	application.issueDate = ФабрикаXD.Создать(ФабрикаXD.Тип("http://www.w3.org/2001/XMLSchema", "dateTime"),ТекущаяДата());
	
	data = application.data;
	data.getBusinessEntityUserListRequest.localTransactionId = ФабрикаXD.Создать(ФабрикаXD.Тип("http://api.vetrf.ru/schema/cdm/base","Identifier"), Строка(Новый УникальныйИдентификатор));
		
	ТелоXML = Новый ЗаписьXML;    
	ТелоXML.УстановитьСтроку("UTF-8");    
	ФабрикаXD.ЗаписатьXML(ТелоXML, EnvelopeDO);   
	Строка = ТелоXML.Закрыть();
	
	ЗапросWeb = Новый HTTPЗапрос("platform/services/2.0/ApplicationManagementService");
	ЗапросWeb.УстановитьТелоИзСтроки(Строка);
	
	Если ОбщегоНазначения.ЭтоLinuxСервер() Тогда
		ssl1 = Новый ЗащищенноеСоединениеOpenSSL();
	Иначе
		ssl1 = Новый ЗащищенноеСоединениеOpenSSL(Новый СертификатКлиентаWindows(), Новый СертификатыУдостоверяющихЦентровWindows());
	КонецЕсли;
	СоединениеWeb = Новый HTTPСоединение(пНастройка.АдресСервиса, , пНастройка.ЛогинДляЗагрузкиНСИ, пНастройка.ПарольДляЗагрузкиНСИ,,0,ssl1);
	//С портом 8002 отправляется запрос в тестовый контур
	//СоединениеWeb = Новый HTTPСоединение("api2.vetrf.ru", 8002, пНастройка.ЛогинДляЗагрузкиНСИ, пНастройка.ПарольДляЗагрузкиНСИ,,0,ssl1);
	
	ОтветWeb = СоединениеWeb.ОтправитьДляОбработки(ЗапросWeb);
	Если (ОтветWeb.КодСостояния = 200) Тогда // значит, все ок  
		// десериализуем  
		ОтветXML = Новый ЧтениеXML;
		ОтветXML.УстановитьСтроку(ОтветWeb.ПолучитьТелоКакСтроку("UTF-8"));  
		
		MercAppDO = ФабрикаXD.ПрочитатьXML(ОтветXML, EnvelopeDO.Тип()).Body.submitApplicationResponse.application;  
		
		// возможные статусы:  
		// ACCEPTED   Заявка принята.  
		// IN_PROCESS Заявка обрабатывается.  
		// COMPLETED  Заявка успешно обработана.  
		// REJECTED   Заявка отклонена.  
		Если (MercAppDO.status = "ACCEPTED") Или (MercAppDO.status = "IN_PROCESS") Тогда
			
			ДМ_ОбщегоНазначенияКлиентСервер.Пауза(10);
			
			ОтветXML = Новый ЧтениеXML;  
			ОтветXML.УстановитьСтроку(СтрокаПодтвереждения);
			EnvelopeDO = ФабрикаXD.ПрочитатьXML(ОтветXML, ФабрикаXD.Тип("http://schemas.xmlsoap.org/soap/envelope/", "Envelope"));
			ЗаполнитьЗначенияСвойств(EnvelopeDO.Body.receiveApplicationResultRequest, MercAppDO);
			EnvelopeDO.Body.receiveApplicationResultRequest.apiKey = ФабрикаXD.Создать(ФабрикаXD.Тип("http://www.w3.org/2001/XMLSchema", "string"), пНастройка.Ключ);
			ТелоXML = Новый ЗаписьXML;
			ТелоXML.УстановитьСтроку("UTF-8");    
			ФабрикаXD.ЗаписатьXML(ТелоXML, EnvelopeDO);   
			Строка = ТелоXML.Закрыть();
			ЗапросWeb.УстановитьТелоИзСтроки(Строка);
			ОтветWeb = СоединениеWeb.ОтправитьДляОбработки(ЗапросWeb);
			Если (ОтветWeb.КодСостояния = 200) Тогда // значит, все ок  
				// десериализуем  
				ОтветXML = Новый ЧтениеXML;
				
				ОтветXML.УстановитьСтроку(ОтветWeb.ПолучитьТелоКакСтроку("UTF-8"));  
				
				MercAppDO = ФабрикаXD.ПрочитатьXML(ОтветXML, EnvelopeDO.Тип());
				лАпп = MercAppDO.Body.receiveApplicationResultResponse.application;
				
				Если лАпп.status = "COMPLETED" Тогда
					Результат = Результат+пПользователь+": "+лАпп.status+Символы.ПС;
					пНастройка.Успешно = Истина;
				ИначеЕсли лАпп.status = "REJECTED" Тогда
					Результат = Результат+пПользователь+": "+лАпп.status+Символы.ПС;
					пНастройка.Успешно = Ложь;
				ИначеЕсли лАпп.status = "IN_PROCESS" Тогда
					
					ДМ_ОбщегоНазначенияКлиентСервер.Пауза(10);
					ОтветWeb = СоединениеWeb.ОтправитьДляОбработки(ЗапросWeb);
					Если лАпп.status = "COMPLETED" Тогда
						Результат = Результат+пПользователь+": "+лАпп.status+Символы.ПС;
						пНастройка.Успешно = Истина;
					ИначеЕсли лАпп.status = "REJECTED" Тогда
						Результат = Результат+пПользователь+": "+лАпп.status+Символы.ПС;
						пНастройка.Успешно = Ложь;
					ИначеЕсли лАпп.status = "IN_PROCESS" Тогда
						Результат = Результат+пПользователь+": "+лАпп.status+"/выполнено 2 попытки, все еще обрабатывается"+Символы.ПС;
						пНастройка.Успешно = Истина;
					Иначе
						а = 1;//для отладки
						
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			Результат = Результат+пПользователь+": "+лАпп.status+"/при попытке подачи заявки на получение прав"+Символы.ПС;
			пНастройка.Успешно = Ложь;
		КонецЕсли;  
	Иначе
		Результат = Результат+пПользователь+": Не удалось получить корректный ответ. Код ответа сервера:"+ОтветWeb.КодСостояния+Символы.ПС;
		пНастройка.Успешно = Ложь;
		
	КонецЕсли;
	f = 1;
	
КонецПроцедуры	