﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПриСозданииНаСервере(Объект, ОткрытьЗаявление) Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
	   И ЗначениеЗаполнено(Объект.СостояниеЗаявления)
	   И Объект.СостояниеЗаявления <> Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено Тогда
		
		ОткрытьЗаявление = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСозданииНаСервереПриЧтенииНаСервере(Объект, Элементы) Экспорт
	
	Если ЗначениеЗаполнено(Объект.СостояниеЗаявления) Тогда
		Если Объект.СостояниеЗаявления = Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено Тогда
			
			Элементы.ФормаПоказатьЗаявлениеПоКоторомуБылПолученСертификат.Доступность = Истина;
			Элементы.ПоказатьЗаявлениеПоКоторомуБылПолученСертификат.Доступность = Истина;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеСпискаСертификатов(ЭлементУсловногоОформления) Экспорт
	
	СписокСостояний = Новый СписокЗначений;
	СписокСостояний.Добавить(Перечисления.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка());
	СписокСостояний.Добавить(Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено);
		
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СостояниеЗаявления");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = СписокСостояний;
	ЭлементОтбораДанных.Использование  = Истина;
	
КонецПроцедуры

Процедура ДополнитьЗапросПриДобавленииСертификатов(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"ЛОЖЬ КАК ЭтоЗаявление",
		"ВЫБОР
		|		КОГДА Сертификаты.СостояниеЗаявления = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		КОГДА Сертификаты.СостояниеЗаявления = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.Исполнено)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЭтоЗаявление");

КонецПроцедуры

Процедура ДополнитьЗапросСпискаСертификатов(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ДополнительноеУсловие",
		"СертификатыПереопределяемый.СостояниеЗаявления В (
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка),
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.Исполнено) )");
	
КонецПроцедуры

Процедура РеквизитыНеРедактируемыеВГрупповойОбработке(НеРедактируемыеРеквизиты) Экспорт
	
	НеРедактируемыеРеквизиты.Добавить("СостояниеЗаявления");
	НеРедактируемыеРеквизиты.Добавить("СодержаниеЗаявления");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли