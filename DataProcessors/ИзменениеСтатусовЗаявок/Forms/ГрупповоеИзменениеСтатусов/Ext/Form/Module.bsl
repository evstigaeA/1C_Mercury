﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Документ = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Предусмотрено открытие обработки только из списка документов.'");
	КонецЕсли;
	
	ИмяДокумента = Параметры.Документ.Метаданные().Имя;
	
	ВидДокумента = Элементы.ВидДокумента.СписокВыбора.НайтиПоЗначению(ИмяДокумента).Значение;
	
	Период.Вариант = ВариантСтандартногоПериода.Сегодня;
	
	МассивРазрешенныхСтатусов = Обработки.ИзменениеСтатусовЗаявок.СтатусыРазрешенныеДляИзменения();
	
	Элементы.ТекущийСтатус.СписокВыбора.ЗагрузитьЗначения(МассивРазрешенныхСтатусов);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСтатусПриИзменении(Элемент)
	
	Элементы.СтатусПослеИзменения.СписокВыбора.Очистить();
	
	Если ТекущийСтатус = ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Новая") Тогда
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ЗаявкаОтмененаАдминистратором"));
	ИначеЕсли ТекущийСтатус = ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Отправлена") Тогда
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ЗаявкаОтмененаАдминистратором"));
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Новая"));
	ИначеЕсли ТекущийСтатус = ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ОшибкаОтправкиID") Тогда
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ЗаявкаОтмененаАдминистратором"));
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Новая"));
	ИначеЕсли ТекущийСтатус = ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Обрабатывается") Тогда
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ЗаявкаОтмененаАдминистратором"));
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Новая"));
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.IDПолучен"));
	ИначеЕсли ТекущийСтатус = ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ОшибкаОбработкиОтвета") Тогда
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ЗаявкаОтмененаАдминистратором"));
		Элементы.СтатусПослеИзменения.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.IDПолучен"));
	КонецЕсли;
	
	СтатусПослеИзменения = ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ЗаявкаОтмененаАдминистратором");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьИзменениеСтатусовЗаявокНаСервере(ТекстОшибки)
	
	Если Не Обработки.ИзменениеСтатусовЗаявок.ПроверитьРаботуФоновыхЗаданий(ВидДокумента, ТекстОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка КАК ДокументСсылка,
		|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.GUID_Меркурий КАК ИдентификаторЗаявки,
		|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
		|ГДЕ
		|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус = &Статус
		|	И ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка ССЫЛКА &ВидДокумента";
	
	Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&ВидДокумента", "Документ." + ВидДокумента);
	
	Запрос.УстановитьПараметр("ДатаНачала",    НачалоДня(Период.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("Статус",        ТекущийСтатус);
	
	МассивОшибок = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОписаниеОшибки = "";
		
		Обработки.ИзменениеСтатусовЗаявок.УстановитьТекущийСтатусЗаяки(Выборка.ДокументСсылка,
					Выборка.Статус, СтатусПослеИзменения, Выборка.ИдентификаторЗаявки, ОписаниеОшибки);
					
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По документу %1 изменение статуса не выполнено по причине:
									|%2'"), Выборка.ДокументСсылка, ОписаниеОшибки);
			
			МассивОшибок.Добавить(ПредставлениеОшибки);
			
		КонецЕсли;
	
	КонецЦикла;
	
	Если МассивОшибок.Количество() > 0 Тогда
		
		ТекстОшибки = СтрСоединить(МассивОшибок, Символы.ПС);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьИзменениеСтатусовЗаявок(Команда)
	
	ТекстОшибки = "";
	
	Если ПроверитьЗаполнение() Тогда
		
		ВыполнитьИзменениеСтатусовЗаявокНаСервере(ТекстОшибки);
		
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Изменение статусов заявок выполнено.'"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти