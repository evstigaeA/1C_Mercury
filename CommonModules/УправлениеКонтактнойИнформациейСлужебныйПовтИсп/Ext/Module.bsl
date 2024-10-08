﻿#Область СлужебныеПроцедурыИФункции

// Определяет наличие доступности подсистемы АдресныйКлассификатор и наличие записей о регионах в регистре сведений
// АдресныеОбъекты.
//
Функция АдресныйКлассификаторДоступен() Экспорт
	ЕстьКлассификатор = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор");
	//<УВС
	//Если ЕстьКлассификатор И НЕ ОбщегоНазначения.РазделениеВключено() Тогда
	//	МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
	//	ЕстьКлассификатор = МодульАдресныйКлассификаторСлужебный.ПроверитьНачальноеЗаполнение();
	//КонецЕсли;
	
	Возврат ЕстьКлассификатор;
КонецФункции

#КонецОбласти
