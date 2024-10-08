﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МассивКонтрагентов = ПараметрКоманды;
	
	РезультатВыполненияОперации = ИнтеграцияВетисAPIВызовСервера.ПолучитьАктуальныеДанныеПоКонтрагентам(МассивКонтрагентов);
	
	Если ЗначениеЗаполнено(РезультатВыполненияОперации.ОписаниеОшибки) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Операция не выполнена:'") + РезультатВыполненияОперации.ОписаниеОшибки);

	Иначе
		
		ТекстОшибки = НСтр("ru = 'При выполнении операции по хоз. субъекту <%1> произошли ошибки:
							|%2'");

		ТекстУспешногоВыполнения = НСтр("ru = 'Выполнение операции по хоз. субъекту <%1> прошло успешно.'");
		
		ДанныеРезультата = РезультатВыполненияОперации.Контрагент;
		
		Для Каждого ТекРезультат Из ДанныеРезультата Цикл
			
			Если ЗначениеЗаполнено(ТекРезультат.ОписаниеОшибки) Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ТекРезультат.Контрагент, ТекРезультат.ОписаниеОшибки), ТекРезультат.Контрагент);
							
			Иначе
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстУспешногоВыполнения, ТекРезультат.Контрагент), ТекРезультат.Контрагент);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Оповестить("ОбновлениеДанныхКонтрагента");
	
КонецПроцедуры

#КонецОбласти