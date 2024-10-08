﻿
#Область ОбработкаСправочникаПользователиСистемыМеркурий

#Область ОбменСВетисAPI

Процедура ВыполнитьЗаявкуНаИзменениеСвойствПользователей(ПараметрыОбмена, АдресРезультата) Экспорт

	ОбъектСЛК = ОбщегоНазначенияУВССервер.СоздатьОбъектСЛК("ИнтеграцияВетисAPIПользователи");

	Если Не ОбъектСЛК = Неопределено Тогда
		ОбъектСЛК.ВыполнитьЗаявкуНаИзменениеСвойствПользователей(ПараметрыОбмена, АдресРезультата);
	КонецЕсли;

КонецПроцедуры

Процедура ПолучениеДанныхПользователей(ПараметрыОбмена, АдресРезультата) Экспорт

	ОбъектСЛК = ОбщегоНазначенияУВССервер.СоздатьОбъектСЛК("ИнтеграцияВетисAPIПользователи");

	Если Не ОбъектСЛК = Неопределено Тогда
		ОбъектСЛК.ПолучениеДанныхПользователей(ПараметрыОбмена, АдресРезультата);
	КонецЕсли;

КонецПроцедуры

Процедура СписокПользователейКонтрагента(ПараметрыОперации, АдресРезультата, АдресДополнительногоРезультата) Экспорт

	ОбъектСЛК = ОбщегоНазначенияУВССервер.СоздатьОбъектСЛК("ИнтеграцияВетисAPIПользователи");

	Если Не ОбъектСЛК = Неопределено Тогда
		ОбъектСЛК.СписокПользователейКонтрагента(ПараметрыОперации, АдресРезультата, АдресДополнительногоРезультата);
	КонецЕсли;

КонецПроцедуры

Процедура СписокПравПользователейСистемыМеркурий(ПараметрыОперации, АдресРезультата) Экспорт

	ОбъектСЛК = ОбщегоНазначенияУВССервер.СоздатьОбъектСЛК("ИнтеграцияВетисAPIПользователи");

	Если Не ОбъектСЛК = Неопределено Тогда
		ОбъектСЛК.СписокПравПользователейСистемыМеркурий(ПараметрыОперации, АдресРезультата);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ВнутренниеПроцедурыИФункции

Функция ПользовательМеркурияПоДаннымXDTO(ПользовательXDTO, ПользовательСсылка = Неопределено, ТребуютсяПрава = Истина, СобственныйПользователь = Истина) Экспорт

	ОбъектСЛК = ОбщегоНазначенияУВССервер.СоздатьОбъектСЛК("ИнтеграцияВетисAPIПользователи");

	Если Не ОбъектСЛК = Неопределено Тогда
		Возврат ОбъектСЛК.ПользовательМеркурияПоДаннымXDTO(ПользовательXDTO, ПользовательСсылка, ТребуютсяПрава, СобственныйПользователь);
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецОбласти
