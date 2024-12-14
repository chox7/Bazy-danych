W tabelach  Company(name), Sales(id,seller,buyer,price) i Ownership(company,shareholder,fraction) są informacje o firmach, transakcjach miedzy firmami i udziałach jednych firm w innych. Zakładamy że: 
w strukturze udziałów reprezentowanej w tabeli Ownership nie ma cykli;
udziały, reprezentowane w kolumnie fraction, są liczbami między 0 a 1; 
udziały w każdej firmie sumują się co najwyżej do 1.  
 
Zadania
1. Bilans firmy to różnica między sumą cen jej sprzedaży a sumą cen jej zakupów. Dla każdej firmy wypisz jej bilans, posortuj malejąco po bilansie.

```sql
WITH sold AS (
    SELECT 
        Company.name AS name,
        COALESCE(SUM(Sales.price), 0) AS sum
    FROM Company
    LEFT JOIN Sales ON Sales.seller = Company.name
    GROUP BY Company.name
), 
bought AS (
    SELECT 
        Company.name AS name,
        COALESCE(SUM(Sales.price), 0) AS sum
    FROM Company
    LEFT JOIN Sales ON Sales.buyer = Company.name
    GROUP BY Company.name
)
SELECT
    Company.name AS name,
    sold.sum - bought.sum AS bilans
FROM Company 
JOIN sold ON Company.name = sold.name
JOIN bought ON Company.name = bought.name
ORDER BY bilans DESC;
```
Wypisz w kolejności alfabetycznej nazwy firm, które sprzedały coś każdemu swojemu udziałowcowi. (Jeśli firma nie ma udziałowców, to oczywiście spełnia ten warunek.)



Wypisz w kolejności alfabetycznej nazwy firm, które zawarły trzy lub mniej transakcji kupna, których łączna cena stanowi co najmniej 90% ich łącznych wydatków. (Firmy, które zawarły co najwyżej 3 transakcje kupna oczywiście spełniają ten warunek).


```
Dla każdej firmy wypisz liczbę takich zakupów, które są co najmniej dwa razy droższe niż kolejny względem ceny zakup tej firmy (kolejny zakup musi istnieć). Posortuj wyniki malejąco względem tej liczby.


Firma X jest zależna od firmy Y jeśli firma Y ma udziały w firmie X, lub ma udziały w firmie, która ma udziały w firmie X, itd. Przyjmujemy również, że każda firma jest zależna sama od siebie. (Inaczej, relacja zależności jest domknięciem przechodnio-zwrotnym odwrotności relacji bycia udziałowcem.) Transakcja jest wewnętrzna, jeśli sprzedający i kupujący są zależni od tej samej firmy. Wylicz jaki procent sumarycznej ceny wszystkich transakcji stanowi sumaryczna cena transakcji wewnętrznych. 



(*) Zysk firmy obliczamy następująco. Każda firma rozpoczyna od swojego bilansu. Następnie, przekazuje każdemu swojemu udziałowcowi ułamek bilansu zgodny z udziałem danego udziałowca. Następnie, każdy udziałowiec przekazuje stosowne ułamki otrzymanych w ten sposób kwot swoim udziałowcom, którzy przekazują stosowne ułamki swoim udziałowcom, itd. Dzięki założeniu, że struktura własności jest acykliczna, procedura ta dobiegnie końca w skończonej liczbie kroków, ograniczonej przez liczbę firm w bazie. Dla każdej firmy wylicz jej zysk, posortuj malejąco po zysku. 
Zasady
Na rozwiązanie zadań jest 120 minut.
Ocenie podlegają wykonywalne pliki z zapytaniami do bazy Oracle lub Postgres; wybór bazy należy wskazać w komentarzu w pliku. 
Rozwiązania oddajemy przez moodle'a do godziny 13:00; każde zapytanie ma swoje własne 'zadanie' w moodle'u. UWAGA: proszę użyć wersji 'zadania' dla wybranej bazy.
W każdym pliku należy w komentarzu podać imię, nazwisko, numer indeksu, grupę laboratoryjną, oraz numer zadania. 
Można korzystać z dowolnych materiałów dydaktycznych, także z internetu.
Nie wolno korzystać z żadnych narzędzi, które potrafią generować zapytania.
Nie można się porozumiewać między sobą, pytania dotyczące treści należy kierować do prowadzącego.
Dane w pliku są jedynie przykładem; zapytania powinny działać dla dowolnych danych zgodnych z definicją tabel.
Wszystkie zadania są punktowane tak samo, w skali 0-5 pkt; za brzydkie lub nieefektywne sformułowanie zapytania można utracić co najwyżej 1 pkt. 
Zadanie 6 jest dodatkowe: można dzięki niemu uzyskać z klasówki więcej niż 25 punktów, co przybliża do otrzymania oceny 5! z całego przedmiotu. 