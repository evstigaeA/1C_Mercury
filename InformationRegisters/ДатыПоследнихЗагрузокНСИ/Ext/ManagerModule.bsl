﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ДатыПоследнихЗагрузокНСИ", Загрузка);
	
КонецПроцедуры

// Процедура удаляет набор записей в регистре по переданным значениям структуры.
Процедура УдалитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "ДатыПоследнихЗагрузокНСИ", Загрузка);
	
КонецПроцедуры

Функция ДатаПоследнейЗагрузки(ВидОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДатыПоследнихЗагрузокНСИ.Дата КАК Дата
		|ИЗ
		|	РегистрСведений.ДатыПоследнихЗагрузокНСИ КАК ДатыПоследнихЗагрузокНСИ
		|ГДЕ
		|	ДатыПоследнихЗагрузокНСИ.ВидОперации = &ВидОперации";
	
	Запрос.УстановитьПараметр("ВидОперации", ВидОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Дата('00010101000000');
		
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Дата;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли