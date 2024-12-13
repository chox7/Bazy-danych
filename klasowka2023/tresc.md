W tabelach  port(nazwa), statek(nazwa,ladownosc), rejs(numer,skad,dokad,poczatek,koniec,statek) i manifest(rejs,towar,ilosc) są o informacje o rejsach towarowych (manifest to inaczej lista przewozowa). Ładowność statków i ilość towaru są podane w tych samych jednostkach umownych. Początek i koniec rejsu są podane jako liczba umownych jednostek czasu, które upłynęły od umownego momentu 0 (podobnie jak w Unix timestamp). Koniec rejsu jest zawsze ściśle późniejszy niż jego początek.  Poszczególne rejsy tego samego statku nie zachodzą na siebie w czasie (początek kolejnego rejsu jest ściśle późniejszy, niż koniec poprzedniego). 
 
# Zadania

1. Wypisz wszystkie przypadki, w których pewien rejs statku zaczyna się gdzie indziej niż poprzedni się skończył. Wypisz nazwę statku, miejsce i czas zakończenia poprzedniego rejsu oraz miejsce i czas rozpoczęcia kolejnego rejsu.  

```sql

WITH poprzedni_rejs AS (
    SELECT 
        A.numer AS numer, MAX(B.numer) AS poprzedni
    FROM rejs A
    JOIN rejs B ON A.statek = B.statek
    WHERE B.koniec < A.poczatek
    GROUP BY A.numer
)
SELECT A.statek,
    A.dokad AS old_dokad, A.koniec AS old_end,
    B.skad AS new_skad, B.poczatek AS new_beg
FROM rejs B
RIGHT JOIN poprzedni_rejs ON B.numer = poprzedni_rejs.numer
LEFT JOIN rejs A ON A.numer = poprzedni_rejs.poprzedni
WHERE A.dokad <> B.skad;

```

2. Dla każdego portu wypisz jego bilans masowy, tj. różnicę między sumą przywiezionych i wywiezionych towarów. Posortuj malejąco wg. bilansu.

```sql
WITH wplynelo AS (
    SELECT 
        port.nazwa AS nazwa,
        COALESCE(SUM(ilosc), 0) AS suma
    FROM port
    LEFT JOIN rejs ON rejs.dokad = port.nazwa
    LEFT JOIN manifest ON manifest.rejs = rejs.numer
    GROUP BY port.nazwa
), 
wyplynelo AS (
    SELECT 
        port.nazwa AS nazwa,
        COALESCE(SUM(ilosc), 0) AS suma
    FROM port
    LEFT JOIN rejs ON rejs.skad = port.nazwa
    LEFT JOIN manifest ON manifest.rejs = rejs.numer
    GROUP BY port.nazwa
)
SELECT
    port.nazwa AS nazwa,
    wplynelo.suma - wyplynelo.suma AS bilans
FROM port 
LEFT JOIN wplynelo ON wplynelo.nazwa = port.nazwa
LEFT JOIN wyplynelo ON wyplynelo.nazwa = port.nazwa
ORDER BY wplynelo.suma - wyplynelo.suma DESC;
```

3. Wypisz nazwy statków, które w co najmniej połowie rejsów wykorzystały co najwyżej połowę swojej ładowności (pomiń statki, które nie odbyły żadnego rejsu). Posortuj je malejąco, wg. sumarycznej masy przewiezionych kiedykolwiek towarów (ale jej nie wypisuj). 

```sql
WITH liczba_rejsow AS (
    SELECT 
        rejs.statek AS statek,
        COUNT(*) AS l_rejsow
    FROM rejs
    GROUP BY rejs.statek
),
co_najwyzej_polowe AS (
    SELECT 
        rejs.numer AS numer,
        SUM(ilosc) AS suma
    FROM rejs
    LEFT JOIN manifest ON manifest.rejs = rejs.numer
    LEFT JOIN statek ON statek.nazwa = rejs.statek
    GROUP BY rejs.numer
    HAVING SUM(ilosc) <= MAX(ladownosc) / 2 OR COUNT(manifest.rejs) = 0
),
statek_suma AS (
    SELECT 
        rejs.statek AS statek,
        SUM(ilosc) AS suma
    FROM rejs
    LEFT JOIN manifest ON manifest.rejs = rejs.numer
    GROUP BY rejs.statek
)
SELECT 
    rejs.statek
FROM rejs
RIGHT JOIN liczba_rejsow ON liczba_rejsow.statek = rejs.statek
RIGHT JOIN co_najwyzej_polowe ON co_najwyzej_polowe.numer = rejs.numer
LEFT JOIN statek_suma ON statek_suma.statek = rejs.statek
GROUP BY rejs.statek
HAVING COUNT(*) >= MAX(liczba_rejsow.l_rejsow) / 2
ORDER BY  MAX(statek_suma.suma) DESC;
```

4. Wyznacz liczbę rejsów, w których 3 towary o największej masie stanowią łącznie co najwyżej połowę całkowitej masy towarów. 

```sql
WITH rejs_towar AS (
    SELECT 
        rejs.numer
    FROM rejs
    LEFT JOIN manifest ON manifest.rejs = rejs.numer
    GROUP BY rejs.numer, manifest.towar
)
```

5. W czasie rejsu 111 rozszczelnił się przewożony pojemnik z groźnym wirusem, który natychmiast zainfekował całą załogę. Przyjmijmy, że zainfekowany rejs infekuje port docelowy w momencie dotarcia do niego, a zainfekowany port infekuje wszystkie ściśle późniejsze loty z niego wyruszające. Dla każdego portu wypisz kiedy zostanie zainfekowany. (Pomiń porty, które nie zostaną zainfekowane). 

```sql

```

6. (*) Służby sanitarne portów docelowych zarejestrowały przypadki epidemii wśród załóg rejsów 222,  333 i 444. Wcześniej w tych trzech portach nie wykryto żadnych przypadków epidemii, mimo kontrolowania każdej przybywającej załogi. W innych portach nie ma kontroli sanitarnych, co sprawiło, że epidemia mogła się rozprzestrzenić. Przyjmijmy, że epidemia rozwija się zgodnie z regułami opisanymi w zadaniu 5. Służby sanitarne podejrzewają, że epidemia miała swoje źródło w pewnym pojedynczym rejsie, ale nie wiedzą w którym.  Wypisz wszystkie rejsy, które mogły być źródłem epidemii.

# Zasady

Na rozwiązanie zadań jest 120 minut.

Ocenie podlegają wykonywalne pliki z zapytaniami do bazy Oracle lub Postgres; wybór bazy należy wskazać w komentarzu w pliku. 

Rozwiązania oddajemy przez moodle'a do godziny 13:00; każde zapytanie ma swoje własne 'zadanie' w moodle'u. UWAGA: proszę użyć wersji 'zadania' dla wybranej bazy.

W każdym pliku należy w komentarzu podać imię, nazwisko, numer indeksu, grupę laboratoryjną, oraz numer zadania. 

Można korzystać z dowolnych materiałów dydaktycznych, także z internetu.

Nie wolno korzystać z żadnych narzędzi, które potrafią generować zapytania.

Nie można się porozumiewać między sobą, pytania dotyczące treści należy kierować do prowadzącego.

Dane w pliku są jedynie przykładem; zapytania powinny działać dla dowolnych danych zgodnych z definicją tabel.

Wszystkie zadania są punktowane tak samo, w skali 0-5 pkt; za brzydkie lub nieefektywne sformułowanie zapytania można utracić co najwyżej 1 pkt. 