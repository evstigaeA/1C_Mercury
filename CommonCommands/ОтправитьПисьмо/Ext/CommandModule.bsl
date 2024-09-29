﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительныеПараметры = Новый Структура("ИмяФормыИсточникаСообщения", "");
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("УправляемаяФорма") Тогда
		ДополнительныеПараметры.ИмяФормыИсточникаСообщения = ПараметрыВыполненияКоманды.Источник.ИмяФормы;
	КонецЕсли;
	
	ШаблоныСообщенийКлиент.СформироватьСообщение(ПараметрКоманды, "Письмо",,, ДополнительныеПараметры);
КонецПроцедуры

#КонецОбласти
