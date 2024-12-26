-- A
SELECT DISTINCT u.Nome
FROM Usuario u
JOIN Treinamento t ON u.ID = t.UsuarioID
JOIN Algoritmo a ON t.AlgId = a.Id
JOIN Modelo m ON t.UsuarioID = m.UsuarioID AND t.AlgId = m.AlgId AND t."Data" = m."Data"
WHERE t."Data" = '2023-12-10' AND a."Nome" = 'svm';

-- B
SELECT m.Path
FROM Modelo m
JOIN Usuario u ON m.UsuarioID = u.ID
WHERE u."Login" = 'danielcmo' AND m."Data" BETWEEN '2022-01-01' AND '2023-12-31';

-- C
SELECT DISTINCT a.Nome
FROM Algoritmo a
JOIN Modelo m ON a.Id = m.AlgId
WHERE m."Path" = '/usr/teste';

-- D
SELECT DISTINCT t.Dataset
FROM Treinamento t
JOIN Algoritmo a ON t.AlgId = a.Id
WHERE a.Tipo = 'clusterizacao';