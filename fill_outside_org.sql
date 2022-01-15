INSERT INTO OUTSIDE_ORG 
(
    name,
    email,
    address,
    phone,
    country
) 
VALUES
('Μουσείο Ακρόπολης',
'info@theacropolismuseum.gr',
'Διονυσίου Αρεοπαγίτου 15,11742 Αθήνα',
'2109000900',
'Greece'
),
('Εθνικό Ρωμαϊκό Μουσείο',
'mn-rm@beniculturali.it',
'Via Sant Apollianare 8, 00186 Rome',
'06684851',
'Italy'
),
('Αρχαιολογικό Μουσείο Θεσσαλονίκης',
'amth@culture.gr',
'Μανόλη Ανδρόνικου 6, 50619 Θεσσαλονίκη',
'2313310201',
'Greece'
),
('Εθνικό Αρχαιολογικό Μουσείο',
'eam@culture.gr',
'28ης Οκτωβρίου (Πατησίων) 44, 10682 Αθήνα',
'2132144800',
'Greece'
),
('Μουσείο Βασιλικών Τάφων των Αιγών',
'vergina@culture.gr',
'Αρχαιλογικός χώρος των Αιγών, 59100 Βεργίνα',
'2331092347',
'Greece'
),
('British Museum',
'info@britishmuseum.org',
'Great Russel St, WC1E 7JW London',
'2073238299',
'United Kingdom'
);

UPDATE OUTSIDE_ORG
SET name='Museo Nazionale Romano'
WHERE id=2;