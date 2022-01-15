INSERT INTO TEMPORARY VALUES 
    ((SELECT id
    FROM EXHIBIT
    WHERE id == 2), '2020-05-25', '2022-09-25'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 3), '2020-04-10', '2022-09-25'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 4), '2020-02-01', '2022-09-25'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 15), '2020-05-25', '2022-04-10'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 17), '2020-11-05', '2023-02-01'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 18), '2020-12-18', '2023-05-12'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 21), '2020-03-13', '2023-05-15'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 24), '2020-02-01', '2022-09-25'),

    ((SELECT id
    FROM EXHIBIT
    WHERE id == 26), '2020-12-18', '2023-11-25');