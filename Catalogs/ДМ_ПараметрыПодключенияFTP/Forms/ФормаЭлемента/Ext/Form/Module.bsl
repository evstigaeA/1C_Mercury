﻿
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПустаяСтрока(Объект.IPАдрес) И ПустаяСтрока(Объект.ДоменноеИмя) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не могут быть одновременно пустыми оба поля Доменное имя и IP-Адрес");
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗащищенноеСоединениеПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗащищенноеСоединениеПриИзменении()
	
КонецПроцедуры
