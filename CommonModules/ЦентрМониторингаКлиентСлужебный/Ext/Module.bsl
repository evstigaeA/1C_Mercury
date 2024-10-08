﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриВыполненииСтандартныхПериодическихПроверокНаКлиенте(Параметры) Экспорт
    
    Окна = ПолучитьОкна();
    АктивныхОкон = 0;
	Если Окна <> Неопределено Тогда
		Для Каждого ТекОкно Из Окна Цикл
	        Если Не ТекОкно.Основное Тогда
	            АктивныхОкон = АктивныхОкон + 1;
	        КонецЕсли;
		КонецЦикла;
	КонецЕсли;
    
    ПараметрыПриложенияЦентрМониторинга = ПолучитьПараметрыПриложения();
    ПараметрыПриложенияЦентрМониторинга["ИнформацияКлиента"].Вставить("АктивныхОкон", АктивныхОкон);
    
    Параметры.Вставить("ЦентрМониторинга", Новый ФиксированноеСоответствие(ПараметрыПриложенияЦентрМониторинга));
    
    Замеры = Новый Соответствие;
    Замеры.Вставить(0, Новый Массив);
    Замеры.Вставить(1, Новый Соответствие);
    Замеры.Вставить(2, Новый Соответствие);
    ПараметрыПриложенияЦентрМониторинга.Вставить("Замеры", Замеры);
    
КонецПроцедуры

Процедура ПослеВыполненияСтандартныхПериодическихПроверокНаКлиенте(Параметры) Экспорт
    
    ПараметрыПриложенияЦентрМониторинга = ПолучитьПараметрыПриложения();
    ПараметрыПриложенияЦентрМониторинга.Вставить("РегистрироватьБизнесСтатистику", Параметры.ЦентрМониторинга["РегистрироватьБизнесСтатистику"]);
	
	Если Параметры.ЦентрМониторинга.Получить("ЗапросНаПолучениеДампов") = Истина Тогда
		ОповеститьЗапросНаПолучениеДампов();
		УстановитьПараметрыПриложенияЦентрМониторинга("ЗапросПолныхДамповВыведен", Истина);
	КонецЕсли;
	Если Параметры.ЦентрМониторинга.Получить("ЗапросНаОтправкуДампов") = Истина Тогда
		ИнформацияОДампах = Параметры.ЦентрМониторинга.Получить("ИнформацияОДампах");
		// Проверяем, было ли сообщение выведено ранее.
		Если ИнформацияОДампах <> ПараметрыПриложенияЦентрМониторинга["ИнформацияОДампах"] Тогда
			ОповеститьЗапросНаОтправкуДампов();
			УстановитьПараметрыПриложенияЦентрМониторинга("ИнформацияОДампах", ИнформацияОДампах);
		КонецЕсли;
	КонецЕсли;
        
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание этой же процедуры в общем модуле
// ОбщегоНазначенияКлиентПереопределяемый.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
    
    ЦентрМониторингаПараметрыПриложения = ПолучитьПараметрыПриложения();
	
	Если Не ЦентрМониторингаПараметрыПриложения["ИнформацияКлиента"]["ПараметрыКлиента"]["ВыводитьЗапросПолныхДампов"] = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЦентрМониторингаПараметрыПриложения["ИнформацияКлиента"]["ПараметрыКлиента"]["ЗапросНаПолучениеДампов"] = Истина Тогда
		ПодключитьОбработчикОжидания("ЦентрМониторингаЗапросНаСборИОтправкуДампов",90, Истина);
		УстановитьПараметрыПриложенияЦентрМониторинга("ЗапросПолныхДамповВыведен", Истина);
	КонецЕсли;
	Если ЦентрМониторингаПараметрыПриложения["ИнформацияКлиента"]["ПараметрыКлиента"]["ЗапросНаОтправку"] = Истина Тогда
		ПодключитьОбработчикОжидания("ЦентрМониторингаЗапросНаОтправкуДампов",90, Истина);
		ИнформацияОДампах = ЦентрМониторингаПараметрыПриложения["ИнформацияКлиента"]["ПараметрыКлиента"]["ИнформацияОДампах"];
		УстановитьПараметрыПриложенияЦентрМониторинга("ИнформацияОДампах", ИнформацияОДампах);
	КонецЕсли;
	   
КонецПроцедуры

Функция ПолучитьПараметрыПриложения() Экспорт
    
    Если ПараметрыПриложения = Неопределено Тогда
    	ПараметрыПриложения = Новый Соответствие;
    КонецЕсли;
    
    ИмяПараметра = "СтандартныеПодсистемы.ЦентрМониторинга";
    Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
        
        ПараметрыКлиента = ПараметрыКлиента();
        
        ПараметрыПриложения.Вставить(ИмяПараметра, Новый Соответствие);
        ЦентрМониторингаПараметрыПриложения = ПараметрыПриложения[ИмяПараметра];
        ЦентрМониторингаПараметрыПриложения.Вставить("РегистрироватьБизнесСтатистику", ПараметрыКлиента["РегистрироватьБизнесСтатистику"]);
		ЦентрМониторингаПараметрыПриложения.Вставить("ЗапросПолныхДамповВыведен", ПараметрыКлиента["ЗапросПолныхДамповВыведен"]);
		ЦентрМониторингаПараметрыПриложения.Вставить("ИнформацияОДампах", ПараметрыКлиента["ИнформацияОДампах"]);		
		
        Замеры = Новый Соответствие;
        Замеры.Вставить(0, Новый Массив);
        Замеры.Вставить(1, Новый Соответствие);
        Замеры.Вставить(2, Новый Соответствие);
        ЦентрМониторингаПараметрыПриложения.Вставить("Замеры", Замеры);
        
        ЦентрМониторингаПараметрыПриложения.Вставить("ИнформацияКлиента", ПолучитьИнформациюКлиента());
        
    Иначе
        
        ЦентрМониторингаПараметрыПриложения = ПараметрыПриложения["СтандартныеПодсистемы.ЦентрМониторинга"];
                       
    КонецЕсли;
    
    Возврат ЦентрМониторингаПараметрыПриложения; 
    
КонецФункции

Функция ПолучитьИнформациюКлиента()
    
    ИнформацияКлиента = Новый Соответствие;
    
    ИнформацияЭкраны = Новый Массив;
    ЭкраныКлиента = ПолучитьИнформациюЭкрановКлиента();
    Для Каждого ТекЭкран Из ЭкраныКлиента Цикл
        ИнформацияЭкраны.Добавить(РазрешениеЭкранаВСтроку(ТекЭкран));
    КонецЦикла;
    
    ИнформацияКлиента.Вставить("ЭкраныКлиента", ИнформацияЭкраны);
    ИнформацияКлиента.Вставить("ПараметрыКлиента", ПараметрыКлиента());
    ИнформацияКлиента.Вставить("ИнформацияОСистеме", ПолучитьИнформациюОСистеме());
    ИнформацияКлиента.Вставить("АктивныхОкон", 0);
    
    Возврат ИнформацияКлиента;
    
КонецФункции

Функция РазрешениеЭкранаВСтроку(Экран)
    
    Возврат Формат(Экран.Ширина, "ЧГ=0") + "x" + Формат(Экран.Высота, "ЧГ=0");
    
КонецФункции

Функция ПараметрыКлиента()
    
    ПараметрыКлиента = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске(),"ЦентрМониторинга");
    Если ПараметрыКлиента = Неопределено Тогда
        ПараметрыКлиента = Новый Структура;
		ПараметрыКлиента.Вставить("ЧасовойПоясСеанса", Неопределено);
		ПараметрыКлиента.Вставить("ХешПользователя", Неопределено);
		ПараметрыКлиента.Вставить("РегистрироватьБизнесСтатистику", Ложь);
		ПараметрыКлиента.Вставить("ВыводитьЗапросПолныхДампов", Ложь);
		ПараметрыКлиента.Вставить("ЗапросПолныхДамповВыведен", Ложь);
		ПараметрыКлиента.Вставить("ИнформацияОДампах", "");
		ПараметрыКлиента.Вставить("ЗапросНаПолучениеДампов", Ложь);
		ПараметрыКлиента.Вставить("ЗапросНаОтправку", Ложь);
    КонецЕсли;
    
    ПараметрыКлиентаИнформация = Новый Соответствие;
    Для Каждого ТекПараметр Из ПараметрыКлиента Цикл
        ПараметрыКлиентаИнформация.Вставить(ТекПараметр.Ключ, ТекПараметр.Значение);
    КонецЦикла;
        
    Возврат ПараметрыКлиентаИнформация; 
        
КонецФункции

Функция ПолучитьИнформациюОСистеме()
    
    СисИнфо = Новый СистемнаяИнформация();
    
    СисИнфоИнформация = Новый Соответствие;
    СисИнфоИнформация.Вставить("ВерсияОС", СтрЗаменить(СисИнфо.ВерсияОС, ".", "☺"));
    СисИнфоИнформация.Вставить("ОперативнаяПамять", Формат((ЦЕЛ(СисИнфо.ОперативнаяПамять/512) + 1) * 512, "ЧГ=0"));
    СисИнфоИнформация.Вставить("Процессор", СтрЗаменить(СисИнфо.Процессор, ".", "☺"));
    СисИнфоИнформация.Вставить("ТипПлатформы", СтрЗаменить(Строка(СисИнфо.ТипПлатформы), ".", "☺"));
        
    ИнформацияПрограммыПросмотра = "";
    #Если ТолстыйКлиентУправляемоеПриложение Тогда
        ИнформацияПрограммыПросмотра = "ТолстыйКлиентУправляемоеПриложение";
    #ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
        ИнформацияПрограммыПросмотра = "ТолстыйКлиент";
    #ИначеЕсли ТонкийКлиент Тогда
        ИнформацияПрограммыПросмотра = "ТонкийКлиент";
    #ИначеЕсли ВебКлиент Тогда                                                          
        ИнформацияПрограммыПросмотра = "ВебКлиент";
    #КонецЕсли
    
    СисИнфоИнформация.Вставить("ИнформацияПрограммыПросмотра", ИнформацияПрограммыПросмотра);
    
    Возврат СисИнфоИнформация; 
    
КонецФункции

Процедура УстановитьПараметрыПриложенияЦентрМониторинга(Параметр, Значение)
	ИмяПараметра = "СтандартныеПодсистемы.ЦентрМониторинга";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		Возврат;
	Иначе
		ЦентрМониторингаПараметрыПриложения = ПараметрыПриложения["СтандартныеПодсистемы.ЦентрМониторинга"];
		ЦентрМониторингаПараметрыПриложения.Вставить(Параметр, Значение);
	КонецЕсли;
КонецПроцедуры

Процедура ОповеститьЗапросНаПолучениеДампов() Экспорт
	ПоказатьОповещениеПользователя(НСтр("ru = 'Предоставить отчеты об ошибках'"),
			"e1cib/app/Обработка.НастройкиЦентраМониторинга.Форма.ЗапросНаСборИОтправкуОтчетовОбОшибках",
			,
			БиблиотекаКартинок.Предупреждение32,
			СтатусОповещенияПользователя.Важное, "ЗапросНаПолучениеДампов");		
КонецПроцедуры

Процедура ОповеститьЗапросНаОтправкуДампов() Экспорт
	ПоказатьОповещениеПользователя(НСтр("ru = 'Отправить отчеты об ошибках'"),
				"e1cib/app/Обработка.НастройкиЦентраМониторинга.Форма.ЗапросНаОтправкуОтчетовОбОшибках",
				,
				БиблиотекаКартинок.Предупреждение32,
				СтатусОповещенияПользователя.Важное, "ЗапросНаОтправкуДампов");
КонецПроцедуры

#КонецОбласти