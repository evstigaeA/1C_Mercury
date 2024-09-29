﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОрганизацияДляПолученияНСИ = Константы.ОрганизацияДляПолученияНСИ.Получить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияДляПолученияНСИПриИзменении(Элемент)
	
	ОрганизацияДляПолученияНСИПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияДляПолученияНСИПриИзмененииНаСервере()
	
	Константы.ОрганизацияДляПолученияНСИ.Установить(ОрганизацияДляПолученияНСИ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписка

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СписокОперацийОбходаAPLM = Новый СписокЗначений;
	СписокОперацийОбходаAPLM.Добавить(Справочники.ВидыОперацийОбменаAPI.ЗагрузкаДанныхПоВСД);
	СписокОперацийОбходаAPLM.Добавить(Справочники.ВидыОперацийОбменаAPI.ЗагрузкаДанныхПоЗаписямСкладскогоЖурнала);
	СписокОперацийОбходаAPLM.Добавить(Справочники.ВидыОперацийОбменаAPI.АдминистрированиеПользователей);
	
	СписокОперацииБезСмещенияДатыНачалаЗагрузки = Новый СписокЗначений;
	СписокОперацииБезСмещенияДатыНачалаЗагрузки.Добавить(Справочники.ВидыОперацийОбменаAPI.ПолучениеАдреснойИнформации);
	СписокОперацииБезСмещенияДатыНачалаЗагрузки.Добавить(Справочники.ВидыОперацийОбменаAPI.АдминистрированиеПользователей);
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.ВидОперации");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокОперацийОбходаAPLM;

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КоличествоПопытокПолученияРезультатаПриОшибкахAPLM.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не используется'"));
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.ВидОперации");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокОперацииБезСмещенияДатыНачалаЗагрузки;

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СмещениеДатыНачалаЗагрузки.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не используется'"));
	
КонецПроцедуры

#КонецОбласти